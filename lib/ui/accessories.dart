import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'palette.dart';

/// Where an accessory is drawn relative to Chigüi's own shapes.
enum Layer { behind, overBody, overHead, front }

/// Draws [id] on the given [layer] of Chigüi, using the same proportions as
/// the placeholder Chigüi (facing right, head on the upper right). Items that
/// do not use that layer draw nothing.
void paintAccessory(Canvas canvas, Size size, String id, Layer layer) {
  final w = size.width;
  final h = size.height;
  final outline = Paint()
    ..color = Palette.furOutline
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.012
    ..strokeJoin = StrokeJoin.round;
  Paint fill(Color c) => Paint()..color = c;
  Offset p(double x, double y) => Offset(w * x, h * y);

  switch ((id, layer)) {
    case ('beanie', Layer.overHead):
      final dome = Rect.fromLTRB(w * 0.36, h * 0.08, w * 0.76, h * 0.38);
      canvas.drawArc(dome, math.pi, math.pi, true, fill(Palette.beanie));
      canvas.drawArc(
        dome.deflate(w * 0.06),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = Palette.cloud.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.02,
      );
      canvas.drawArc(dome, math.pi, math.pi, true, outline);
      final band = RRect.fromLTRBR(
        w * 0.35,
        h * 0.2,
        w * 0.77,
        h * 0.27,
        Radius.circular(w * 0.03),
      );
      canvas.drawRRect(band, fill(Palette.beanieBand));
      canvas.drawRRect(band, outline);
      canvas.drawCircle(p(0.56, 0.08), w * 0.045, fill(Palette.cloud));
      canvas.drawCircle(p(0.56, 0.08), w * 0.045, outline);

    case ('headphones', Layer.overHead):
      canvas.drawArc(
        Rect.fromLTRB(w * 0.4, h * 0.07, w * 0.74, h * 0.42),
        math.pi * 1.05,
        math.pi * 0.85,
        false,
        Paint()
          ..color = Palette.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.03
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(p(0.44, 0.25), w * 0.07, fill(Palette.ink));
      canvas.drawCircle(p(0.44, 0.25), w * 0.045, fill(Palette.headphones));

    case ('santaHat', Layer.overHead):
      final hat = Path()
        ..moveTo(w * 0.37, h * 0.22)
        ..quadraticBezierTo(w * 0.42, h * 0.02, w * 0.62, h * 0.06)
        ..quadraticBezierTo(w * 0.42, h * 0.0, w * 0.3, h * 0.1)
        ..lineTo(w * 0.33, h * 0.12)
        ..quadraticBezierTo(w * 0.5, h * 0.06, w * 0.74, h * 0.22)
        ..close();
      canvas.drawPath(hat, fill(Palette.santaRed));
      canvas.drawPath(hat, outline);
      final trim = RRect.fromLTRBR(
        w * 0.35,
        h * 0.19,
        w * 0.77,
        h * 0.27,
        Radius.circular(w * 0.04),
      );
      canvas.drawRRect(trim, fill(Palette.cloud));
      canvas.drawRRect(trim, outline);
      canvas.drawCircle(p(0.3, 0.11), w * 0.045, fill(Palette.cloud));
      canvas.drawCircle(p(0.3, 0.11), w * 0.045, outline);

    case ('geekGlasses', Layer.overHead):
      final frame = Paint()
        ..color = Palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.022;
      final lens = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: p(0.6, 0.34),
          width: w * 0.14,
          height: h * 0.12,
        ),
        Radius.circular(w * 0.03),
      );
      canvas.drawRRect(lens, fill(Palette.lens));
      canvas.drawRRect(lens, frame);
      canvas.drawLine(p(0.53, 0.33), p(0.46, 0.3), frame);
      canvas.drawLine(p(0.67, 0.33), p(0.71, 0.32), frame);
      // The classic tape on the bridge.
      canvas.save();
      canvas.translate(w * 0.69, h * 0.325);
      canvas.rotate(0.4);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: w * 0.035,
          height: h * 0.05,
        ),
        fill(Palette.cloud),
      );
      canvas.restore();

    case ('snorkel', Layer.overHead):
      final strap = Paint()
        ..color = Palette.diving
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p(0.53, 0.33), p(0.36, 0.34), strap);
      final mask = RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.52, h * 0.26, w * 0.71, h * 0.42),
        Radius.circular(w * 0.06),
      );
      canvas.drawRRect(mask, fill(Palette.lens));
      canvas.drawRRect(
        mask,
        Paint()
          ..color = Palette.diving
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.025,
      );
      final tube = Path()
        ..moveTo(w * 0.76, h * 0.5)
        ..quadraticBezierTo(w * 0.52, h * 0.52, w * 0.5, h * 0.4)
        ..lineTo(w * 0.47, h * 0.04);
      canvas.drawPath(
        tube,
        Paint()
          ..color = Palette.snorkel
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.035
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.44,
          h * 0.0,
          w * 0.5,
          h * 0.06,
          Radius.circular(w * 0.015),
        ),
        fill(Palette.orange),
      );

    case ('scarf', Layer.overHead):
      final wrap = RRect.fromLTRBR(
        w * 0.38,
        h * 0.56,
        w * 0.7,
        h * 0.67,
        Radius.circular(w * 0.05),
      );
      final tail = RRect.fromLTRBR(
        w * 0.4,
        h * 0.6,
        w * 0.49,
        h * 0.84,
        Radius.circular(w * 0.03),
      );
      for (final r in [tail, wrap]) {
        canvas.drawRRect(r, fill(Palette.scarf));
        canvas.drawRRect(r, outline);
      }
      final stripe = Paint()
        ..color = Palette.cloud
        ..strokeWidth = w * 0.018;
      for (final y in [0.72, 0.78]) {
        canvas.drawLine(p(0.41, y), p(0.48, y), stripe);
      }

    case ('ghost', Layer.overBody):
      // A sheet over the body with a wavy hem and a cute ghost face.
      final sheet = Path()
        ..moveTo(w * 0.08, h * 0.95)
        ..lineTo(w * 0.08, h * 0.6)
        ..quadraticBezierTo(w * 0.1, h * 0.36, w * 0.4, h * 0.36)
        ..lineTo(w * 0.7, h * 0.5)
        ..lineTo(w * 0.75, h * 0.95);
      for (var i = 0; i < 4; i++) {
        final x0 = 0.75 - i * 0.1675;
        sheet.quadraticBezierTo(
          w * (x0 - 0.084),
          h * (i.isEven ? 0.89 : 1.0),
          w * (x0 - 0.1675),
          h * 0.95,
        );
      }
      sheet.close();
      canvas.drawPath(sheet, fill(Palette.ghost));
      canvas.drawPath(sheet, outline..color = Palette.ghostOutline);
      final ink = fill(Palette.ink);
      canvas.drawOval(
        Rect.fromCenter(
          center: p(0.3, 0.66),
          width: w * 0.05,
          height: h * 0.08,
        ),
        ink,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: p(0.42, 0.66),
          width: w * 0.05,
          height: h * 0.08,
        ),
        ink,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: p(0.36, 0.76),
          width: w * 0.05,
          height: h * 0.05,
        ),
        ink,
      );

    case ('ghost', Layer.overHead):
      // The hood: Chigüi's face peeks out.
      final hood = Path()
        ..moveTo(w * 0.33, h * 0.5)
        ..quadraticBezierTo(w * 0.3, h * 0.12, w * 0.56, h * 0.12)
        ..quadraticBezierTo(w * 0.7, h * 0.12, w * 0.72, h * 0.22)
        ..quadraticBezierTo(w * 0.52, h * 0.2, w * 0.48, h * 0.32)
        ..quadraticBezierTo(w * 0.44, h * 0.44, w * 0.46, h * 0.56)
        ..close();
      canvas.drawPath(hood, fill(Palette.ghost));
      canvas.drawPath(hood, outline..color = Palette.ghostOutline);

    case ('flowerCrown', Layer.overHead):
      final stem = Paint()
        ..color = Palette.leaf
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromLTRB(w * 0.36, h * 0.17, w * 0.8, h * 0.4),
        math.pi * 1.05,
        math.pi * 0.8,
        false,
        stem,
      );
      for (final (x, y, c) in [
        (0.4, 0.25, Palette.blush),
        (0.48, 0.19, Palette.sparkle),
        (0.57, 0.17, Palette.flower),
        (0.66, 0.18, Palette.blush),
        (0.74, 0.22, Palette.sparkle),
      ]) {
        for (var i = 0; i < 5; i++) {
          final a = i * 2 * math.pi / 5;
          canvas.drawCircle(
            p(x, y) + Offset(math.cos(a), math.sin(a)) * w * 0.022,
            w * 0.018,
            fill(c),
          );
        }
        canvas.drawCircle(p(x, y), w * 0.014, fill(Palette.cloud));
      }

    case ('butterfly', Layer.front):
      final c = p(0.9, 0.12);
      for (final (dx, dy, r, color) in [
        (-0.03, -0.025, 0.035, Palette.flower),
        (0.03, -0.025, 0.035, Palette.flower),
        (-0.025, 0.025, 0.025, Palette.blush),
        (0.025, 0.025, 0.025, Palette.blush),
      ]) {
        final wing = c + Offset(w * dx, h * dy);
        canvas.drawCircle(wing, w * r, fill(color));
        canvas.drawCircle(wing, w * r, outline);
      }
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: w * 0.015, height: h * 0.07),
          Radius.circular(w * 0.01),
        ),
        fill(Palette.ink),
      );

    case ('pumpkin', Layer.front):
      final body = Rect.fromLTRB(w * 0.74, h * 0.76, w * 0.99, h * 0.96);
      canvas.drawRect(
        Rect.fromLTRB(w * 0.85, h * 0.71, w * 0.875, h * 0.78),
        fill(Palette.leaf),
      );
      canvas.drawOval(body, fill(Palette.orange));
      canvas.drawOval(body.deflate(w * 0.04), outline);
      canvas.drawOval(body, outline);
      final ink = fill(Palette.ink);
      for (final x in [0.82, 0.91]) {
        canvas.drawPath(
          Path()
            ..moveTo(w * x, h * 0.82)
            ..lineTo(w * (x - 0.02), h * 0.85)
            ..lineTo(w * (x + 0.02), h * 0.85)
            ..close(),
          ink,
        );
      }
      canvas.drawArc(
        Rect.fromCenter(
          center: p(0.865, 0.87),
          width: w * 0.1,
          height: h * 0.05,
        ),
        0.2,
        math.pi - 0.4,
        false,
        Paint()
          ..color = Palette.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.015
          ..strokeCap = StrokeCap.round,
      );

    case ('xmasTree', Layer.behind):
      canvas.drawRect(
        Rect.fromLTRB(w * 0.86, h * 0.86, w * 0.91, h * 0.96),
        fill(Palette.furDark),
      );
      for (final (top, bottom, half) in [
        (0.5, 0.7, 0.08),
        (0.6, 0.8, 0.1),
        (0.7, 0.9, 0.12),
      ]) {
        final tier = Path()
          ..moveTo(w * 0.885, h * top)
          ..lineTo(w * (0.885 - half), h * bottom)
          ..lineTo(w * (0.885 + half), h * bottom)
          ..close();
        canvas.drawPath(tier, fill(Palette.tree));
        canvas.drawPath(tier, outline);
      }
      for (final (x, y, c) in [
        (0.85, 0.66, Palette.santaRed),
        (0.92, 0.75, Palette.sparkle),
        (0.84, 0.85, Palette.diving),
        (0.94, 0.86, Palette.santaRed),
      ]) {
        canvas.drawCircle(p(x, y), w * 0.018, fill(c));
      }
      _star(canvas, p(0.885, 0.48), w * 0.04, fill(Palette.sparkle));

    case ('surfboard', Layer.behind):
      canvas.save();
      canvas.translate(w * 0.12, h * 0.55);
      canvas.rotate(-0.12);
      final board = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: w * 0.14, height: h * 0.8),
        Radius.circular(w * 0.07),
      );
      canvas.drawRRect(board, fill(Palette.surf));
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: w * 0.03, height: h * 0.78),
        fill(Palette.santaRed),
      );
      canvas.drawRRect(board, outline);
      canvas.restore();

    default:
      break;
  }
}

void _star(Canvas canvas, Offset c, double r, Paint paint) {
  final path = Path();
  for (var i = 0; i < 10; i++) {
    final radius = i.isEven ? r : r * 0.45;
    final a = -math.pi / 2 + i * math.pi / 5;
    final point = c + Offset(math.cos(a) * radius, math.sin(a) * radius);
    i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
  }
  canvas.drawPath(path..close(), paint);
}
