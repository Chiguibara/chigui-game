import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../minigame/bath_game.dart';
import 'chigui_view.dart' show chiguiSilhouette;
import 'palette.dart';

/// A soft, lumpy blob around [c], the same every frame for the same [seed].
Path _blob(Offset c, double r, int seed) {
  final rng = math.Random(seed);
  const n = 9;
  final points = [
    for (var i = 0; i < n; i++)
      () {
        final angle = i / n * 2 * math.pi + rng.nextDouble() * 0.3;
        final k = r * (0.75 + rng.nextDouble() * 0.45);
        return c + Offset(math.cos(angle) * k, math.sin(angle) * k);
      }(),
  ];
  Offset mid(int i) => (points[i % n] + points[(i + 1) % n]) / 2;
  final path = Path()..moveTo(mid(0).dx, mid(0).dy);
  for (var i = 1; i <= n; i++) {
    final p = points[i % n];
    path.quadraticBezierTo(p.dx, p.dy, mid(i).dx, mid(i).dy);
  }
  return path..close();
}

/// A drop hanging or falling, its tip at the top.
void _drop(Canvas canvas, Offset at, double r, Color color) {
  canvas.drawPath(
    Path()
      ..moveTo(at.dx, at.dy - r * 2.2)
      ..quadraticBezierTo(at.dx + r * 1.1, at.dy - r * 0.4, at.dx, at.dy + r)
      ..quadraticBezierTo(
        at.dx - r * 1.1,
        at.dy - r * 0.4,
        at.dx,
        at.dy - r * 2.2,
      ),
    Paint()..color = color,
  );
}

/// The dirt on Chigüi in the bath, drawn over Chigüi's own canvas: a grey
/// dusting while dirty, glossy tar [spots] with gravel stuck on, lather and
/// foam, tar dripping off, and water while [wet].
class GrimePainter extends CustomPainter {
  GrimePainter({
    required this.spots,
    this.dirt = 0,
    this.muddy = false,
    this.wet = 0,
    this.drip,
    this.dripTo = 0.97,
  });

  final List<Spot> spots;

  /// How dusty grey Chigüi looks all over, 0 to 1.
  final double dirt;

  /// Legs and belly still covered, before the first splash.
  final bool muddy;
  final double wet;

  /// Where drops are in their drip cycle (0 to 1); null keeps them still.
  final double? drip;

  /// Where falling drops land, as a fraction of the canvas height.
  final double dripTo;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.save();
    canvas.clipPath(chiguiSilhouette(size));
    if (dirt > 0) {
      // Grey all over, rolled in asphalt grit.
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Palette.asphalt.withValues(alpha: 0.55 * dirt),
      );
      final rng = math.Random(7);
      for (var i = 0; i < 90; i++) {
        canvas.drawCircle(
          Offset(
            w * (0.1 + rng.nextDouble() * 0.8),
            h * (0.15 + rng.nextDouble() * 0.8),
          ),
          w * (0.006 + rng.nextDouble() * 0.008),
          Paint()
            ..color = (i.isEven ? Palette.tar : Palette.asphaltLight)
                .withValues(alpha: 0.8 * dirt),
        );
      }
    }
    if (wet > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Palette.furOutline.withValues(alpha: 0.25 * wet),
      );
    }
    if (muddy) {
      for (final (x, y, r, seed) in const [
        (0.2, 0.86, 0.13, 11),
        (0.4, 0.9, 0.11, 12),
        (0.56, 0.9, 0.09, 13),
        (0.66, 0.86, 0.07, 14),
        (0.3, 0.74, 0.08, 15),
      ]) {
        _tar(canvas, size, Offset(w * x, h * y), w * r, seed, 1);
        _gravel(canvas, Offset(w * x, h * y), w * r, seed, 1);
      }
    }
    for (final spot in spots) {
      final c = Offset(w * spot.x, h * spot.y);
      final r = w * spot.size;
      switch (spot.state) {
        case SpotState.gravel:
          _tar(canvas, size, c, r, spot.seed, 1);
          _gravel(canvas, c, r, spot.seed, 1 - spot.scrubbed);
        case SpotState.tar:
          _tar(canvas, size, c, r, spot.seed, 1);
        case SpotState.lathered:
          _tar(canvas, size, c, r, spot.seed, 1 - spot.scrubbed);
          _foam(canvas, c, r, spot.seed, Palette.foam);
        case SpotState.foam:
          _foam(canvas, c, r, spot.seed, Palette.foamDirty);
        case SpotState.clean:
      }
    }
    if (wet > 0) {
      for (final (x, y) in const [(0.5, 0.3), (0.3, 0.6), (0.72, 0.5)]) {
        _drop(
          canvas,
          Offset(w * x, h * y),
          w * 0.014,
          Palette.sweat.withValues(alpha: wet),
        );
      }
    }
    canvas.restore();

    // Drops forming under the sticky spots, then falling.
    for (final spot in spots) {
      if (spot.state.index > SpotState.tar.index || spot.seed % 3 == 0) {
        continue;
      }
      _falling(
        canvas,
        size,
        Offset(w * spot.x, h * (spot.y + spot.size * 0.8)),
        spot.seed % 100 / 100,
        Palette.tar,
      );
    }
    if (wet > 0) {
      for (final (x, y, phase) in const [(0.82, 0.58, 0.0), (0.62, 0.7, 0.5)]) {
        _falling(
          canvas,
          size,
          Offset(w * x, h * y),
          phase,
          Palette.sweat.withValues(alpha: wet),
        );
      }
    }
  }

  void _falling(
    Canvas canvas,
    Size size,
    Offset from,
    double phase,
    Color color,
  ) {
    final r = size.width * 0.013;
    final drip = this.drip;
    if (drip == null) {
      _drop(canvas, from, r * 0.8, color);
      return;
    }
    final p = (drip + phase) % 1;
    if (p < 0.45) {
      _drop(canvas, from, r * p / 0.45, color);
      return;
    }
    final q = (p - 0.45) / 0.55;
    final y = from.dy + (size.height * dripTo - from.dy) * q * q;
    if (y < from.dy) return;
    _drop(canvas, Offset(from.dx, y), r, color);
  }

  /// Glossy black tar, with a highlight and sometimes a hanging drip.
  void _tar(
    Canvas canvas,
    Size size,
    Offset c,
    double r,
    int seed,
    double opacity,
  ) {
    if (opacity <= 0) return;
    final paint = Paint()..color = Palette.tar.withValues(alpha: opacity);
    canvas.drawPath(_blob(c, r, seed), paint);
    if (seed.isEven) {
      _drop(canvas, c.translate(r * 0.2, r * 0.95), r * 0.3, paint.color);
    }
    final shine = Paint()
      ..color = Palette.tarShine.withValues(alpha: 0.7 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r * 0.55),
      math.pi * 1.1,
      math.pi * 0.4,
      false,
      shine,
    );
    canvas.drawCircle(
      c.translate(r * 0.25, -r * 0.4),
      r * 0.08,
      Paint()..color = shine.color,
    );
  }

  /// Asphalt gravel stuck on the tar.
  void _gravel(Canvas canvas, Offset c, double r, int seed, double opacity) {
    if (opacity <= 0) return;
    final rng = math.Random(seed + 1);
    for (var i = 0; i < 10; i++) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final k = r * 0.85 * math.sqrt(rng.nextDouble());
      final color = i.isEven ? Palette.asphaltLight : Palette.asphalt;
      canvas.drawCircle(
        c + Offset(math.cos(angle) * k, math.sin(angle) * k),
        r * (0.11 + rng.nextDouble() * 0.09),
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  /// A cluster of bubbles.
  void _foam(Canvas canvas, Offset c, double r, int seed, Color color) {
    final rng = math.Random(seed + 2);
    final edge = Paint()
      ..color = Palette.asphaltLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.05;
    for (var i = 0; i < 7; i++) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final k = r * 0.7 * math.sqrt(rng.nextDouble());
      final at = c + Offset(math.cos(angle) * k, math.sin(angle) * k);
      final radius = r * (i < 5 ? 0.35 + rng.nextDouble() * 0.2 : 0.15);
      canvas.drawCircle(at, radius, Paint()..color = color);
      canvas.drawCircle(at, radius, edge);
      canvas.drawCircle(
        at.translate(-radius * 0.35, -radius * 0.35),
        radius * 0.2,
        Paint()..color = Palette.cloud,
      );
    }
  }

  @override
  bool shouldRepaint(GrimePainter old) => true;
}

/// Which half of the tub to draw: the back goes behind Chigüi, the front
/// (the near wall and the water in front of Chigüi) over them.
enum TubPart { back, front }

/// A round hinoki wooden tub, with steam and floating yuzus.
class HinokiTub extends StatelessWidget {
  const HinokiTub({
    super.key,
    required this.part,
    required this.width,
    this.murk = 0,
    this.yuzus = 0,
    this.time = 0,
  });

  /// Height over width.
  static const aspect = 0.5;

  /// Where the water's surface crosses Chigüi, as a fraction of the height.
  static const waterLine = 0.24;

  final TubPart part;
  final double width;

  /// How grey the water has turned, 0 to 1.
  final double murk;
  final int yuzus;

  /// 0 to 1, looping: for the steam and bobbing yuzus.
  final double time;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(width, width * aspect),
    painter: _TubPainter(part, murk, yuzus, time),
  );
}

class _TubPainter extends CustomPainter {
  _TubPainter(this.part, this.murk, this.yuzus, this.time);

  final TubPart part;
  final double murk;
  final int yuzus;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012
      ..strokeJoin = StrokeJoin.round;
    final rim = Rect.fromCenter(
      center: Offset(w / 2, h * 0.18),
      width: w,
      height: h * 0.34,
    );
    final water = Rect.fromCenter(
      center: Offset(w / 2, h * HinokiTub.waterLine),
      width: w * 0.9,
      height: h * 0.26,
    );
    final waterColor = Color.lerp(
      Palette.bathWater,
      Palette.bathWaterMurky,
      murk,
    )!;

    if (part == TubPart.back) {
      canvas.drawOval(rim, Paint()..color = Palette.hinokiDark);
      canvas.drawOval(water, Paint()..color = waterColor);
      final lip = Paint()
        ..color = Palette.hinoki
        ..style = PaintingStyle.stroke
        ..strokeWidth = h * 0.05;
      canvas.drawArc(rim.deflate(h * 0.025), math.pi, math.pi, false, lip);
      canvas.drawArc(rim, math.pi, math.pi, false, outline);
      return;
    }

    // The water in front of Chigüi, so they sit in it.
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, water.center.dy, w, h));
    canvas.drawOval(water, Paint()..color = waterColor.withValues(alpha: 0.92));
    canvas.restore();
    canvas.drawArc(
      water.deflate(w * 0.04),
      0.3,
      0.8,
      false,
      Paint()
        ..color = Palette.cloud.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.01
        ..strokeCap = StrokeCap.round,
    );

    // Yuzus bobbing on the water.
    for (var i = 0; i < math.min(yuzus, 5); i++) {
      final x = const [0.3, 0.64, 0.47, 0.78, 0.18][i];
      final bob = math.sin((time + i * 0.3) * 2 * math.pi) * h * 0.012;
      paintYuzu(
        canvas,
        Offset(w * x, water.center.dy + water.height * 0.22 + bob),
        w * 0.05,
      );
    }

    // The near wall, slightly narrower at the bottom.
    final bottom = Rect.fromLTRB(w * 0.06, h * 0.86, w * 0.94, h * 0.98);
    final wall = Path()
      ..moveTo(0, rim.center.dy)
      ..lineTo(bottom.left, bottom.center.dy)
      ..arcTo(bottom, math.pi, -math.pi, false)
      ..lineTo(w, rim.center.dy)
      ..arcTo(rim, 0, math.pi, false)
      ..close();
    canvas.drawPath(wall, Paint()..color = Palette.hinoki);
    canvas.save();
    canvas.clipPath(wall);
    final stave = Paint()
      ..color = Palette.hinokiDark
      ..strokeWidth = w * 0.008;
    for (var x = 0.14; x < 0.9; x += 0.12) {
      final dx = (x - 0.5) * 2;
      final top = rim.center.dy + rim.height / 2 * math.sqrt(1 - dx * dx);
      canvas.drawLine(Offset(w * x, top), Offset(w * x, h), stave);
    }
    final band = Paint()
      ..color = Palette.hinokiBand
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.06;
    for (final y in [0.5, 0.8]) {
      canvas.drawArc(
        Rect.fromLTRB(-w * 0.05, h * (y - 0.14), w * 1.05, h * (y + 0.12)),
        0,
        math.pi,
        false,
        band,
      );
    }
    canvas.restore();
    canvas.drawPath(wall, outline);
    final lip = Paint()
      ..color = Palette.hinoki
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.05;
    canvas.drawArc(rim.deflate(h * 0.025), 0, math.pi, false, lip);
    canvas.drawArc(rim.deflate(h * 0.05), 0, math.pi, false, outline);

    // Steam rising from the warm water.
    for (var i = 0; i < 3; i++) {
      final p = (time + i / 3) % 1;
      final x = w * (0.3 + 0.2 * i);
      final y = water.top - h * 0.1 - p * h * 0.8;
      canvas.drawPath(
        Path()
          ..moveTo(x, y + h * 0.3)
          ..cubicTo(x - w * 0.04, y + h * 0.2, x + w * 0.04, y + h * 0.1, x, y),
        Paint()
          ..color = Palette.cloud.withValues(
            alpha: 0.5 * math.sin(p * math.pi),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.014
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_TubPainter old) =>
      old.part != part ||
      old.murk != murk ||
      old.yuzus != yuzus ||
      old.time != time;
}

/// A yuzu: a bumpy little citrus with a leaf.
void paintYuzu(Canvas canvas, Offset c, double r) {
  canvas.drawCircle(c, r, Paint()..color = Palette.yuzu);
  final dimple = Paint()..color = Palette.yuzuDark;
  for (final (dx, dy) in const [(-0.4, 0.2), (0.3, 0.35), (0.1, -0.1)]) {
    canvas.drawCircle(c.translate(r * dx, r * dy), r * 0.08, dimple);
  }
  canvas.drawCircle(
    c,
    r,
    Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.12,
  );
  canvas.drawOval(
    Rect.fromCenter(
      center: c.translate(r * 0.45, -r * 0.95),
      width: r * 0.8,
      height: r * 0.4,
    ),
    Paint()..color = Palette.leaf,
  );
}

/// A bath tool, drawn in code, for the tool tray.
class BathToolIcon extends StatelessWidget {
  const BathToolIcon({super.key, required this.tool, this.size = 40});

  final BathTool tool;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _ToolPainter(tool),
  );
}

class _ToolPainter extends CustomPainter {
  _ToolPainter(this.tool);

  final BathTool tool;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final outline = Paint()
      ..color = Palette.furOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    void shape(Path path, Color color) {
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(path, outline);
    }

    switch (tool) {
      case BathTool.soap:
        canvas.save();
        canvas.translate(w / 2, w * 0.6);
        canvas.rotate(-0.25);
        shape(
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: w * 0.7,
                height: w * 0.42,
              ),
              Radius.circular(w * 0.14),
            ),
          ),
          Palette.soap,
        );
        canvas.restore();
        for (final (x, y, r) in const [
          (0.72, 0.22, 0.09),
          (0.86, 0.36, 0.06),
        ]) {
          shape(
            Path()..addOval(
              Rect.fromCircle(center: Offset(w * x, w * y), radius: w * r),
            ),
            Palette.foam,
          );
        }
      case BathTool.brush:
        for (var i = 0; i < 6; i++) {
          final x = w * (0.2 + i * 0.12);
          canvas.drawLine(
            Offset(x, w * 0.55),
            Offset(x, w * 0.8),
            Paint()
              ..color = Palette.bristle
              ..strokeWidth = w * 0.07
              ..strokeCap = StrokeCap.round,
          );
        }
        shape(
          Path()..addRRect(
            RRect.fromLTRBR(
              w * 0.1,
              w * 0.35,
              w * 0.9,
              w * 0.58,
              Radius.circular(w * 0.12),
            ),
          ),
          Palette.hinokiDark,
        );
      case BathTool.ladle:
        shape(
          Path()..addRRect(
            RRect.fromLTRBR(
              w * 0.4,
              w * 0.36,
              w * 0.94,
              w * 0.46,
              Radius.circular(w * 0.05),
            ),
          ),
          Palette.hinokiDark,
        );
        shape(
          Path()..addRRect(
            RRect.fromLTRBR(
              w * 0.08,
              w * 0.3,
              w * 0.46,
              w * 0.78,
              Radius.circular(w * 0.06),
            ),
          ),
          Palette.hinoki,
        );
        canvas.drawOval(
          Rect.fromLTRB(w * 0.12, w * 0.26, w * 0.42, w * 0.36),
          Paint()..color = Palette.bathWater,
        );
      case BathTool.yuzu:
        paintYuzu(canvas, Offset(w / 2, w * 0.56), w * 0.3);
      case BathTool.towel:
        final towel = Path()
          ..addRRect(
            RRect.fromLTRBR(
              w * 0.12,
              w * 0.24,
              w * 0.88,
              w * 0.8,
              Radius.circular(w * 0.1),
            ),
          );
        canvas.drawPath(towel, Paint()..color = Palette.towel);
        canvas.save();
        canvas.clipPath(towel);
        for (final y in [0.36, 0.66]) {
          canvas.drawRect(
            Rect.fromLTRB(0, w * y, w, w * (y + 0.07)),
            Paint()..color = Palette.cloud,
          );
        }
        canvas.restore();
        canvas.drawPath(towel, outline);
        canvas.drawLine(
          Offset(w * 0.12, w * 0.5),
          Offset(w * 0.88, w * 0.5),
          outline,
        );
    }
  }

  @override
  bool shouldRepaint(_ToolPainter old) => old.tool != tool;
}
