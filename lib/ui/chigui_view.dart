import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'palette.dart';

/// Placeholder Chigüi, a sitting capybara drawn in code, until the
/// real artwork exists. It breathes and blinks while idle, and bounces with a
/// happy face and a heart when tapped.
class ChiguiView extends StatefulWidget {
  const ChiguiView({super.key, required this.size, this.onHappyChanged});

  final double size;
  final ValueChanged<bool>? onHappyChanged;

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
  void dispose() {
    _idle.dispose();
    _react.dispose();
    super.dispose();
  }

  void _pet() {
    if (!_react.isAnimating) widget.onHappyChanged?.call(true);
    _react.forward(from: 0);
  }

  void _onReactStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onHappyChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = widget.size;

    return Semantics(
      button: true,
      label: l10n.chiguiName,
      onTapHint: l10n.petAction,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _pet,
        child: SizedBox.square(
          dimension: size,
          child: AnimatedBuilder(
            animation: Listenable.merge([_idle, _react]),
            builder: (context, _) {
              final happy = _react.isAnimating;
              final (scaleX, scaleY) = _scales();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
                      child: CustomPaint(
                        painter: _ChiguiPainter(
                          blink: _isBlinking(),
                          happy: happy,
                        ),
                      ),
                    ),
                  ),
                  if (happy) _heart(size),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _isBlinking() =>
      !_reduceMotion && _idle.value > 0.9 && _idle.value < 0.93;

  (double, double) _scales() {
    if (_reduceMotion) return (1, 1);
    final breath = math.sin(_idle.value * 4 * math.pi);
    var scaleX = 1 - 0.01 * breath;
    var scaleY = 1 + 0.02 * breath;
    if (_react.isAnimating) {
      // Squash, stretch, then settle during the first half of the reaction.
      final t = (_react.value / 0.5).clamp(0.0, 1.0);
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

  Widget _heart(double size) {
    final t = _reduceMotion ? 0.0 : _react.value;
    return Positioned(
      left: size * 0.66,
      top: size * (0.02 - 0.2 * t),
      child: Opacity(
        opacity: 1 - t,
        child: Icon(Icons.favorite, color: Palette.blush, size: size * 0.16),
      ),
    );
  }
}

class _ChiguiPainter extends CustomPainter {
  _ChiguiPainter({required this.blink, required this.happy});

  final bool blink;
  final bool happy;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fur = Paint()..color = Palette.fur;
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

    // Eye: dot, closed line when blinking, arc when happy.
    final eyeStroke = Paint()
      ..color = Palette.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    final eye = Offset(w * 0.6, h * 0.34);
    if (happy) {
      canvas.drawArc(
        Rect.fromCircle(center: eye.translate(0, w * 0.015), radius: w * 0.035),
        math.pi,
        math.pi,
        false,
        eyeStroke,
      );
    } else if (blink) {
      canvas.drawLine(
        eye.translate(-w * 0.03, 0),
        eye.translate(w * 0.03, 0),
        eyeStroke,
      );
    } else {
      canvas.drawCircle(eye, w * 0.028, Paint()..color = Palette.ink);
    }

    // Small smile under the muzzle.
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.76, h * 0.5),
        width: w * 0.08,
        height: h * 0.06,
      ),
      0.2,
      math.pi - 0.4,
      false,
      eyeStroke..strokeWidth = w * 0.012,
    );

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
      old.blink != blink || old.happy != happy;
}
