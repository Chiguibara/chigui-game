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

    case ('skateboard', Layer.front):
      final deck = RRect.fromLTRBR(
        w * 0.6,
        h * 0.885,
        w * 0.99,
        h * 0.935,
        Radius.circular(w * 0.025),
      );
      canvas.drawRRect(deck, fill(Palette.santaRed));
      canvas.drawRRect(deck, outline);
      for (final x in [0.67, 0.92]) {
        canvas.drawCircle(p(x, 0.955), w * 0.022, fill(Palette.ink));
        canvas.drawCircle(p(x, 0.955), w * 0.008, fill(Palette.cloud));
      }

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
