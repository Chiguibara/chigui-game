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
    case ('orange', Layer.overHead):
      // The classic capybara look: an orange balanced on the head.
      final c = p(0.6, 0.11);
      final r = w * 0.095;
      canvas.drawCircle(c, r, fill(Palette.orange));
      // Peel dimples and a shine.
      for (final (dx, dy) in [
        (-0.04, 0.02),
        (0.03, 0.04),
        (0.0, -0.01),
        (0.045, -0.02),
      ]) {
        canvas.drawCircle(
          c + Offset(w * dx, h * dy),
          w * 0.008,
          fill(Palette.orangePeel),
        );
      }
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * 0.7),
        math.pi * 1.1,
        math.pi * 0.35,
        false,
        Paint()
          ..color = Palette.cloud.withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = w * 0.018,
      );
      canvas.drawCircle(c, r, outline);
      // Stem and a leaf.
      canvas.drawLine(
        c.translate(0, -r),
        c.translate(w * 0.008, -r - h * 0.025),
        outline,
      );
      final leaf = Path()
        ..moveTo(c.dx + w * 0.008, c.dy - r - h * 0.02)
        ..quadraticBezierTo(
          c.dx + w * 0.05,
          c.dy - r - h * 0.06,
          c.dx + w * 0.09,
          c.dy - r - h * 0.025,
        )
        ..quadraticBezierTo(
          c.dx + w * 0.05,
          c.dy - r + h * 0.005,
          c.dx + w * 0.008,
          c.dy - r - h * 0.02,
        )
        ..close();
      canvas.drawPath(leaf, fill(Palette.leaf));
      canvas.drawPath(leaf, outline);

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
      // A cone that rises from the head, flops backwards, and hangs its
      // tip behind the head.
      final hat = Path()
        ..moveTo(w * 0.4, h * 0.22)
        ..quadraticBezierTo(w * 0.42, h * 0.1, w * 0.47, h * 0.07)
        ..quadraticBezierTo(w * 0.36, h * 0.08, w * 0.31, h * 0.19)
        ..lineTo(w * 0.25, h * 0.16)
        ..quadraticBezierTo(w * 0.34, h * -0.04, w * 0.6, h * 0.0)
        ..quadraticBezierTo(w * 0.77, h * 0.03, w * 0.76, h * 0.22)
        ..close();
      canvas.drawPath(hat, fill(Palette.santaRed));
      // A soft shadow on the fold.
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.47, h * 0.07)
          ..quadraticBezierTo(w * 0.36, h * 0.08, w * 0.31, h * 0.19)
          ..lineTo(w * 0.36, h * 0.15)
          ..quadraticBezierTo(w * 0.42, h * 0.08, w * 0.5, h * 0.06)
          ..close(),
        fill(Palette.santaShade),
      );
      canvas.drawPath(hat, outline);
      final trim = RRect.fromLTRBR(
        w * 0.35,
        h * 0.19,
        w * 0.79,
        h * 0.28,
        Radius.circular(w * 0.045),
      );
      canvas.drawRRect(trim, fill(Palette.cloud));
      canvas.drawRRect(trim, outline);
      canvas.drawCircle(p(0.27, 0.19), w * 0.05, fill(Palette.cloud));
      canvas.drawCircle(p(0.27, 0.19), w * 0.05, outline);

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

    case ('pixelGlasses', Layer.overHead):
      // 8-bit "deal with it" shades, drawn pixel by pixel.
      final px = w * 0.022;
      final ink = fill(Palette.ink);
      final shine = fill(Palette.cloud);
      const rows = ['########', '#.#.####', '########', '.######.'];
      for (var row = 0; row < rows.length; row++) {
        for (var col = 0; col < rows[row].length; col++) {
          final c = rows[row][col];
          if (c == ' ') continue;
          canvas.drawRect(
            Rect.fromLTWH(
              w * 0.51 + col * px,
              h * 0.3 + row * px,
              px + 0.5,
              px + 0.5,
            ),
            c == '#' ? ink : shine,
          );
        }
      }
      canvas.drawLine(
        p(0.51, 0.32),
        p(0.45, 0.3),
        Paint()
          ..color = Palette.ink
          ..strokeWidth = px,
      );

    case ('wizardHat', Layer.overHead):
      final hat = Path()
        ..moveTo(w * 0.38, h * 0.22)
        ..quadraticBezierTo(w * 0.5, h * 0.08, w * 0.5, h * -0.08)
        ..quadraticBezierTo(w * 0.58, h * -0.02, w * 0.6, h * 0.0)
        ..quadraticBezierTo(w * 0.62, h * 0.12, w * 0.74, h * 0.22)
        ..close();
      canvas.drawPath(hat, fill(Palette.wizard));
      canvas.drawPath(hat, outline);
      final brim = Rect.fromLTRB(w * 0.32, h * 0.18, w * 0.8, h * 0.27);
      canvas.drawOval(brim, fill(Palette.wizardBrim));
      canvas.drawOval(brim, outline);
      for (final (x, y, r) in [(0.53, 0.07, 0.025), (0.62, 0.15, 0.018)]) {
        _star(canvas, p(x, y), w * r, fill(Palette.sparkle));
      }

    case ('laptop', Layer.front):
      // Seen from behind: the lid's back is covered in stickers.
      final lid = RRect.fromLTRBR(
        w * 0.75,
        h * 0.7,
        w * 0.97,
        h * 0.87,
        Radius.circular(w * 0.015),
      );
      canvas.drawRRect(lid, fill(Palette.laptop));
      canvas.drawRRect(lid, outline);
      canvas.drawCircle(p(0.8, 0.75), w * 0.018, fill(Palette.blush));
      _star(canvas, p(0.91, 0.75), w * 0.022, fill(Palette.sparkle));
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.83,
          h * 0.8,
          w * 0.9,
          h * 0.84,
          Radius.circular(w * 0.01),
        ),
        fill(Palette.mint),
      );
      final base = RRect.fromLTRBR(
        w * 0.72,
        h * 0.87,
        w * 0.99,
        h * 0.91,
        Radius.circular(w * 0.015),
      );
      canvas.drawRRect(base, fill(Palette.laptopDark));
      canvas.drawRRect(base, outline);

    case ('bunnyEars', Layer.overHead):
      canvas.drawArc(
        Rect.fromLTRB(w * 0.38, h * 0.2, w * 0.78, h * 0.48),
        math.pi * 1.1,
        math.pi * 0.8,
        false,
        Paint()
          ..color = Palette.flower
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.03
          ..strokeCap = StrokeCap.round,
      );
      for (final (x, tilt) in [(0.46, -0.25), (0.63, 0.15)]) {
        canvas.save();
        canvas.translate(w * x, h * 0.23);
        canvas.rotate(tilt);
        final ear = Rect.fromCenter(
          center: Offset(0, -h * 0.12),
          width: w * 0.09,
          height: h * 0.26,
        );
        canvas.drawOval(ear, fill(Palette.bunny));
        canvas.drawOval(ear.deflate(w * 0.02), fill(Palette.blush));
        canvas.drawOval(ear, outline);
        canvas.restore();
      }

    case ('heartGlasses', Layer.overHead):
      final heart = _heartPath(p(0.6, 0.33), w * 0.075);
      canvas.drawPath(heart, fill(Palette.heartLens));
      canvas.drawPath(
        heart,
        Paint()
          ..color = Palette.santaRed
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.018,
      );
      canvas.drawLine(
        p(0.53, 0.32),
        p(0.46, 0.3),
        Paint()
          ..color = Palette.santaRed
          ..strokeWidth = w * 0.018,
      );

    case ('cupcake', Layer.front):
      final wrapper = Path()
        ..moveTo(w * 0.78, h * 0.84)
        ..lineTo(w * 0.96, h * 0.84)
        ..lineTo(w * 0.93, h * 0.96)
        ..lineTo(w * 0.81, h * 0.96)
        ..close();
      canvas.drawPath(wrapper, fill(Palette.wrapper));
      for (final x in [0.83, 0.87, 0.91]) {
        canvas.drawLine(
          p(x, 0.85),
          p(x - 0.005, 0.95),
          Paint()
            ..color = Palette.cloud.withValues(alpha: 0.7)
            ..strokeWidth = w * 0.008,
        );
      }
      canvas.drawPath(wrapper, outline);
      final frosting = Rect.fromLTRB(w * 0.76, h * 0.74, w * 0.98, h * 0.88);
      canvas.drawArc(frosting, math.pi, math.pi, true, fill(Palette.frosting));
      canvas.drawCircle(p(0.87, 0.75), w * 0.035, fill(Palette.frosting));
      canvas.drawArc(frosting, math.pi, math.pi, true, outline);
      canvas.drawCircle(p(0.87, 0.71), w * 0.025, fill(Palette.santaRed));
      canvas.drawCircle(p(0.87, 0.71), w * 0.025, outline);

    case ('cap', Layer.overHead):
      final dome = Rect.fromLTRB(w * 0.38, h * 0.1, w * 0.76, h * 0.38);
      canvas.drawArc(dome, math.pi, math.pi, true, fill(Palette.capColor));
      canvas.drawArc(dome, math.pi, math.pi, true, outline);
      final brim = RRect.fromLTRBR(
        w * 0.62,
        h * 0.21,
        w * 0.93,
        h * 0.26,
        Radius.circular(w * 0.03),
      );
      canvas.drawRRect(brim, fill(Palette.capColor));
      canvas.drawRRect(brim, outline);
      canvas.drawCircle(p(0.57, 0.1), w * 0.02, fill(Palette.capColor));
      canvas.drawCircle(p(0.57, 0.1), w * 0.02, outline);
      _star(canvas, p(0.55, 0.18), w * 0.03, fill(Palette.cloud));

    case ('vikingHelmet', Layer.overHead):
      final horn = fill(Palette.horn);
      for (final (base, tip, control) in [
        ((0.4, 0.2), (0.3, 0.02), (0.28, 0.16)),
        ((0.72, 0.2), (0.84, 0.02), (0.86, 0.16)),
      ]) {
        final path = Path()
          ..moveTo(w * base.$1 - w * 0.03, h * base.$2)
          ..quadraticBezierTo(
            w * control.$1,
            h * control.$2,
            w * tip.$1,
            h * tip.$2,
          )
          ..quadraticBezierTo(
            w * (control.$1 + 0.06),
            h * (control.$2 + 0.04),
            w * base.$1 + w * 0.03,
            h * base.$2,
          )
          ..close();
        canvas.drawPath(path, horn);
        canvas.drawPath(path, outline);
      }
      final dome = Rect.fromLTRB(w * 0.37, h * 0.09, w * 0.75, h * 0.37);
      canvas.drawArc(dome, math.pi, math.pi, true, fill(Palette.steel));
      canvas.drawArc(dome, math.pi, math.pi, true, outline);
      final band = RRect.fromLTRBR(
        w * 0.36,
        h * 0.2,
        w * 0.76,
        h * 0.26,
        Radius.circular(w * 0.02),
      );
      canvas.drawRRect(band, fill(Palette.furDark));
      canvas.drawRRect(band, outline);
      for (final x in [0.44, 0.56, 0.68]) {
        canvas.drawCircle(p(x, 0.23), w * 0.01, fill(Palette.sparkle));
      }

    case ('crown', Layer.overHead):
      final crown = Path()
        ..moveTo(w * 0.42, h * 0.25)
        ..lineTo(w * 0.42, h * 0.12)
        ..lineTo(w * 0.48, h * 0.18)
        ..lineTo(w * 0.53, h * 0.07)
        ..lineTo(w * 0.58, h * 0.18)
        ..lineTo(w * 0.64, h * 0.07)
        ..lineTo(w * 0.68, h * 0.18)
        ..lineTo(w * 0.73, h * 0.12)
        ..lineTo(w * 0.73, h * 0.25)
        ..close();
      canvas.drawPath(crown, fill(Palette.sparkle));
      canvas.drawPath(crown, outline);
      for (final (x, c) in [
        (0.48, Palette.santaRed),
        (0.575, Palette.diving),
        (0.665, Palette.leaf),
      ]) {
        canvas.drawCircle(p(x, 0.215), w * 0.016, fill(c));
      }

    case ('mustache', Layer.overHead):
      final stache = Path()
        ..moveTo(w * 0.8, h * 0.41)
        ..cubicTo(w * 0.76, h * 0.38, w * 0.71, h * 0.4, w * 0.7, h * 0.44)
        ..cubicTo(w * 0.69, h * 0.47, w * 0.72, h * 0.48, w * 0.73, h * 0.46)
        ..cubicTo(w * 0.75, h * 0.44, w * 0.78, h * 0.45, w * 0.8, h * 0.44)
        ..cubicTo(w * 0.82, h * 0.45, w * 0.85, h * 0.44, w * 0.87, h * 0.46)
        ..cubicTo(w * 0.88, h * 0.48, w * 0.91, h * 0.47, w * 0.9, h * 0.44)
        ..cubicTo(w * 0.89, h * 0.4, w * 0.84, h * 0.38, w * 0.8, h * 0.41)
        ..close();
      canvas.drawPath(stache, fill(Palette.ink));

    case ('glasses3d', Layer.overHead):
      final frame = RRect.fromLTRBR(
        w * 0.52,
        h * 0.285,
        w * 0.76,
        h * 0.395,
        Radius.circular(w * 0.015),
      );
      canvas.drawRRect(frame, fill(Palette.cloud));
      canvas.drawRRect(frame, outline);
      canvas.drawRect(
        Rect.fromLTRB(w * 0.54, h * 0.3, w * 0.66, h * 0.38),
        fill(Palette.lens3dRed),
      );
      canvas.drawRect(
        Rect.fromLTRB(w * 0.68, h * 0.3, w * 0.74, h * 0.38),
        fill(Palette.lens3dBlue),
      );
      canvas.drawLine(
        p(0.52, 0.32),
        p(0.46, 0.3),
        Paint()
          ..color = Palette.cloud
          ..strokeWidth = w * 0.02,
      );

    case ('bandana', Layer.overHead):
      final scarf = Path()
        ..moveTo(w * 0.39, h * 0.58)
        ..quadraticBezierTo(w * 0.54, h * 0.63, w * 0.69, h * 0.58)
        ..lineTo(w * 0.55, h * 0.76)
        ..close();
      canvas.drawPath(scarf, fill(Palette.santaRed));
      canvas.drawPath(scarf, outline);
      for (final (x, y) in [(0.47, 0.63), (0.6, 0.63), (0.54, 0.69)]) {
        canvas.drawCircle(p(x, y), w * 0.012, fill(Palette.cloud));
      }

    case ('medal', Layer.overHead):
      final ribbon = Path()
        ..moveTo(w * 0.43, h * 0.58)
        ..lineTo(w * 0.51, h * 0.7)
        ..lineTo(w * 0.57, h * 0.7)
        ..lineTo(w * 0.65, h * 0.58)
        ..lineTo(w * 0.59, h * 0.58)
        ..lineTo(w * 0.54, h * 0.66)
        ..lineTo(w * 0.49, h * 0.58)
        ..close();
      canvas.drawPath(ribbon, fill(Palette.diving));
      canvas.drawCircle(p(0.54, 0.74), w * 0.05, fill(Palette.sparkle));
      canvas.drawCircle(p(0.54, 0.74), w * 0.05, outline);
      _star(canvas, p(0.54, 0.74), w * 0.028, fill(Palette.coinRim));

    case ('cape', Layer.behind):
      // Billowing out behind Chigüi's back, like in the wind.
      final cape = Path()
        ..moveTo(w * 0.42, h * 0.54)
        ..quadraticBezierTo(w * 0.2, h * 0.3, w * -0.02, h * 0.38)
        ..quadraticBezierTo(w * 0.06, h * 0.46, w * -0.04, h * 0.56)
        ..quadraticBezierTo(w * 0.06, h * 0.62, w * -0.02, h * 0.74)
        ..quadraticBezierTo(w * 0.1, h * 0.8, w * 0.1, h * 0.92)
        ..lineTo(w * 0.5, h * 0.92)
        ..close();
      canvas.drawPath(cape, fill(Palette.santaRed));
      canvas.drawPath(cape, outline);

    case ('cape', Layer.overHead):
      canvas.drawCircle(p(0.52, 0.62), w * 0.03, fill(Palette.sparkle));
      canvas.drawCircle(p(0.52, 0.62), w * 0.03, outline);

    case ('balloon', Layer.front):
      canvas.drawPath(
        Path()
          ..moveTo(w * 0.9, h * 0.18)
          ..quadraticBezierTo(w * 0.98, h * 0.5, w * 0.56, h * 0.8),
        Paint()
          ..color = Palette.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.008,
      );
      final heart = _heartPath(p(0.9, 0.1), w * 0.08);
      canvas.drawPath(heart, fill(Palette.santaRed));
      canvas.drawPath(heart, outline);
      canvas.drawCircle(p(0.87, 0.07), w * 0.012, fill(Palette.cloud));

    case ('retroConsole', Layer.front):
      final body = RRect.fromLTRBR(
        w * 0.77,
        h * 0.7,
        w * 0.97,
        h * 0.96,
        Radius.circular(w * 0.02),
      );
      canvas.drawRRect(body, fill(Palette.console));
      canvas.drawRRect(body, outline);
      canvas.drawRect(
        Rect.fromLTRB(w * 0.795, h * 0.73, w * 0.945, h * 0.82),
        fill(Palette.consoleScreen),
      );
      final pad = fill(Palette.ink);
      canvas.drawRect(
        Rect.fromCenter(
          center: p(0.82, 0.88),
          width: w * 0.045,
          height: h * 0.015,
        ),
        pad,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: p(0.82, 0.88),
          width: w * 0.015,
          height: h * 0.045,
        ),
        pad,
      );
      canvas.drawCircle(p(0.9, 0.9), w * 0.013, fill(Palette.santaRed));
      canvas.drawCircle(p(0.93, 0.87), w * 0.013, fill(Palette.santaRed));

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

/// The ghost costume: a sheet over all of Chigüi, ears poking up beneath
/// it, with a wavy hem. The face on it is drawn by Chigüi's painter so it
/// keeps showing the mood.
void paintGhostSheet(Canvas canvas, Size size) {
  final w = size.width;
  final h = size.height;
  final sheet = Path()
    ..moveTo(w * 0.06, h * 0.95)
    ..lineTo(w * 0.06, h * 0.62)
    ..quadraticBezierTo(w * 0.07, h * 0.38, w * 0.3, h * 0.38)
    ..quadraticBezierTo(w * 0.3, h * 0.2, w * 0.38, h * 0.18)
    ..quadraticBezierTo(w * 0.44, h * 0.08, w * 0.5, h * 0.15)
    ..quadraticBezierTo(w * 0.56, h * 0.08, w * 0.62, h * 0.14)
    ..quadraticBezierTo(w * 0.86, h * 0.13, w * 0.91, h * 0.3)
    ..quadraticBezierTo(w * 0.95, h * 0.6, w * 0.78, h * 0.64)
    ..lineTo(w * 0.78, h * 0.95);
  // Wavy hem back to the start.
  const waves = 4;
  final step = (0.78 - 0.06) / waves;
  for (var i = 0; i < waves; i++) {
    final x0 = 0.78 - i * step;
    sheet.quadraticBezierTo(
      w * (x0 - step / 2),
      h * (i.isEven ? 0.89 : 1.0),
      w * (x0 - step),
      h * 0.95,
    );
  }
  sheet.close();
  canvas.drawPath(sheet, Paint()..color = Palette.ghost);
  canvas.drawPath(
    sheet,
    Paint()
      ..color = Palette.ghostOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012
      ..strokeJoin = StrokeJoin.round,
  );
}

Path _heartPath(Offset c, double r) => Path()
  ..moveTo(c.dx, c.dy + r * 0.9)
  ..cubicTo(
    c.dx - r * 1.3,
    c.dy - r * 0.1,
    c.dx - r * 0.6,
    c.dy - r * 1.1,
    c.dx,
    c.dy - r * 0.35,
  )
  ..cubicTo(
    c.dx + r * 0.6,
    c.dy - r * 1.1,
    c.dx + r * 1.3,
    c.dy - r * 0.1,
    c.dx,
    c.dy + r * 0.9,
  )
  ..close();

/// An open book Chigüi holds while in class.
void paintStudyBook(Canvas canvas, Size size) {
  final w = size.width;
  final h = size.height;
  final outline = Paint()
    ..color = Palette.furOutline
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.012
    ..strokeJoin = StrokeJoin.round;
  final cover = Path()
    ..moveTo(w * 0.34, h * 0.7)
    ..lineTo(w * 0.53, h * 0.74)
    ..lineTo(w * 0.72, h * 0.7)
    ..lineTo(w * 0.72, h * 0.86)
    ..lineTo(w * 0.53, h * 0.9)
    ..lineTo(w * 0.34, h * 0.86)
    ..close();
  canvas.drawPath(cover, Paint()..color = Palette.diving);
  canvas.drawPath(cover, outline);
  for (final (from, to) in [(0.36, 0.52), (0.54, 0.7)]) {
    final page = Path()
      ..moveTo(w * from, h * (from < 0.5 ? 0.69 : 0.73))
      ..lineTo(w * to, h * (from < 0.5 ? 0.73 : 0.69))
      ..lineTo(w * to, h * (from < 0.5 ? 0.86 : 0.82))
      ..lineTo(w * from, h * (from < 0.5 ? 0.82 : 0.86))
      ..close();
    canvas.drawPath(page, Paint()..color = Palette.cloud);
    canvas.drawPath(page, outline);
  }
  final line = Paint()
    ..color = Palette.ink.withValues(alpha: 0.35)
    ..strokeWidth = w * 0.008;
  for (var i = 0; i < 3; i++) {
    final y = 0.75 + i * 0.03;
    canvas.drawLine(
      Offset(w * 0.39, h * (y - 0.01)),
      Offset(w * 0.49, h * y),
      line,
    );
    canvas.drawLine(
      Offset(w * 0.57, h * y),
      Offset(w * 0.67, h * (y - 0.01)),
      line,
    );
  }
}

/// A page of the study book halfway through turning: 0 lies on the right
/// page, 1 on the left one, lifting towards the viewer in between.
void paintTurningPage(Canvas canvas, Size size, double t) {
  final w = size.width;
  final h = size.height;
  final reach = math.cos(t * math.pi);
  final lift = 0.05 * math.sin(t * math.pi);
  final edge = 0.53 + 0.17 * reach;
  final rise = 0.04 * reach.abs() + lift;
  final page = Path()
    ..moveTo(w * 0.53, h * 0.73)
    ..lineTo(w * edge, h * (0.73 - rise))
    ..lineTo(w * edge, h * (0.86 - rise))
    ..lineTo(w * 0.53, h * 0.86)
    ..close();
  canvas.drawPath(page, Paint()..color = Palette.cloud);
  canvas.drawPath(
    page,
    Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012
      ..strokeJoin = StrokeJoin.round,
  );
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

/// How high Chigüi sits on [seat] (where the bottom of the paws lands, as a
/// fraction of the height) and how much smaller Chigüi is drawn to fit.
(double, double) seatTop(String seat) => switch (seat) {
  'crocodile' => (0.79, 0.78),
  'skateboard' => (0.86, 0.88),
  _ => (0.83, 0.82),
};

/// How [seat] carries Chigüi on a walk, [ride] going 0 … 1 over one step:
/// sideways and up (fractions of the size) and a tilt (radians).
(double, double, double) seatRide(String seat, double ride) {
  final arc = math.sin(ride * math.pi);
  return switch (seat) {
    // Rolls forward and back.
    'skateboard' => (0.06 * arc, 0.0, 0.0),
    // Struggles up with a capybara on its back: lurches, dips, and wobbles.
    'seagull' => (
      0.03 * math.sin(ride * 3 * math.pi) * arc,
      -arc * (0.1 + 0.035 * math.sin(ride * 14 * math.pi)),
      0.14 * math.sin(ride * 5 * math.pi) * arc,
    ),
    // Strolls along smoothly, with a gentle sway.
    'crocodile' => (
      0.07 * arc,
      -0.008 * math.sin(ride * 4 * math.pi).abs(),
      0.0,
    ),
    _ => (0.0, 0.0, 0.0),
  };
}

/// The ground shadow under a seat, smaller the higher it is ([dy] < 0).
void paintSeatShadow(Canvas canvas, Size size, {double dx = 0, double dy = 0}) {
  final k = (1 + dy * 3).clamp(0.4, 1.0);
  canvas.drawOval(
    Rect.fromCenter(
      center: Offset(size.width * (0.5 + dx), size.height * 0.96),
      width: size.width * 0.96 * k,
      height: size.height * 0.08 * k,
    ),
    Paint()..color = Palette.ink.withValues(alpha: 0.12 * k),
  );
}

/// Draws something Chigüi sits on, below where Chigüi is drawn. [ride]
/// (0 … 1 over one step of a walk) moves it: wheels turn, wings flap, legs
/// step.
void paintSeat(Canvas canvas, Size size, String id, {double ride = 0}) {
  final w = size.width;
  final h = size.height;
  final outline = Paint()
    ..color = Palette.furOutline
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.012
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  Paint fill(Color c) => Paint()..color = c;
  Offset p(double x, double y) => Offset(w * x, h * y);

  switch (id) {
    case 'skateboard':
      // A deck as long as Chigüi, kicked up at both ends, on two trucks.
      for (final x in [0.22, 0.74]) {
        final truck = Rect.fromLTRB(
          w * (x - 0.05),
          h * 0.885,
          w * (x + 0.05),
          h * 0.915,
        );
        canvas.drawRect(truck, fill(Palette.console));
        canvas.drawRect(truck, outline);
      }
      final deck = Path()
        ..moveTo(w * 0.04, h * 0.835)
        ..quadraticBezierTo(w * 0.07, h * 0.88, w * 0.15, h * 0.88)
        ..lineTo(w * 0.85, h * 0.88)
        ..quadraticBezierTo(w * 0.93, h * 0.88, w * 0.96, h * 0.835);
      Paint stroke(Color c, double width) => Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(deck, stroke(Palette.furOutline, h * 0.035 + w * 0.024));
      canvas.drawPath(deck, stroke(Palette.santaRed, h * 0.035));
      canvas.drawPath(deck, stroke(Palette.cloud, h * 0.006));
      // Wheels with a hub and a dot that shows them turning: two turns a
      // step, easing in and out.
      final wheelTurn = (1 - math.cos(ride * math.pi)) * 2 * math.pi;
      for (final x in [0.22, 0.74]) {
        final c = p(x, 0.935);
        final r = w * 0.035;
        canvas.drawCircle(c, r, fill(Palette.ink));
        canvas.drawCircle(c, r * 0.45, fill(Palette.cloud));
        canvas.drawCircle(
          c + Offset(math.cos(wheelTurn), math.sin(wheelTurn)) * r * 0.72,
          r * 0.18,
          fill(Palette.sparkle),
        );
      }

    case 'crocodile':
      // A calm crocodile facing right, happy to be a sofa. On a walk its
      // legs step in diagonal pairs and the tail swishes.
      final stride = math.sin(ride * 4 * math.pi);
      final swish = 0.03 * math.sin(ride * 4 * math.pi - 1);
      void leg(double x, Color color, double phase) {
        final step = stride * phase;
        final lift = math.max(0.0, step) * 0.025;
        final r = RRect.fromLTRBR(
          w * (x + 0.025 * step),
          h * (0.86 - lift),
          w * (x + 0.08 + 0.025 * step),
          h * (0.97 - lift),
          Radius.circular(w * 0.03),
        );
        canvas.drawRRect(r, fill(color));
        canvas.drawRRect(r, outline);
      }

      leg(0.28, Palette.crocDark, -1);
      leg(0.6, Palette.crocDark, 1);
      final tail = Path()
        ..moveTo(w * 0.26, h * 0.78)
        ..quadraticBezierTo(
          w * 0.12,
          h * (0.8 + swish),
          w * 0.02,
          h * (0.9 + swish),
        )
        ..quadraticBezierTo(w * 0.14, h * (0.9 + swish), w * 0.26, h * 0.92)
        ..close();
      canvas.drawPath(tail, fill(Palette.croc));
      canvas.drawPath(tail, outline);
      // Head: a long snout ending in a round nose.
      final snout = RRect.fromLTRBAndCorners(
        w * 0.66,
        h * 0.8,
        w * 0.99,
        h * 0.91,
        topLeft: Radius.circular(w * 0.04),
        topRight: Radius.circular(w * 0.05),
        bottomRight: Radius.circular(w * 0.05),
        bottomLeft: Radius.circular(w * 0.04),
      );
      canvas.drawRRect(snout, fill(Palette.croc));
      canvas.drawRRect(snout, outline);
      final body = RRect.fromLTRBR(
        w * 0.2,
        h * 0.76,
        w * 0.76,
        h * 0.93,
        Radius.circular(w * 0.08),
      );
      canvas.drawRRect(body, fill(Palette.croc));
      // A pale belly and bumps along the back.
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.24,
          h * 0.88,
          w * 0.72,
          h * 0.93,
          Radius.circular(w * 0.03),
        ),
        fill(Palette.crocBelly),
      );
      for (var x = 0.06; x < 0.24; x += 0.045) {
        canvas.drawCircle(
          p(x + 0.04, 0.855 - x * 0.25),
          w * 0.012,
          fill(Palette.crocDark),
        );
      }
      canvas.drawRRect(body, outline);
      leg(0.24, Palette.croc, 1);
      leg(0.56, Palette.croc, -1);
      // Smile, two tiny teeth, nostril, and a sleepy-happy eye on a bump.
      canvas.drawArc(
        Rect.fromLTRB(w * 0.72, h * 0.8, w * 0.96, h * 0.885),
        0.3,
        math.pi * 0.55,
        false,
        outline,
      );
      for (final x in [0.8, 0.87]) {
        final tooth = Path()
          ..moveTo(w * x, h * 0.877)
          ..lineTo(w * (x + 0.02), h * 0.877)
          ..lineTo(w * (x + 0.01), h * 0.9)
          ..close();
        canvas.drawPath(tooth, fill(Palette.cloud));
      }
      canvas.drawCircle(p(0.95, 0.825), w * 0.008, fill(Palette.ink));
      final bump = p(0.74, 0.79);
      canvas.drawCircle(bump, w * 0.04, fill(Palette.croc));
      canvas.drawArc(
        Rect.fromCircle(center: bump, radius: w * 0.04),
        math.pi,
        math.pi,
        false,
        outline,
      );
      canvas.drawArc(
        Rect.fromCircle(
          center: bump.translate(0, h * 0.008),
          radius: w * 0.017,
        ),
        math.pi,
        math.pi,
        false,
        outline,
      );

    case 'seagull':
      // A seagull Chigüi sat on: a bit flattened, wings splayed, and not
      // quite sure how this happened.
      // Wings splayed out to both sides, black tips up. On a walk they flap
      // frantically: a capybara is heavy.
      final flap = 0.12 * math.sin(ride * 16 * math.pi);
      for (final (root, tip, low) in [
        (0.26, 0.03, 0.2),
        (0.66, 0.9, 0.72),
      ]) {
        final wing = Path()
          ..moveTo(w * root, h * 0.85)
          ..quadraticBezierTo(
            w * (root + tip) / 2,
            h * (0.74 + flap / 2),
            w * tip,
            h * (0.73 + flap),
          )
          ..quadraticBezierTo(
            w * (tip + low) / 2,
            h * (0.84 + flap / 3),
            w * low,
            h * 0.92,
          )
          ..close();
        canvas.drawPath(wing, fill(Palette.gullWing));
        canvas.save();
        canvas.clipPath(wing);
        canvas.drawCircle(p(tip, 0.73 + flap), w * 0.07, fill(Palette.ink));
        canvas.restore();
        // A few feather lines.
        for (final t in [0.35, 0.6]) {
          canvas.drawLine(
            p(root + (tip - root) * t * 0.6, 0.85 - 0.06 * t + flap * t / 2),
            p(low + (tip - low) * t, 0.92 - 0.15 * t + flap * t),
            outline,
          );
        }
        canvas.drawPath(wing, outline);
      }
      for (final x in [0.36, 0.52]) {
        final foot = Path()
          ..moveTo(w * x, h * 0.93)
          ..lineTo(w * (x - 0.03), h * 0.985)
          ..lineTo(w * (x + 0.05), h * 0.985)
          ..close();
        canvas.drawPath(foot, fill(Palette.orange));
        canvas.drawPath(foot, outline);
      }
      final body = Rect.fromLTRB(w * 0.16, h * 0.81, w * 0.8, h * 0.96);
      canvas.drawOval(body, fill(Palette.gull));
      canvas.drawOval(body, outline);
      // Head poking out in front, with a squeezed eye and a sweat drop.
      final head = p(0.84, 0.84);
      canvas.drawCircle(head, w * 0.065, fill(Palette.gull));
      canvas.drawCircle(head, w * 0.065, outline);
      final beak = Path()
        ..moveTo(w * 0.89, h * 0.835)
        ..lineTo(w * 0.99, h * 0.855)
        ..lineTo(w * 0.89, h * 0.875)
        ..close();
      canvas.drawPath(beak, fill(Palette.beak));
      canvas.drawCircle(p(0.95, 0.86), w * 0.007, fill(Palette.santaRed));
      canvas.drawPath(beak, outline);
      final squint = Paint()
        ..color = Palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.01
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p(0.83, 0.815), p(0.86, 0.83), squint);
      canvas.drawLine(p(0.83, 0.845), p(0.86, 0.83), squint);
      canvas.drawCircle(p(0.8, 0.79), w * 0.012, fill(Palette.sweat));
      // Little squash lines.
      for (final (x, dir) in [(0.12, -1.0), (0.86, 1.0)]) {
        canvas.drawLine(
          p(x, 0.79),
          p(x + dir * 0.03, 0.77),
          squint..color = Palette.ink.withValues(alpha: 0.4),
        );
      }
  }
}
