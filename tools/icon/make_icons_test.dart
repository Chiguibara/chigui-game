// Renders the app icons from the code-drawn Chigüi: Android (adaptive with
// monochrome, plus legacy for Android 7), the web, and the Play Store.
// Run with `make icons`; it overwrites the files in place.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chigui_game/ui/chigui_view.dart';
import 'package:chigui_game/ui/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// `monochrome`: line-art for Android 13+ themed icons, which keep only
/// the alpha channel; dark outlines stay solid and light fills fade.
enum _Backdrop { none, full, rounded, monochrome }

/// Chigüi's face (with the bow tie and a bit of body), centred, so the face
/// spans [span] of the icon.
Widget _icon(double size, {required _Backdrop backdrop, required double span}) {
  // In Chigüi's drawing, ears to bow tie cover about 58% of the canvas
  // height, centred around (0.62, 0.41).
  final portrait = span * size / 0.58;
  final face = Stack(
    clipBehavior: Clip.hardEdge,
    children: [
      if (backdrop != _Backdrop.none)
        const Positioned.fill(child: ColoredBox(color: Palette.mint)),
      Positioned(
        left: size / 2 - 0.62 * portrait,
        top: size / 2 - 0.41 * portrait,
        child: ChiguiPortrait(size: portrait),
      ),
    ],
  );
  return switch (backdrop) {
    _Backdrop.rounded => ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: face,
    ),
    // Drawn over white, then darkness becomes opacity (white -> clear).
    _Backdrop.monochrome => ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0, 0, 0, 0, 255, //
        0, 0, 0, 0, 255,
        0, 0, 0, 0, 255,
        -0.3, -0.59, -0.11, 0, 255,
      ]),
      child: ColoredBox(color: const Color(0xFFFFFFFF), child: face),
    ),
    _ => face,
  };
}

Future<void> _render(
  WidgetTester tester,
  String path,
  int px, {
  required _Backdrop backdrop,
  required double span,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = Size(px.toDouble(), px.toDouble());
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.square(
            dimension: px.toDouble(),
            child: _icon(px.toDouble(), backdrop: backdrop, span: span),
          ),
        ),
      ),
    ),
  );
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  const res = 'android/app/src/main/res';
  const densities = {
    'mdpi': 1.0,
    'hdpi': 1.5,
    'xhdpi': 2.0,
    'xxhdpi': 3.0,
    'xxxhdpi': 4.0,
  };

  testWidgets('Android icons', (tester) async {
    for (final MapEntry(key: density, value: scale) in densities.entries) {
      // Adaptive icon layers (108 dp; the launcher masks them to a shape and
      // only the central 66 dp is always visible).
      for (final (name, backdrop) in [
        ('ic_launcher_foreground', _Backdrop.none),
        ('ic_launcher_monochrome', _Backdrop.monochrome),
      ]) {
        await _render(
          tester,
          '$res/mipmap-$density/$name.png',
          (108 * scale).round(),
          backdrop: backdrop,
          span: 0.5,
        );
      }
      // Legacy icon for Android 7 (48 dp).
      await _render(
        tester,
        '$res/mipmap-$density/ic_launcher.png',
        (48 * scale).round(),
        backdrop: _Backdrop.rounded,
        span: 0.72,
      );
    }
  });

  testWidgets('web and store icons', (tester) async {
    await _render(tester, 'web/favicon.png', 32,
        backdrop: _Backdrop.rounded, span: 0.8);
    for (final px in [192, 512]) {
      await _render(tester, 'web/icons/Icon-$px.png', px,
          backdrop: _Backdrop.rounded, span: 0.72);
      // Maskable: the platform crops to a shape; keep the face in the
      // central 80% safe zone.
      await _render(tester, 'web/icons/Icon-maskable-$px.png', px,
          backdrop: _Backdrop.full, span: 0.56);
    }
    // Google Play listing (512 px, square; Play rounds the corners itself).
    await _render(tester, 'store/play-icon-512.png', 512,
        backdrop: _Backdrop.full, span: 0.68);
  });
}
