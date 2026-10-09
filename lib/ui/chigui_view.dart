import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'palette.dart';

/// Placeholder Chigüi drawn in code (inspired by the brand logo) until the
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
      left: size * 0.62,
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
    final ink = Paint()..color = Palette.ink;
    final mint = Paint()..color = Palette.mint;

    // Ears.
    for (final x in [0.28, 0.62]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * x, h * 0.12, w * 0.1, h * 0.14),
          Radius.circular(w * 0.04),
        ),
        ink,
      );
    }

    // Head: rounded dome, wider at the bottom, like the logo.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(w * 0.14, h * 0.18, w * 0.86, h * 0.84),
        topLeft: Radius.elliptical(w * 0.36, h * 0.42),
        topRight: Radius.elliptical(w * 0.36, h * 0.42),
        bottomLeft: Radius.circular(w * 0.16),
        bottomRight: Radius.circular(w * 0.16),
      ),
      ink,
    );

    // Cheeks.
    final blush = Paint()..color = Palette.blush.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(w * 0.28, h * 0.6), w * 0.05, blush);
    canvas.drawCircle(Offset(w * 0.72, h * 0.6), w * 0.05, blush);

    // Eyes: dots, closed lines when blinking, arcs when happy.
    final eyeStroke = Paint()
      ..color = Palette.mint
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round;
    for (final x in [0.36, 0.64]) {
      final c = Offset(w * x, h * 0.47);
      if (happy) {
        canvas.drawArc(
          Rect.fromCircle(center: c.translate(0, w * 0.02), radius: w * 0.045),
          math.pi,
          math.pi,
          false,
          eyeStroke,
        );
      } else if (blink) {
        canvas.drawLine(
          c.translate(-w * 0.04, 0),
          c.translate(w * 0.04, 0),
          eyeStroke,
        );
      } else {
        canvas.drawCircle(c, w * 0.035, mint);
      }
    }

    // Snout with nostrils.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.66),
          width: w * 0.24,
          height: h * 0.14,
        ),
        Radius.circular(w * 0.07),
      ),
      mint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.45, h * 0.645),
        width: w * 0.035,
        height: h * 0.025,
      ),
      ink,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.55, h * 0.645),
        width: w * 0.035,
        height: h * 0.025,
      ),
      ink,
    );

    // Bow tie under the chin.
    final bow = Path()
      ..moveTo(w * 0.5, h * 0.9)
      ..lineTo(w * 0.36, h * 0.84)
      ..lineTo(w * 0.36, h * 0.96)
      ..close()
      ..moveTo(w * 0.5, h * 0.9)
      ..lineTo(w * 0.64, h * 0.84)
      ..lineTo(w * 0.64, h * 0.96)
      ..close();
    canvas.drawPath(bow, ink);
    canvas.drawCircle(Offset(w * 0.5, h * 0.9), w * 0.03, ink);
  }

  @override
  bool shouldRepaint(_ChiguiPainter old) =>
      old.blink != blink || old.happy != happy;
}
