import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart';

import '../game/catalog.dart';
import '../l10n/app_localizations.dart';
import 'accessories.dart';
import 'palette.dart';
import 'poop.dart';
import 'sprites.dart';

enum Reaction { love, eat, refuse, relief, cured, cleaned, chomp, walk }

enum Face { normal, happy, asleep, sick, grumpy }

/// What Chigüi is thinking about, shown in a thought bubble.
enum Bubble { potty, sleepy, sick, food, affection, fun }

/// Placeholder Chigüi, a sitting capybara drawn in code, until the real
/// artwork exists. It breathes and blinks, shows its [face] and [bubble],
/// any uncleaned [messes], and plays [reaction] each time [reactionId]
/// changes.
class ChiguiView extends StatefulWidget {
  const ChiguiView({
    super.key,
    required this.size,
    this.face = Face.normal,
    this.wearing = const {},
    this.bubble,
    this.messes = 0,
    this.onTap,
    this.onCleanMess,
    this.reaction,
    this.reactionId = 0,
    this.onReactionEnd,
  });

  final double size;
  final Face face;
  final Map<Slot, String> wearing;
  final Bubble? bubble;
  final int messes;
  final VoidCallback? onTap;
  final VoidCallback? onCleanMess;
  final Reaction? reaction;
  final int reactionId;
  final VoidCallback? onReactionEnd;

  @override
  State<ChiguiView> createState() => _ChiguiViewState();
}

class _ChiguiViewState extends State<ChiguiView> with TickerProviderStateMixin {
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );
  late final AnimationController _react = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..addStatusListener(_onReactStatus);

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _idle.value = 0;
    } else if (!_idle.isAnimating) {
      _idle.repeat();
    }
  }

  @override
  void didUpdateWidget(ChiguiView old) {
    super.didUpdateWidget(old);
    if (widget.reactionId != old.reactionId && widget.reaction != null) {
      _react.duration = switch (widget.reaction!) {
        Reaction.chomp => const Duration(milliseconds: 700),
        Reaction.walk => const Duration(milliseconds: 1600),
        _ => const Duration(milliseconds: 1200),
      };
      _react.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _idle.dispose();
    _react.dispose();
    super.dispose();
  }

  void _onReactStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onReactionEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = widget.size;

    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_idle, _react]),
        builder: (context, _) {
          final reaction = _react.isAnimating ? widget.reaction : null;
          final t = _reduceMotion ? 0.0 : _react.value;
          final (scaleX, scaleY) = _scales(reaction);
          final (dx, dy) = _offset(reaction);
          final walking = reaction == Reaction.walk && !_reduceMotion;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Semantics(
                  button: true,
                  label: l10n.chiguiName,
                  onTapHint: l10n.petAction,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onTap,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.translationValues(dx, dy, 0)
                        ..multiply(Matrix4.diagonal3Values(scaleX, scaleY, 1)),
                      child: CustomPaint(
                        painter: _ChiguiPainter(
                          face: _face(reaction),
                          blink: _isBlinking(),
                          mouthOpen: reaction == Reaction.chomp
                              ? _chompOpen(t)
                              : 0,
                          cheekPuff: reaction == Reaction.chomp
                              ? _chompPuff(t)
                              : 0,
                          legLift: walking ? math.sin(t * 4 * math.pi) : 0,
                          wearing: widget.wearing,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < math.min(widget.messes, 3); i++)
                _mess(size, i, l10n),
              if (widget.face == Face.asleep && reaction == null)
                ..._sleepingZs(size),
              if (widget.face == Face.sick && reaction == null)
                Positioned(
                  left: size * 0.86,
                  top: size * 0.2,
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.thermostat,
                      color: Palette.blush,
                      size: size * 0.12,
                    ),
                  ),
                ),
              if (reaction == Reaction.love)
                _floating(size, t, Icons.favorite, Palette.blush),
              if (reaction == Reaction.eat)
                _floating(size, t, Icons.eco, Palette.leaf),
              if (reaction == Reaction.relief || reaction == Reaction.cleaned)
                _floating(size, t, Icons.auto_awesome, Palette.sparkle),
              if (reaction == Reaction.cured) ..._vet(size, t),
              if (reaction == Reaction.chomp) ..._chomp(size, t, l10n),
              if (reaction == Reaction.walk)
                Positioned(
                  left: size * (0.05 + 0.1 * t),
                  top: size * 0.86,
                  child: ExcludeSemantics(
                    child: Opacity(
                      opacity: 1 - t,
                      child: Footprints(size: size * 0.14),
                    ),
                  ),
                ),
              if (reaction == null && widget.bubble != null)
                _bubble(size, widget.bubble!),
            ],
          );
        },
      ),
    );
  }

  Face _face(Reaction? reaction) => switch (reaction) {
    Reaction.love ||
    Reaction.eat ||
    Reaction.relief ||
    Reaction.cleaned => Face.happy,
    Reaction.cured => _react.value > 0.5 ? Face.happy : Face.sick,
    // Wide-eyed while opening wide, blissful while chewing.
    Reaction.chomp => _react.value < 0.3 ? Face.normal : Face.happy,
    Reaction.walk => Face.happy,
    _ => widget.face,
  };

  bool _isBlinking() =>
      !_reduceMotion && _idle.value > 0.9 && _idle.value < 0.93;

  (double, double) _scales(Reaction? reaction) {
    if (_reduceMotion) return (1, 1);
    // Slower, deeper breaths while asleep.
    final asleep = widget.face == Face.asleep;
    final breath = math.sin(_idle.value * (asleep ? 2 : 4) * math.pi);
    var scaleX = 1 - (asleep ? 0.015 : 0.01) * breath;
    var scaleY = 1 + (asleep ? 0.03 : 0.02) * breath;
    final bounceFrom = switch (reaction) {
      Reaction.love ||
      Reaction.eat ||
      Reaction.relief ||
      Reaction.cleaned => 0.0,
      Reaction.cured => 0.5,
      _ => null,
    };
    if (reaction == Reaction.chomp) return _chompScales(_react.value);
    if (reaction == Reaction.walk) {
      final landing = 1 - math.sin(_react.value * 4 * math.pi).abs();
      return (1 + 0.03 * landing, 1 - 0.04 * landing);
    }
    if (bounceFrom != null && _react.value >= bounceFrom) {
      // Squash, stretch, then settle.
      final t = ((_react.value - bounceFrom) / 0.5).clamp(0.0, 1.0);
      if (t < 0.25) {
        final k = t / 0.25;
        scaleX = lerpDouble(1, 1.12, k)!;
        scaleY = lerpDouble(1, 0.88, k)!;
      } else if (t < 0.55) {
        final k = (t - 0.25) / 0.3;
        scaleX = lerpDouble(1.12, 0.94, k)!;
        scaleY = lerpDouble(0.88, 1.10, k)!;
      } else {
        final k = Curves.easeOut.transform(((t - 0.55) / 0.45).clamp(0.0, 1.0));
        scaleX = lerpDouble(0.94, scaleX, k)!;
        scaleY = lerpDouble(1.10, scaleY, k)!;
      }
    }
    return (scaleX, scaleY);
  }

  (double, double) _offset(Reaction? reaction) {
    if (_reduceMotion) return (0, 0);
    final t = _react.value;
    final size = widget.size;
    return switch (reaction) {
      // A gentle "no, thanks" side-to-side wobble.
      Reaction.refuse => (math.sin(t * 6 * math.pi) * size * 0.03 * (1 - t), 0),
      // Four little hops forward and back.
      Reaction.walk => (
        math.sin(t * 2 * math.pi) * size * 0.08,
        -math.sin(t * 4 * math.pi).abs() * size * 0.05,
      ),
      _ => (0, 0),
    };
  }

  // The chomp: open very wide (0–0.3), snap shut (0.3–0.42), then chew with
  // puffed cheeks while crumbs fly and a "Chomp!" pops out.

  double _chompOpen(double t) {
    if (_reduceMotion) return 0;
    if (t < 0.3) return Curves.easeOut.transform(t / 0.3);
    if (t < 0.4) return 1 - (t - 0.3) / 0.1;
    return 0;
  }

  double _chompPuff(double t) {
    if (t < 0.38) return 0;
    final k = (t - 0.38) / 0.62;
    final chew = _reduceMotion ? 1 : 0.85 + 0.15 * math.sin(k * 6 * math.pi);
    return (1 - k * k) * chew;
  }

  (double, double) _chompScales(double t) {
    if (t < 0.3) {
      final k = Curves.easeOut.transform(t / 0.3);
      return (1 - 0.06 * k, 1 + 0.14 * k);
    }
    if (t < 0.42) {
      final k = (t - 0.3) / 0.12;
      return (lerpDouble(0.94, 1.2, k)!, lerpDouble(1.14, 0.82, k)!);
    }
    final k = ((t - 0.42) / 0.58).clamp(0.0, 1.0);
    final settle = Curves.easeOut.transform(k);
    final wobble = 0.04 * math.sin(k * 6 * math.pi) * (1 - k);
    return (
      lerpDouble(1.2, 1, settle)! + wobble,
      lerpDouble(0.82, 1, settle)! - wobble,
    );
  }

  List<Widget> _chomp(double size, double t, AppLocalizations l10n) {
    if (t < 0.32) return const [];
    final k = (t - 0.32) / 0.68;
    final pop = k < 0.2
        ? lerpDouble(0.3, 1.3, k / 0.2)!
        : k < 0.35
        ? lerpDouble(1.3, 1, (k - 0.2) / 0.15)!
        : 1.0;
    final fade = k > 0.7 ? 1 - (k - 0.7) / 0.3 : 1.0;
    const colors = [Palette.melon, Palette.orange, Palette.leaf];
    final mouth = Offset(size * 0.84, size * 0.48);
    return [
      // Crumbs fly out of the mouth and fall.
      for (var i = 0; i < 7; i++)
        () {
          final angle = -math.pi * (0.15 + 0.7 * i / 6);
          final reach = size * 0.32 * k;
          return Positioned(
            left: mouth.dx + math.cos(angle) * reach,
            top: mouth.dy + math.sin(angle) * reach + size * 0.3 * k * k,
            child: ExcludeSemantics(
              child: Opacity(
                opacity: 1 - k,
                child: Container(
                  width: size * 0.045,
                  height: size * 0.045,
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        }(),
      Positioned(
        left: size * 0.5,
        top: -size * 0.14,
        child: ExcludeSemantics(
          child: Opacity(
            opacity: fade,
            child: Transform.rotate(
              angle: -0.2,
              child: Transform.scale(
                scale: _reduceMotion ? 1 : pop,
                child: Text(
                  l10n.chompSound,
                  style: TextStyle(
                    fontSize: size * 0.18,
                    fontWeight: FontWeight.w900,
                    color: Palette.ink,
                    decoration: TextDecoration.none,
                    shadows: const [
                      Shadow(color: Palette.cloud, offset: Offset(2, 2)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _floating(double size, double t, IconData icon, Color color) {
    return Positioned(
      left: size * 0.66,
      top: size * (0.02 - 0.2 * t),
      child: ExcludeSemantics(
        child: Opacity(
          opacity: 1 - t,
          child: Icon(icon, color: color, size: size * 0.16),
        ),
      ),
    );
  }

  /// A tiny syringe glides in, a sparkly "boop", and Chigüi feels better.
  List<Widget> _vet(double size, double t) {
    final glide = Curves.easeOut.transform((t / 0.35).clamp(0.0, 1.0));
    return [
      if (t < 0.55)
        Positioned(
          left: size * lerpDouble(1.0, 0.66, glide)!,
          top: size * 0.62,
          child: ExcludeSemantics(
            child: Icon(Icons.vaccines, color: Palette.ink, size: size * 0.14),
          ),
        ),
      if (t >= 0.35)
        Positioned(
          left: size * 0.6,
          top: size * (0.5 - 0.3 * (t - 0.35)),
          child: ExcludeSemantics(
            child: Opacity(
              opacity: (1 - t) / 0.65,
              child: Icon(
                Icons.auto_awesome,
                color: Palette.sparkle,
                size: size * 0.16,
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _sleepingZs(double size) => [
    for (var i = 0; i < 3; i++)
      () {
        final rise = _reduceMotion ? i / 3 : (_idle.value + i / 3) % 1;
        return Positioned(
          left: size * (0.8 + 0.08 * rise),
          top: size * (0.18 - 0.2 * rise),
          child: ExcludeSemantics(
            child: Opacity(
              opacity: 1 - rise,
              child: CustomPaint(
                size: Size.square(size * (0.06 + 0.04 * rise)),
                painter: _ZPainter(),
              ),
            ),
          ),
        );
      }(),
  ];

  Widget _mess(double size, int index, AppLocalizations l10n) {
    final poopSize = math.max(48.0, size * 0.18);
    return Positioned(
      left: size * (-0.06 + 0.15 * index),
      top: size * 0.8,
      child: Semantics(
        button: true,
        label: l10n.cleanAction,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onCleanMess,
          child: Poop(size: poopSize, smelly: true, phase: _idle.value),
        ),
      ),
    );
  }

  Widget _bubble(double size, Bubble bubble) {
    final iconSize = size * 0.13;
    final content = switch (bubble) {
      Bubble.potty => Poop(size: iconSize * 1.2),
      Bubble.sleepy => Icon(Icons.bedtime, color: Palette.ink, size: iconSize),
      Bubble.sick => Icon(
        Icons.thermostat,
        color: Palette.blush,
        size: iconSize,
      ),
      Bubble.food => Icon(Icons.eco, color: Palette.leaf, size: iconSize),
      Bubble.affection => Icon(
        Icons.favorite,
        color: Palette.blush,
        size: iconSize,
      ),
      Bubble.fun => Icon(
        Icons.sports_esports,
        color: Palette.furDark,
        size: iconSize,
      ),
    };
    const dot = BoxDecoration(color: Palette.cloud, shape: BoxShape.circle);
    return Positioned(
      left: size * 0.04,
      top: size * 0.02,
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size * 0.34,
          child: Stack(
            children: [
              Positioned(
                right: size * 0.02,
                bottom: 0,
                child: Container(
                  width: size * 0.04,
                  height: size * 0.04,
                  decoration: dot,
                ),
              ),
              Positioned(
                right: size * 0.06,
                bottom: size * 0.05,
                child: Container(
                  width: size * 0.06,
                  height: size * 0.06,
                  decoration: dot,
                ),
              ),
              Container(
                width: size * 0.24,
                height: size * 0.24,
                alignment: Alignment.center,
                decoration: dot,
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A still Chigüi wearing [wearing], e.g. to preview items in the shop.
class ChiguiPortrait extends StatelessWidget {
  const ChiguiPortrait({
    super.key,
    required this.size,
    this.wearing = const {},
    this.face = Face.normal,
  });

  final double size;
  final Map<Slot, String> wearing;
  final Face face;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _ChiguiPainter(face: face, blink: false, wearing: wearing),
  );
}

/// A hand-drawn "z" for sleeping, so no text or font is needed.
class _ZPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.15, w * 0.15)
        ..lineTo(w * 0.85, w * 0.15)
        ..lineTo(w * 0.15, w * 0.85)
        ..lineTo(w * 0.85, w * 0.85),
      Paint()
        ..color = Palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.16
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ZPainter old) => false;
}

class _ChiguiPainter extends CustomPainter {
  _ChiguiPainter({
    required this.face,
    required this.blink,
    this.mouthOpen = 0,
    this.cheekPuff = 0,
    this.legLift = 0,
    this.wearing = const {},
  });

  final Face face;
  final bool blink;

  /// 0 closed … 1 wide open, for the chomp.
  final double mouthOpen;

  /// 0 normal … 1 cheek full of fruit.
  final double cheekPuff;

  /// -1 … 1: positive lifts the near front leg, negative the far one.
  final double legLift;

  /// Accessories worn, by slot.
  final Map<Slot, String> wearing;

  void _accessories(Canvas canvas, Size size, Layer layer) {
    for (final id in wearing.values) {
      paintAccessory(canvas, size, id, layer);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fur = Paint()
      ..color = face == Face.sick
          ? Color.lerp(Palette.fur, Palette.sickTint, 0.45)!
          : Palette.fur;
    final furDark = Paint()..color = Palette.furDark;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.014
      ..strokeJoin = StrokeJoin.round;

    void shape(RRect r, Paint fill) {
      canvas.drawRRect(r, fill);
      canvas.drawRRect(r, outline);
    }

    _accessories(canvas, size, Layer.behind);

    // Ground shadow.
    canvas.drawOval(
      Rect.fromLTRB(w * 0.1, h * 0.88, w * 0.82, h * 0.98),
      Paint()..color = Palette.ink.withValues(alpha: 0.12),
    );

    // Legs step forward in turn while walking.
    final nearLift = math.max(0.0, legLift) * h * 0.05;
    final farLift = math.max(0.0, -legLift);

    // Far front leg, behind the body.
    shape(
      RRect.fromLTRBR(
        w * (0.6 + 0.06 * farLift),
        h * 0.74 - farLift * h * 0.05,
        w * (0.7 + 0.06 * farLift),
        h * 0.93 - farLift * h * 0.05,
        Radius.circular(w * 0.05),
      ),
      furDark,
    );

    // Body: a round, sitting loaf facing right.
    shape(
      RRect.fromLTRBAndCorners(
        w * 0.1,
        h * 0.4,
        w * 0.72,
        h * 0.93,
        topLeft: Radius.elliptical(w * 0.3, h * 0.3),
        topRight: Radius.elliptical(w * 0.2, h * 0.2),
        bottomLeft: Radius.elliptical(w * 0.22, h * 0.2),
        bottomRight: Radius.circular(w * 0.1),
      ),
      fur,
    );

    // Near front leg.
    shape(
      RRect.fromLTRBR(
        w * 0.48,
        h * 0.76 - nearLift,
        w * 0.59,
        h * 0.95 - nearLift,
        Radius.circular(w * 0.05),
      ),
      fur,
    );

    _accessories(canvas, size, Layer.overBody);

    // Far ear, peeking behind the head.
    canvas.drawCircle(Offset(w * 0.56, h * 0.19), w * 0.05, furDark);
    canvas.drawCircle(Offset(w * 0.56, h * 0.19), w * 0.05, outline);

    // Head: long and boxy, ending in a blunt muzzle.
    final head = RRect.fromLTRBAndCorners(
      w * 0.34,
      h * 0.2,
      w * 0.88,
      h * 0.6,
      topLeft: Radius.elliptical(w * 0.18, h * 0.18),
      topRight: Radius.circular(w * 0.12),
      bottomLeft: Radius.circular(w * 0.14),
      bottomRight: Radius.circular(w * 0.12),
    );
    canvas.drawRRect(head, fur);

    // Muzzle patch, slightly darker, with a nostril.
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.7,
        h * 0.3,
        w * 0.88,
        h * 0.56,
        Radius.circular(w * 0.09),
      ),
      Paint()..color = Palette.muzzle,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.83, h * 0.36),
        width: w * 0.04,
        height: h * 0.022,
      ),
      Paint()..color = Palette.ink,
    );

    canvas.drawRRect(head, outline);

    // Near ear.
    canvas.drawCircle(Offset(w * 0.44, h * 0.22), w * 0.055, fur);
    canvas.drawCircle(Offset(w * 0.44, h * 0.22), w * 0.055, outline);
    canvas.drawCircle(Offset(w * 0.44, h * 0.225), w * 0.028, furDark);

    // Cheek, bulging when full of fruit.
    if (cheekPuff > 0) {
      final bulge = Offset(w * 0.64, h * 0.5);
      final radius = w * (0.06 + 0.05 * cheekPuff);
      canvas.drawCircle(bulge, radius, fur);
      canvas.drawArc(
        Rect.fromCircle(center: bulge, radius: radius),
        0.2,
        math.pi - 0.4,
        false,
        outline,
      );
    }
    canvas.drawCircle(
      Offset(w * 0.6, h * (0.45 + 0.04 * cheekPuff)),
      w * (0.045 + 0.02 * cheekPuff),
      Paint()..color = Palette.blush.withValues(alpha: 0.8),
    );

    // Eye, brow, and mouth show the mood.
    final stroke = Paint()
      ..color = Palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    final eye = Offset(w * 0.6, h * 0.34);
    final eyeBox = Rect.fromCircle(
      center: eye.translate(0, w * 0.015),
      radius: w * 0.035,
    );
    switch (face) {
      case Face.happy:
        canvas.drawArc(eyeBox, math.pi, math.pi, false, stroke);
      case Face.asleep:
        canvas.drawArc(
          eyeBox.shift(Offset(0, -w * 0.03)),
          0,
          math.pi,
          false,
          stroke,
        );
      case _ when blink:
        canvas.drawLine(
          eye.translate(-w * 0.03, 0),
          eye.translate(w * 0.03, 0),
          stroke,
        );
      case Face.sick:
        // Droopy, half-closed eye and a little sweat drop.
        canvas.drawArc(
          Rect.fromCircle(center: eye, radius: w * 0.028),
          0,
          math.pi,
          true,
          Paint()..color = Palette.ink,
        );
        canvas.drawLine(
          eye.translate(-w * 0.035, 0),
          eye.translate(w * 0.035, 0),
          stroke,
        );
        canvas.drawPath(
          Path()
            ..moveTo(w * 0.5, h * 0.27)
            ..quadraticBezierTo(w * 0.47, h * 0.32, w * 0.5, h * 0.33)
            ..quadraticBezierTo(w * 0.53, h * 0.32, w * 0.5, h * 0.27),
          Paint()..color = Palette.sweat,
        );
      case _:
        canvas.drawCircle(eye, w * 0.028, Paint()..color = Palette.ink);
    }
    if (face == Face.grumpy) {
      // Brow lowered towards the muzzle.
      canvas.drawLine(
        Offset(eye.dx - w * 0.04, eye.dy - h * 0.08),
        Offset(eye.dx + w * 0.04, eye.dy - h * 0.05),
        stroke,
      );
    }

    final mouth = Rect.fromCenter(
      center: Offset(w * 0.8, h * 0.475),
      width: w * 0.07,
      height: h * 0.05,
    );
    stroke.strokeWidth = w * 0.012;
    if (mouthOpen > 0.05) {
      // Wide open for the chomp, jaw dropping below the muzzle.
      final open = Rect.fromLTWH(
        w * (0.76 - 0.02 * mouthOpen),
        h * 0.44,
        w * (0.1 + 0.04 * mouthOpen),
        h * (0.03 + 0.17 * mouthOpen),
      );
      final rounded = RRect.fromRectAndRadius(open, Radius.circular(w * 0.05));
      canvas.drawRRect(rounded, Paint()..color = Palette.mouth);
      canvas.drawOval(
        Rect.fromLTWH(
          open.left + open.width * 0.2,
          open.bottom - open.height * 0.4,
          open.width * 0.6,
          open.height * 0.35,
        ),
        Paint()..color = Palette.blush,
      );
      canvas.drawRRect(rounded, outline);
    } else {
      switch (face) {
        case Face.grumpy || Face.sick:
          // A small pout.
          canvas.drawArc(
            mouth.shift(Offset(0, h * 0.03)),
            math.pi + 0.5,
            math.pi - 1,
            false,
            stroke,
          );
        case _:
          canvas.drawArc(mouth, 0.2, math.pi - 0.4, false, stroke);
      }
    }

    if (wearing[Slot.body] == 'ghost') {
      paintGhostSheet(canvas, size);
      _ghostFace(canvas, size);
    }
    _accessories(canvas, size, Layer.overHead);

    // Chigüi's signature bow tie at the neck, unless covered.
    if (wearing.containsKey(Slot.neck) || wearing.containsKey(Slot.body)) {
      _accessories(canvas, size, Layer.front);
      return;
    }
    final ink = Paint()..color = Palette.ink;
    final knot = Offset(w * 0.52, h * 0.64);
    final bow = Path()
      ..moveTo(knot.dx, knot.dy)
      ..lineTo(knot.dx - w * 0.09, knot.dy - h * 0.045)
      ..lineTo(knot.dx - w * 0.09, knot.dy + h * 0.045)
      ..close()
      ..moveTo(knot.dx, knot.dy)
      ..lineTo(knot.dx + w * 0.09, knot.dy - h * 0.045)
      ..lineTo(knot.dx + w * 0.09, knot.dy + h * 0.045)
      ..close();
    canvas.drawPath(bow, ink);
    canvas.drawCircle(knot, w * 0.022, ink);
    _accessories(canvas, size, Layer.front);
  }

  /// A front-facing ghost face on the sheet that still shows the mood.
  void _ghostFace(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final ink = Paint()..color = Palette.ink;
    final stroke = Paint()
      ..color = Palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    final blush = Paint()..color = Palette.blush.withValues(alpha: 0.7);
    canvas.drawCircle(
      Offset(w * 0.55, h * 0.43),
      w * (0.035 + 0.015 * cheekPuff),
      blush,
    );
    canvas.drawCircle(
      Offset(w * 0.83, h * 0.43),
      w * (0.035 + 0.015 * cheekPuff),
      blush,
    );

    for (final x in [0.62, 0.76]) {
      final eye = Offset(w * x, h * 0.34);
      final box = Rect.fromCircle(center: eye, radius: w * 0.03);
      switch (face) {
        case Face.happy:
          canvas.drawArc(box, math.pi, math.pi, false, stroke);
        case Face.asleep:
          canvas.drawArc(box, 0, math.pi, false, stroke);
        case Face.sick:
          canvas.drawArc(
            Rect.fromCenter(center: eye, width: w * 0.05, height: h * 0.06),
            0,
            math.pi,
            true,
            ink,
          );
          canvas.drawLine(
            eye.translate(-w * 0.03, 0),
            eye.translate(w * 0.03, 0),
            stroke,
          );
        case _ when blink:
          canvas.drawLine(
            eye.translate(-w * 0.025, 0),
            eye.translate(w * 0.025, 0),
            stroke,
          );
        case _:
          canvas.drawOval(
            Rect.fromCenter(center: eye, width: w * 0.05, height: h * 0.075),
            ink,
          );
      }
      if (face == Face.grumpy) {
        // Brows tilted down towards the middle.
        final inner = x < 0.7 ? 0.03 : -0.03;
        canvas.drawLine(
          Offset(w * (x - inner), h * 0.27),
          Offset(w * (x + inner), h * 0.295),
          stroke,
        );
      }
    }

    // A little "o" mouth; wide open for the chomp.
    final mouth = Offset(w * 0.69, h * (0.44 + 0.03 * mouthOpen));
    canvas.drawOval(
      Rect.fromCenter(
        center: mouth,
        width: w * (0.04 + 0.05 * mouthOpen),
        height: h * (0.04 + 0.1 * mouthOpen),
      ),
      Paint()..color = Palette.mouth,
    );
  }

  @override
  bool shouldRepaint(_ChiguiPainter old) =>
      old.face != face ||
      old.blink != blink ||
      old.mouthOpen != mouthOpen ||
      old.cheekPuff != cheekPuff ||
      old.legLift != legLift ||
      !mapEquals(old.wearing, wearing);
}
