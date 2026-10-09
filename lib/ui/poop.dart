import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'palette.dart';

/// A friendly little poop with a face, drawn in code (no emoji font needed).
/// With [smelly], wavy stink lines rise above it, moved by [phase] (0–1).
class Poop extends StatelessWidget {
  const Poop({
    super.key,
    required this.size,
    this.smelly = false,
    this.phase = 0,
  });

  final double size;
  final bool smelly;
  final double phase;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _PoopPainter(smelly: smelly, phase: phase),
  );
}

class _PoopPainter extends CustomPainter {
  _PoopPainter({required this.smelly, required this.phase});

  final bool smelly;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = Paint()..color = Palette.poop;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035;

    // Three stacked rounded layers and a little tip.
    final layers = [
      Rect.fromLTRB(w * 0.12, h * 0.68, w * 0.88, h * 0.94),
      Rect.fromLTRB(w * 0.2, h * 0.5, w * 0.8, h * 0.74),
      Rect.fromLTRB(w * 0.3, h * 0.34, w * 0.7, h * 0.56),
    ];
    final tip = Path()
      ..moveTo(w * 0.42, h * 0.38)
      ..quadraticBezierTo(w * 0.5, h * 0.18, w * 0.6, h * 0.24)
      ..quadraticBezierTo(w * 0.56, h * 0.32, w * 0.58, h * 0.38)
      ..close();
    canvas.drawPath(tip, body);
    canvas.drawPath(tip, outline);
    for (final r in layers) {
      final rr = RRect.fromRectAndRadius(r, Radius.circular(r.height / 2));
      canvas.drawRRect(rr, body);
      canvas.drawRRect(rr, outline);
    }

    // Face.
    final ink = Paint()..color = Palette.ink;
    canvas.drawCircle(Offset(w * 0.4, h * 0.79), w * 0.04, ink);
    canvas.drawCircle(Offset(w * 0.6, h * 0.79), w * 0.04, ink);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.83),
        width: w * 0.12,
        height: h * 0.07,
      ),
      0.2,
      math.pi - 0.4,
      false,
      Paint()
        ..color = Palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03
        ..strokeCap = StrokeCap.round,
    );

    if (smelly) {
      final stink = Paint()
        ..color = Palette.stink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.045
        ..strokeCap = StrokeCap.round;
      for (final x in [0.3, 0.7]) {
        final rise = (phase + x) % 1;
        final path = Path();
        for (var i = 0; i <= 12; i++) {
          final y = h * (0.3 - 0.3 * i / 12 - 0.1 * rise);
          final dx =
              math.sin(i / 12 * 2 * math.pi + phase * 2 * math.pi) * w * 0.06;
          i == 0 ? path.moveTo(w * x + dx, y) : path.lineTo(w * x + dx, y);
        }
        canvas.drawPath(
          path,
          stink..color = Palette.stink.withValues(alpha: 1 - rise * 0.6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PoopPainter old) =>
      old.smelly != smelly || old.phase != phase;
}
