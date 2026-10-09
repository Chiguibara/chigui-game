import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../minigame/catch_game.dart';
import 'palette.dart';

/// A gold coin with a leaf, drawn in code.
class Coin extends StatelessWidget {
  const Coin({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _CoinPainter());
}

class _CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final c = Offset(w / 2, w / 2);
    canvas.drawCircle(c, w * 0.48, Paint()..color = Palette.coinRim);
    canvas.drawCircle(c, w * 0.38, Paint()..color = Palette.sparkle);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.36, w * 0.64)
        ..quadraticBezierTo(w * 0.34, w * 0.34, w * 0.66, w * 0.34)
        ..quadraticBezierTo(w * 0.66, w * 0.64, w * 0.36, w * 0.64),
      Paint()..color = Palette.coinRim,
    );
  }

  @override
  bool shouldRepaint(_CoinPainter old) => false;
}

/// Fruit for the minigame, drawn in code.
class FruitSprite extends StatelessWidget {
  const FruitSprite({super.key, required this.kind, required this.size});

  final FruitKind kind;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _FruitPainter(kind));
}

class _FruitPainter extends CustomPainter {
  _FruitPainter(this.kind);

  final FruitKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05;
    switch (kind) {
      case FruitKind.watermelon:
        final slice = Rect.fromLTWH(w * 0.05, -w * 0.25, w * 0.9, w * 0.9);
        canvas.drawArc(slice, 0, math.pi, true, Paint()..color = Palette.leaf);
        canvas.drawArc(
          slice.deflate(w * 0.08),
          0,
          math.pi,
          true,
          Paint()..color = Palette.melon,
        );
        canvas.drawArc(slice, 0, math.pi, true, outline);
        final seed = Paint()..color = Palette.ink;
        for (final (x, y) in [(0.35, 0.35), (0.5, 0.45), (0.65, 0.35)]) {
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(w * x, w * y),
              width: w * 0.06,
              height: w * 0.09,
            ),
            seed,
          );
        }
      case FruitKind.orange:
        final c = Offset(w / 2, w * 0.55);
        canvas.drawCircle(c, w * 0.38, Paint()..color = Palette.orange);
        canvas.drawCircle(c, w * 0.38, outline);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(w * 0.62, w * 0.16),
            width: w * 0.26,
            height: w * 0.14,
          ),
          Paint()..color = Palette.leaf,
        );
    }
  }

  @override
  bool shouldRepaint(_FruitPainter old) => old.kind != kind;
}

/// Two little footprints, drawn in code, for the step counter.
class Footprints extends StatelessWidget {
  const Footprints({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _FootprintsPainter());
}

class _FootprintsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final paint = Paint()..color = Palette.furDark;
    for (final (x, y) in [(0.3, 0.55), (0.68, 0.3)]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * x, w * (y + 0.12)),
          width: w * 0.26,
          height: w * 0.34,
        ),
        paint,
      );
      for (final dx in [-0.09, 0.0, 0.09]) {
        canvas.drawCircle(Offset(w * (x + dx), w * (y - 0.1)), w * 0.05, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_FootprintsPainter old) => false;
}
