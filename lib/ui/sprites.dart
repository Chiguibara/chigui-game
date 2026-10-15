import 'dart:math' as math;

import 'package:flutter/material.dart';

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

/// An upside-down cardboard box for hide-and-seek, with a strip of tape and
/// a little heart stamp. [size] is its width; it is a bit shorter than wide.
class HidingBox extends StatelessWidget {
  const HidingBox({super.key, required this.size});

  static const aspect = 0.9;

  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size * aspect),
    painter: _HidingBoxPainter(),
  );
}

class _HidingBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeJoin = StrokeJoin.round;
    // The bottom of the box, now on top, seen a little from above.
    final top = Path()
      ..moveTo(w * 0.04, h * 0.2)
      ..lineTo(w * 0.16, h * 0.04)
      ..lineTo(w * 0.84, h * 0.04)
      ..lineTo(w * 0.96, h * 0.2)
      ..close();
    final front = RRect.fromLTRBR(
      w * 0.04,
      h * 0.2,
      w * 0.96,
      h * 0.98,
      Radius.circular(w * 0.03),
    );
    canvas.drawPath(top, Paint()..color = Palette.cardboard);
    canvas.drawRRect(front, Paint()..color = Palette.cardboardDark);
    // Tape across the top and down the front.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.44, h * 0.04)
        ..lineTo(w * 0.56, h * 0.04)
        ..lineTo(w * 0.58, h * 0.2)
        ..lineTo(w * 0.42, h * 0.2)
        ..close(),
      Paint()..color = Palette.tape,
    );
    canvas.drawRect(
      Rect.fromLTRB(w * 0.42, h * 0.2, w * 0.58, h * 0.44),
      Paint()..color = Palette.tape,
    );
    // A heart stamp.
    final c = Offset(w * 0.5, h * 0.66);
    final r = w * 0.07;
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy + r)
        ..cubicTo(
          c.dx - r * 2,
          c.dy - r * 0.2,
          c.dx - r,
          c.dy - r * 1.6,
          c.dx,
          c.dy - r * 0.6,
        )
        ..cubicTo(
          c.dx + r,
          c.dy - r * 1.6,
          c.dx + r * 2,
          c.dy - r * 0.2,
          c.dx,
          c.dy + r,
        ),
      Paint()..color = Palette.blush,
    );
    canvas.drawPath(top, outline);
    canvas.drawRRect(front, outline);
  }

  @override
  bool shouldRepaint(_HidingBoxPainter old) => false;
}

/// Fruit (and the odd stone) for the minigame, drawn in code.
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
      case FruitKind.guava:
        // Round and pale green, with a little crown at the bottom.
        final c = Offset(w / 2, w * 0.54);
        canvas.drawOval(
          Rect.fromCenter(center: c, width: w * 0.74, height: w * 0.8),
          Paint()..color = Palette.guava,
        );
        canvas.drawOval(
          Rect.fromCenter(center: c, width: w * 0.74, height: w * 0.8),
          outline,
        );
        canvas.drawCircle(
          Offset(w * 0.5, w * 0.9),
          w * 0.04,
          Paint()..color = Palette.furOutline,
        );
        _leaf(canvas, w, Offset(w * 0.6, w * 0.14));
      case FruitKind.mango:
        // A plump, slanted kidney shape, golden with a sunset blush.
        final body = Path()
          ..moveTo(w * 0.3, w * 0.2)
          ..quadraticBezierTo(w * 0.85, w * 0.05, w * 0.88, w * 0.55)
          ..quadraticBezierTo(w * 0.86, w * 0.92, w * 0.48, w * 0.92)
          ..quadraticBezierTo(w * 0.1, w * 0.9, w * 0.14, w * 0.5)
          ..quadraticBezierTo(w * 0.16, w * 0.28, w * 0.3, w * 0.2)
          ..close();
        canvas.drawPath(body, Paint()..color = Palette.mango);
        canvas.save();
        canvas.clipPath(body);
        canvas.drawCircle(
          Offset(w * 0.25, w * 0.85),
          w * 0.38,
          Paint()..color = Palette.mangoBlush,
        );
        canvas.restore();
        canvas.drawPath(body, outline);
        _leaf(canvas, w, Offset(w * 0.42, w * 0.14));
      case FruitKind.starApple:
        // Caimito: a purple ball, cut open on one side to show its star.
        final c = Offset(w / 2, w * 0.55);
        canvas.drawCircle(c, w * 0.38, Paint()..color = Palette.starApple);
        canvas.drawCircle(
          c,
          w * 0.24,
          Paint()..color = Palette.starAppleFlesh,
        );
        final star = Path();
        for (var i = 0; i < 10; i++) {
          final r = w * (i.isEven ? 0.17 : 0.07);
          final a = -math.pi / 2 + i * math.pi / 5;
          final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
          i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
        }
        canvas.drawPath(star..close(), Paint()..color = Palette.starApple);
        canvas.drawCircle(c, w * 0.38, outline);
        canvas.drawLine(
          Offset(w * 0.5, w * 0.17),
          Offset(w * 0.54, w * 0.06),
          outline,
        );
      case FruitKind.melon:
        // A whole green melon with darker stripes.
        final rect = Rect.fromCenter(
          center: Offset(w / 2, w * 0.55),
          width: w * 0.88,
          height: w * 0.66,
        );
        canvas.drawOval(rect, Paint()..color = Palette.melonRind);
        canvas.save();
        canvas.clipPath(Path()..addOval(rect));
        final stripe = Paint()
          ..color = Palette.melonStripe
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.04;
        for (final x in [0.3, 0.5, 0.7]) {
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(w * 0.5, w * 0.55),
              width: w * 2 * (x - 0.5).abs() + w * 0.04,
              height: w * 0.66,
            ),
            x < 0.5 ? math.pi / 2 : -math.pi / 2,
            math.pi,
            false,
            stripe,
          );
        }
        canvas.restore();
        canvas.drawOval(rect, outline);
      case FruitKind.banana:
        // A curved yellow banana with brown tips.
        final body = Path()
          ..moveTo(w * 0.12, w * 0.3)
          ..quadraticBezierTo(w * 0.2, w * 0.82, w * 0.86, w * 0.68)
          ..quadraticBezierTo(w * 0.92, w * 0.62, w * 0.84, w * 0.58)
          ..quadraticBezierTo(w * 0.36, w * 0.62, w * 0.26, w * 0.24)
          ..close();
        canvas.drawPath(body, Paint()..color = Palette.banana);
        canvas.drawPath(body, outline);
        final tip = Paint()..color = Palette.furOutline;
        canvas.drawCircle(Offset(w * 0.88, w * 0.64), w * 0.04, tip);
        canvas.drawLine(
          Offset(w * 0.19, w * 0.27),
          Offset(w * 0.16, w * 0.14),
          outline,
        );
      case FruitKind.apple:
        // A shiny red apple with a stem and a leaf.
        final body = Path()
          ..moveTo(w * 0.5, w * 0.3)
          ..cubicTo(w * 0.7, w * 0.16, w * 0.98, w * 0.32, w * 0.86, w * 0.66)
          ..cubicTo(w * 0.78, w * 0.9, w * 0.6, w * 0.94, w * 0.5, w * 0.86)
          ..cubicTo(w * 0.4, w * 0.94, w * 0.22, w * 0.9, w * 0.14, w * 0.66)
          ..cubicTo(w * 0.02, w * 0.32, w * 0.3, w * 0.16, w * 0.5, w * 0.3)
          ..close();
        canvas.drawPath(body, Paint()..color = Palette.apple);
        canvas.drawPath(body, outline);
        canvas.drawCircle(
          Offset(w * 0.32, w * 0.46),
          w * 0.06,
          Paint()..color = Palette.cloud.withValues(alpha: 0.7),
        );
        canvas.drawLine(
          Offset(w * 0.5, w * 0.3),
          Offset(w * 0.52, w * 0.12),
          outline,
        );
        _leaf(canvas, w, Offset(w * 0.64, w * 0.16));
      case FruitKind.stone:
        // A lumpy grey pebble, darker below, with a highlight and speckles.
        final rock = Path()
          ..moveTo(w * 0.12, w * 0.62)
          ..quadraticBezierTo(w * 0.08, w * 0.3, w * 0.38, w * 0.2)
          ..quadraticBezierTo(w * 0.62, w * 0.1, w * 0.8, w * 0.3)
          ..quadraticBezierTo(w * 0.96, w * 0.48, w * 0.86, w * 0.7)
          ..quadraticBezierTo(w * 0.7, w * 0.9, w * 0.42, w * 0.86)
          ..quadraticBezierTo(w * 0.16, w * 0.84, w * 0.12, w * 0.62)
          ..close();
        canvas.drawPath(rock, Paint()..color = Palette.stoneShade);
        canvas.drawPath(
          rock.shift(Offset(-w * 0.03, -w * 0.05)),
          Paint()..color = Palette.stone,
        );
        canvas.drawPath(rock, outline..color = Palette.stoneShade);
        canvas.drawArc(
          Rect.fromLTWH(w * 0.26, w * 0.26, w * 0.3, w * 0.24),
          math.pi * 1.1,
          math.pi * 0.5,
          false,
          Paint()
            ..color = Palette.cloud.withValues(alpha: 0.7)
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = w * 0.05,
        );
        final speckle = Paint()..color = Palette.stoneShade;
        for (final (x, y) in [(0.62, 0.52), (0.46, 0.66), (0.7, 0.36)]) {
          canvas.drawCircle(Offset(w * x, w * y), w * 0.03, speckle);
        }
    }
  }

  static void _leaf(Canvas canvas, double w, Offset center) => canvas.drawOval(
    Rect.fromCenter(center: center, width: w * 0.24, height: w * 0.12),
    Paint()..color = Palette.leaf,
  );

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

/// A round sticker with a white border. Unowned stickers show as a pale
/// silhouette.
class StickerBadge extends StatelessWidget {
  const StickerBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 56,
    this.owned = true,
  });

  final IconData icon;
  final Color color;
  final double size;
  final bool owned;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Palette.cloud,
      shape: BoxShape.circle,
      border: Border.all(color: Palette.ink.withValues(alpha: 0.15), width: 2),
    ),
    child: Icon(
      icon,
      size: size * 0.6,
      color: owned ? color : Palette.ink.withValues(alpha: 0.2),
    ),
  );
}
