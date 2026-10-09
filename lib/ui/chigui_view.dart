import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'palette.dart';
import 'poop.dart';

enum Reaction { love, eat, refuse, relief, cured, cleaned }

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
                      transform: Matrix4.translationValues(
                        _shake(reaction),
                        0,
                        0,
                      )..multiply(Matrix4.diagonal3Values(scaleX, scaleY, 1)),
                      child: CustomPaint(
                        painter: _ChiguiPainter(
                          face: _face(reaction),
                          blink: _isBlinking(),
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
        final k = Curves.easeOut.transform((t - 0.55) / 0.45);
        scaleX = lerpDouble(0.94, scaleX, k)!;
        scaleY = lerpDouble(1.10, scaleY, k)!;
      }
    }
    return (scaleX, scaleY);
  }

  /// A gentle "no, thanks" side-to-side wobble.
  double _shake(Reaction? reaction) {
    if (_reduceMotion || reaction != Reaction.refuse) return 0;
    final t = _react.value;
    return math.sin(t * 6 * math.pi) * widget.size * 0.03 * (1 - t);
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
  _ChiguiPainter({required this.face, required this.blink});

  final Face face;
  final bool blink;

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

    // Ground shadow.
    canvas.drawOval(
      Rect.fromLTRB(w * 0.1, h * 0.88, w * 0.82, h * 0.98),
      Paint()..color = Palette.ink.withValues(alpha: 0.12),
    );

    // Far front leg, behind the body.
    shape(
      RRect.fromLTRBR(
        w * 0.6,
        h * 0.74,
        w * 0.7,
        h * 0.93,
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
        h * 0.76,
        w * 0.59,
        h * 0.95,
        Radius.circular(w * 0.05),
      ),
      fur,
    );

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

    // Cheek.
    canvas.drawCircle(
      Offset(w * 0.6, h * 0.45),
      w * 0.045,
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

    // Chigüi's signature bow tie at the neck.
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
  }

  @override
  bool shouldRepaint(_ChiguiPainter old) =>
      old.face != face || old.blink != blink;
}
