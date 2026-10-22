import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../minigame/bath_game.dart';
import 'chigui_view.dart' show chiguiSilhouette;
import 'palette.dart';

/// How far a tar patch reaches at each angle, as a factor of its radius:
/// lumpy but smooth, the same every frame for the same [seed].
double Function(double) _lumps(int seed) {
  final rng = math.Random(seed);
  final phases = [for (var i = 0; i < 3; i++) rng.nextDouble() * 2 * math.pi];
  final a = 0.07 + rng.nextDouble() * 0.06;
  final b = 0.04 + rng.nextDouble() * 0.05;
  final c = 0.02 + rng.nextDouble() * 0.03;
  return (t) =>
      0.92 +
      a * math.sin(2 * t + phases[0]) +
      b * math.sin(3 * t + phases[1]) +
      c * math.sin(5 * t + phases[2]);
}

/// A tar patch around [c]: a lumpy puddle, a bit wider than tall since it
/// lies on Chigüi, with a few clumped fur tufts poking out of its edge.
class _Patch {
  _Patch(this.c, this.r, this.seed, {this.tufts = 3}) : lumps = _lumps(seed);

  final Offset c;
  final double r;
  final int seed;
  final int tufts;
  final double Function(double) lumps;

  /// The point at [angle], [k] times as far out as the edge.
  Offset at(double angle, [double k = 1]) {
    final d = r * lumps(angle) * k;
    return c + Offset(math.cos(angle) * d * 1.1, math.sin(angle) * d * 0.95);
  }

  Path get path {
    const n = 28;
    final rng = math.Random(seed + 3);
    // Tufts on the top and sides; drips hang from the bottom.
    final spikes = <int>{};
    for (var i = 0; spikes.length < tufts && i < 40; i++) {
      final k = rng.nextInt(n);
      final angle = k / n * 2 * math.pi;
      if (angle > math.pi * 0.2 && angle < math.pi * 0.8) continue;
      if (spikes.any((s) => (s - k).abs() < 3)) continue;
      spikes.add(k);
    }
    final points = [for (var i = 0; i < n; i++) at(i / n * 2 * math.pi)];
    Offset mid(int i) => (points[i % n] + points[(i + 1) % n]) / 2;
    final path = Path()..moveTo(mid(0).dx, mid(0).dy);
    for (var i = 1; i <= n; i++) {
      final m = mid(i);
      if (spikes.contains(i % n)) {
        final angle = i / n * 2 * math.pi;
        final left = at(angle - 0.05, 0.98);
        final tip = at(angle + 0.07, 1.17);
        final right = at(angle + 0.05, 0.98);
        final p = points[i % n];
        path
          ..quadraticBezierTo(p.dx, p.dy, left.dx, left.dy)
          ..quadraticBezierTo(tip.dx, tip.dy, tip.dx, tip.dy)
          ..lineTo(right.dx, right.dy)
          ..quadraticBezierTo(p.dx, p.dy, m.dx, m.dy);
      } else {
        final p = points[i % n];
        path.quadraticBezierTo(p.dx, p.dy, m.dx, m.dy);
      }
    }
    return path..close();
  }
}

/// A thick drip of tar hanging from [root], its round end [length] below.
class _Drip {
  _Drip(this.root, this.width, this.length);

  final Offset root;
  final double width;
  final double length;

  Offset get end => root.translate(0, length);
  double get bulb => width * 1.15;

  Path get path {
    final x = root.dx;
    final top = root.dy - width * 2;
    final e = end;
    return Path()
      ..moveTo(x - width, top)
      ..lineTo(x - width, root.dy)
      ..quadraticBezierTo(x - width * 0.6, e.dy - bulb, e.dx - bulb, e.dy)
      ..arcToPoint(
        Offset(e.dx + bulb, e.dy),
        radius: Radius.circular(bulb),
        clockwise: false,
      )
      ..quadraticBezierTo(x + width * 0.6, e.dy - bulb, x + width, root.dy)
      ..lineTo(x + width, top)
      ..close();
  }
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
/// dusting while dirty, glossy tar [spots] that follow Chigüi's shape, drip,
/// and have gravel stuck on, tar breaking up into grey smears under the
/// lather, dirty foam, and water while [wet].
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
    final body = _outline(size);
    canvas.save();
    canvas.clipPath(body);
    if (dirt > 0) _dust(canvas, size);
    if (wet > 0) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Palette.furOutline.withValues(alpha: 0.25 * wet),
      );
    }
    canvas.restore();
    if (muddy) _wadedIn(canvas, size, body);
    // All the tar is drawn together, so overlapping spots merge into one
    // sticky mess; the lather goes on top.
    final tar = <_Patch>[];
    final drips = <_Drip>[];
    final gravel = <Spot>[];
    final foam = <(Offset, double, int, double)>[];
    for (final spot in spots) {
      final c = Offset(w * spot.x, h * spot.y);
      final r = w * spot.size;
      final s = spot.scrubbed;
      switch (spot.state) {
        case SpotState.gravel || SpotState.tar:
          tar.addAll(_parts(c, r, spot.seed, 1));
          drips.addAll(_drips(spot, size));
          if (spot.state == SpotState.gravel) gravel.add(spot);
        case SpotState.lathered:
          _residue(canvas, body, c, r, spot.seed, s);
          tar.addAll(_parts(c, r, spot.seed, 1 - s));
          if (s < 0.5) drips.addAll(_drips(spot, size, 1 - s * 2));
          foam.add((c, r * (0.8 + 0.3 * s), spot.seed, 0.6 * s));
        case SpotState.foam:
          _residue(canvas, body, c, r, spot.seed, 1);
          foam.add((c, r, spot.seed, 1));
        case SpotState.clean:
      }
    }
    _tar(canvas, size, body, tar, drips);
    for (final spot in gravel) {
      _gravel(
        canvas,
        body,
        Offset(w * spot.x, h * spot.y),
        w * spot.size,
        spot.seed,
        1 - spot.scrubbed,
      );
    }
    for (final (c, r, seed, dirty) in foam) {
      _foam(canvas, c, r, seed, dirty);
    }
    if (wet > 0) {
      canvas.save();
      canvas.clipPath(body);
      for (final (x, y) in const [(0.5, 0.3), (0.3, 0.6), (0.72, 0.5)]) {
        _drop(
          canvas,
          Offset(w * x, h * y),
          w * 0.014,
          Palette.sweat.withValues(alpha: wet),
        );
      }
      canvas.restore();
    }

    // Drops forming at the end of the sticky drips, then falling.
    for (final spot in spots) {
      if (spot.state.index > SpotState.tar.index) continue;
      final drips = _drips(spot, size);
      if (drips.isEmpty || spot.seed % 3 == 0) continue;
      final from = drips.first.end;
      if (!body.contains(drips.first.root)) continue;
      _falling(canvas, size, from, spot.seed % 100 / 100, Palette.tar);
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

  /// A spot's tar: one patch while whole; as it is [left] less, it shrinks
  /// and breaks into smaller patches.
  List<_Patch> _parts(Offset c, double r, int seed, double left) {
    if (left >= 1) return [_Patch(c, r, seed)];
    if (left <= 0) return const [];
    final rng = math.Random(seed + 4);
    final start = rng.nextDouble() * 2 * math.pi;
    return [
      _Patch(c, r * (0.25 + 0.6 * left), seed, tufts: 2),
      for (var i = 0; i < 3; i++)
        _Patch(
          _Patch(c, r, seed).at(start + i * 2.1 + rng.nextDouble() * 0.6, 0.7),
          r * (0.18 + 0.14 * left),
          seed + 10 + i,
          tufts: 1,
        ),
    ];
  }

  /// The drips hanging from a spot's lower edge, [left] as long as when the
  /// tar is whole, stretching slowly while the drops form.
  List<_Drip> _drips(Spot spot, Size size, [double left = 1]) {
    final w = size.width;
    final rng = math.Random(spot.seed + 5);
    final count = rng.nextInt(3);
    final r = w * spot.size;
    final patch = _Patch(
      Offset(w * spot.x, size.height * spot.y),
      r,
      spot.seed,
    );
    final drip = this.drip;
    return [
      for (var i = 0; i < count; i++)
        () {
          final angle = math.pi * (0.3 + 0.18 * i + rng.nextDouble() * 0.2);
          final stretch = drip == null
              ? 0.0
              : math.sin((drip + i * 0.4 + spot.seed % 7 / 7) * 2 * math.pi);
          return _Drip(
            patch.at(angle, 0.9),
            r * (0.13 + rng.nextDouble() * 0.05),
            r * (0.35 + rng.nextDouble() * 0.35) * (1 + 0.08 * stretch) * left,
          );
        }(),
    ];
  }

  /// Glossy tar: drips, a dark rim, a sheen toward the light, a darker edge
  /// where it wraps around Chigüi, and curved highlights.
  void _tar(
    Canvas canvas,
    Size size,
    Path body,
    List<_Patch> parts,
    List<_Drip> drips,
  ) {
    if (parts.isEmpty) return;
    final w = size.width;
    // Only drips that hang from tar on Chigüi; they may hang past the edge.
    drips = [
      for (final d in drips)
        if (body.contains(d.root)) d,
    ];
    final rim = Paint()
      ..color = Palette.tarRim
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.014
      ..strokeJoin = StrokeJoin.round;
    final paths = [for (final p in parts) p.path];
    for (final d in drips) {
      canvas.drawPath(d.path, rim);
    }
    canvas.save();
    canvas.clipPath(body);
    for (final p in paths) {
      canvas.drawPath(p, rim);
    }
    canvas.restore();
    for (final d in drips) {
      canvas.drawPath(d.path, Paint()..color = Palette.tar);
      canvas.drawCircle(
        d.end.translate(-d.bulb * 0.35, -d.bulb * 0.3),
        d.bulb * 0.28,
        Paint()..color = Palette.tarShine.withValues(alpha: 0.8),
      );
    }
    canvas.save();
    canvas.clipPath(body);
    for (var i = 0; i < parts.length; i++) {
      final p = parts[i];
      canvas.drawPath(
        paths[i],
        Paint()
          ..shader =
              RadialGradient(
                center: Alignment.center,
                colors: const [Palette.tarSheen, Palette.tar, Palette.tarRim],
                stops: const [0, 0.55, 1],
              ).createShader(
                Rect.fromCircle(
                  center: p.c.translate(-p.r * 0.3, -p.r * 0.35),
                  radius: p.r * 2,
                ),
              ),
      );
    }
    // Where the tar reaches Chigüi's edge, it wraps around it.
    final all = Path();
    for (final p in paths) {
      all.addPath(p, Offset.zero);
    }
    canvas.save();
    canvas.clipPath(all);
    canvas.drawPath(
      body,
      Paint()
        ..color = Palette.tarRim
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03,
    );
    canvas.restore();
    for (final p in parts) {
      _shine(canvas, p);
    }
    canvas.restore();
  }

  /// A curved highlight following the patch's upper left, a glint, and a
  /// faint reflected light on its lower right.
  void _shine(Canvas canvas, _Patch p) {
    Path along(double from, double to, double k) {
      final path = Path();
      for (var i = 0; i <= 8; i++) {
        final pt = p.at(from + (to - from) * i / 8, k);
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      return path;
    }

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      along(math.pi * 1.06, math.pi * 1.4, 0.66),
      line
        ..color = Palette.tarShine.withValues(alpha: 0.85)
        ..strokeWidth = p.r * 0.13,
    );
    canvas.drawCircle(
      p.at(math.pi * 1.53, 0.64),
      p.r * 0.07,
      Paint()..color = Palette.tarShine.withValues(alpha: 0.85),
    );
    canvas.drawPath(
      along(math.pi * 0.08, math.pi * 0.36, 0.78),
      line
        ..color = Palette.tarShine.withValues(alpha: 0.3)
        ..strokeWidth = p.r * 0.06,
    );
  }

  /// Chigüi waded through tar: the legs and belly are covered up to a wavy
  /// line, with splashes above it and gravel stuck on.
  void _wadedIn(Canvas canvas, Size size, Path body) {
    final w = size.width;
    final h = size.height;
    double edge(double x) =>
        h *
        (0.8 +
            0.022 * math.sin(x * 11 + 1) +
            0.012 * math.sin(x * 27 + 2) -
            0.03 * (x - 0.4).abs());
    final band = Path()..moveTo(0, h);
    const n = 40;
    for (var i = 0; i <= n; i++) {
      final x = i / n;
      final y = edge(x);
      // A few fur tufts poking up.
      if (i % 9 == 4) {
        band
          ..lineTo(w * (x - 0.006), y)
          ..quadraticBezierTo(
            w * x,
            y - h * 0.01,
            w * (x + 0.008),
            y - h * 0.022,
          )
          ..lineTo(w * (x + 0.008), y);
      } else {
        band.lineTo(w * x, y);
      }
    }
    band
      ..lineTo(w, h)
      ..close();
    canvas.save();
    canvas.clipPath(body);
    canvas.drawPath(
      band,
      Paint()
        ..color = Palette.tarRim
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.014
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      band,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Palette.tarSheen, Palette.tar, Palette.tarRim],
          stops: [0, 0.35, 1],
        ).createShader(Rect.fromLTRB(0, h * 0.76, w, h * 0.96)),
    );
    canvas.save();
    canvas.clipPath(band);
    canvas.drawPath(
      body,
      Paint()
        ..color = Palette.tarRim
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03,
    );
    canvas.restore();
    // Glints along the wet top, broken into a few strokes.
    final shine = Paint()
      ..color = Palette.tarShine.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.011
      ..strokeCap = StrokeCap.round;
    for (final (from, to) in const [(0.14, 0.24), (0.34, 0.4), (0.5, 0.58)]) {
      final path = Path();
      for (var i = 0; i <= 6; i++) {
        final x = from + (to - from) * i / 6;
        final pt = Offset(w * x, edge(x) + h * 0.03);
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      canvas.drawPath(path, shine);
    }
    // Splashes above the line.
    final rng = math.Random(21);
    for (var i = 0; i < 6; i++) {
      final x = 0.12 + rng.nextDouble() * 0.56;
      final at = Offset(w * x, edge(x) - h * (0.025 + rng.nextDouble() * 0.06));
      final r = w * (0.007 + rng.nextDouble() * 0.008);
      canvas.drawCircle(at, r + w * 0.004, Paint()..color = Palette.tarRim);
      canvas.drawCircle(at, r, Paint()..color = Palette.tar);
    }
    canvas.restore();
    for (final (x, y, seed) in const [
      (0.24, 0.87, 11),
      (0.46, 0.9, 12),
      (0.64, 0.88, 13),
    ]) {
      _gravel(canvas, body, Offset(w * x, h * y), w * 0.08, seed, 0.6);
    }
  }

  /// Grey all over, with darker smudges low down and specks of grit.
  void _dust(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Palette.asphalt.withValues(alpha: 0.32 * dirt),
    );
    for (final (x, y, r, seed) in const [
      (0.22, 0.7, 0.14, 31),
      (0.5, 0.74, 0.12, 32),
      (0.3, 0.52, 0.09, 33),
      (0.78, 0.27, 0.06, 34),
      (0.48, 0.3, 0.06, 35),
    ]) {
      canvas.drawPath(
        _Patch(Offset(w * x, h * y), w * r, seed, tufts: 0).path,
        Paint()..color = Palette.asphalt.withValues(alpha: 0.28 * dirt),
      );
    }
    final rng = math.Random(7);
    final speck = Paint()
      ..strokeWidth = w * 0.007
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 70; i++) {
      final x = 0.1 + rng.nextDouble() * 0.8;
      final y = 0.15 + rng.nextDouble() * 0.8;
      final angle = rng.nextDouble() * math.pi;
      final len = w * (0.004 + rng.nextDouble() * 0.008);
      // Keep the eye and the smile clear.
      if (_near(x, y, 0.6, 0.34, 0.06) || _near(x, y, 0.8, 0.47, 0.06)) {
        continue;
      }
      final at = Offset(w * x, h * y);
      final d = Offset(math.cos(angle), math.sin(angle)) * len;
      canvas.drawLine(
        at - d,
        at + d,
        speck
          ..color = (i.isEven ? Palette.tar : Palette.asphaltLight).withValues(
            alpha: 0.7 * dirt,
          ),
      );
    }
  }

  static bool _near(double x, double y, double x2, double y2, double r) =>
      (x - x2) * (x - x2) + (y - y2) * (y - y2) < r * r;

  /// Grey smears left as the tar is scrubbed off, [amount] 0 to 1.
  void _residue(
    Canvas canvas,
    Path body,
    Offset c,
    double r,
    int seed,
    double amount,
  ) {
    if (amount <= 0) return;
    canvas.save();
    canvas.clipPath(body);
    canvas.drawPath(
      _Patch(c, r * 0.95, seed, tufts: 0).path,
      Paint()..color = Palette.asphalt.withValues(alpha: 0.3 * amount),
    );
    final rng = math.Random(seed + 6);
    final angle = -0.5 + rng.nextDouble() * 0.5;
    final along = Offset(math.cos(angle), math.sin(angle));
    final across = Offset(-along.dy, along.dx);
    final streak = Paint()
      ..color = Palette.asphalt.withValues(alpha: 0.5 * amount)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final mid = c + across * r * (-0.55 + i * 0.37 + rng.nextDouble() * 0.1);
      final len = r * (0.5 + rng.nextDouble() * 0.5);
      final from = mid - along * len;
      final to = mid + along * len;
      final bend = mid + across * r * 0.15;
      canvas.drawPath(
        Path()
          ..moveTo(from.dx, from.dy)
          ..quadraticBezierTo(bend.dx, bend.dy, to.dx, to.dy),
        streak..strokeWidth = r * (0.08 + rng.nextDouble() * 0.06),
      );
    }
    canvas.restore();
  }

  /// Asphalt gravel stuck in the tar: little angular stones, brushed off
  /// one by one as [left] goes down.
  void _gravel(
    Canvas canvas,
    Path body,
    Offset c,
    double r,
    int seed,
    double left,
  ) {
    if (left <= 0) return;
    final rng = math.Random(seed + 1);
    const count = 8;
    final edge = Paint()
      ..color = Palette.tarRim
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.04
      ..strokeJoin = StrokeJoin.round;
    canvas.save();
    canvas.clipPath(body);
    for (var i = 0; i < count; i++) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final k = r * 0.75 * math.sqrt(rng.nextDouble());
      final at = c + Offset(math.cos(angle) * k, math.sin(angle) * k);
      final size = r * (0.08 + rng.nextDouble() * 0.07);
      final turn = rng.nextDouble() * math.pi;
      final corners = [
        for (var j = 0; j < 5; j++)
          at +
              Offset(
                    math.cos(turn + j * 1.26),
                    math.sin(turn + j * 1.26),
                  ) *
                  size *
                  (0.7 + rng.nextDouble() * 0.4),
      ];
      if (i < (1 - left) * count) continue;
      final stone = Path()..addPolygon(corners, true);
      canvas.drawPath(
        stone,
        Paint()..color = i.isEven ? Palette.asphaltLight : Palette.asphalt,
      );
      canvas.drawPath(stone, edge);
      canvas.drawCircle(
        at.translate(-size * 0.3, -size * 0.3),
        size * 0.22,
        Paint()..color = Palette.cloud.withValues(alpha: 0.6),
      );
    }
    canvas.restore();
  }

  /// A cloud of lather: bubbles that merge into one soft shape, a few
  /// bubble edges and glints inside, and [dirty] (0 to 1) greying it with
  /// flecks of tar.
  void _foam(Canvas canvas, Offset c, double r, int seed, double dirty) {
    final rng = math.Random(seed + 2);
    final bubbles = [
      for (var i = 0; i < 9; i++)
        () {
          final angle = rng.nextDouble() * 2 * math.pi;
          final k = r * 0.65 * math.sqrt(rng.nextDouble());
          final radius = r * (i < 6 ? 0.3 + rng.nextDouble() * 0.18 : 0.14);
          return (c + Offset(math.cos(angle) * k, math.sin(angle) * k), radius);
        }(),
    ];
    final edgeWidth = r * 0.07;
    for (final (at, radius) in bubbles) {
      canvas.drawCircle(
        at,
        radius + edgeWidth,
        Paint()..color = Palette.foamEdge,
      );
    }
    final fill = Color.lerp(Palette.foam, Palette.foamDirty, dirty * 0.75)!;
    for (final (at, radius) in bubbles) {
      canvas.drawCircle(at, radius, Paint()..color = fill);
    }
    final line = Paint()
      ..color = Palette.foamEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.035
      ..strokeCap = StrokeCap.round;
    for (final (at, radius) in bubbles.skip(3)) {
      canvas.drawArc(
        Rect.fromCircle(center: at, radius: radius * 0.8),
        0.1,
        1.3,
        false,
        line,
      );
    }
    for (final (at, radius) in bubbles) {
      canvas.drawCircle(
        at.translate(-radius * 0.4, -radius * 0.4),
        radius * 0.16,
        Paint()..color = Palette.cloud,
      );
    }
    if (dirty > 0) {
      for (var i = 0; i < 5; i++) {
        final angle = rng.nextDouble() * 2 * math.pi;
        final k = r * 0.6 * math.sqrt(rng.nextDouble());
        canvas.drawCircle(
          c + Offset(math.cos(angle) * k, math.sin(angle) * k),
          r * (0.03 + rng.nextDouble() * 0.04),
          Paint()
            ..color = (i.isEven ? Palette.tar : Palette.asphalt).withValues(
              alpha: 0.7 * dirty,
            ),
        );
      }
    }
    // A couple of loose bubbles.
    for (var i = 0; i < 2; i++) {
      final angle = rng.nextDouble() * 2 * math.pi;
      final at = c + Offset(math.cos(angle), math.sin(angle)) * r * 0.95;
      final radius = r * 0.1;
      canvas.drawCircle(at, radius, Paint()..color = fill);
      canvas.drawCircle(
        at,
        radius,
        Paint()
          ..color = Palette.foamEdge
          ..style = PaintingStyle.stroke
          ..strokeWidth = edgeWidth,
      );
    }
  }

  /// Chigüi's outer edge as one shape, so stroking it draws no lines where
  /// the head, body, and legs overlap; kept while the size stays the same.
  static Path _outline(Size size) {
    if (size != _outlineSize) {
      _outlineSize = size;
      _outlinePath = Path.combine(
        PathOperation.union,
        Path(),
        chiguiSilhouette(size),
      );
    }
    return _outlinePath;
  }

  static Size? _outlineSize;
  static Path _outlinePath = Path();

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
