// Renders the Google Play phone screenshots from the real app (home, the
// minigame, a walk and the shop) with a sample save, in Spanish. Play wants
// 9:16, so the phone-shaped screen (9:19.5, 360 dp wide) is drawn 1920 px
// tall and centred on a 1080 x 1920 mint image. Run with `make screenshots`;
// it overwrites store/screenshots/.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chigui_game/app.dart';
import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/catalog.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/rules.dart' show stepsPerFootTap, stepsPerWalk;
import 'package:chigui_game/ui/dev_panel.dart';
import 'package:chigui_game/ui/game_frame.dart';
import 'package:chigui_game/ui/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tests draw text with a placeholder font: load the app's and the icons'.
Future<void> _loadFonts() async {
  final roboto = FontLoader('Roboto');
  for (final weight in ['Regular', 'Medium', 'Bold']) {
    roboto.addFont(
      rootBundle.load('assets/fonts/Roboto-$weight.ttf'),
    );
  }
  await roboto.load();
  final sdk =
      Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  final icons = File(
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  await (FontLoader('MaterialIcons')..addFont(
        Future.value(ByteData.sublistView(icons.readAsBytesSync())),
      ))
      .load();
}

const _width = 1080.0;
const _height = 1920.0;

void main() {
  // Monday 16:00: after school, before the evening routine.
  final now = DateTime(2026, 10, 12, 16);

  late GlobalKey screen;

  Future<void> start(WidgetTester tester) async {
    screen = GlobalKey();
    // 640 dp tall makes the phone frame 360 dp wide, a usual phone width.
    tester.view.physicalSize = const Size(_width, _height);
    tester.view.devicePixelRatio = _height / (360 / GameFrame.phoneAspectRatio);
    addTearDown(tester.view.reset);
    // A test after all, but outside test/, where the analyzer looks.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    final repo = await JsonGameRepository.open();
    await repo.saveState(
      PetState(
        needs: {for (final n in Need.values) n: 0.8},
        updatedAt: now,
        seed: 42,
        coins: 85,
        owned: const {'headphones', 'geekGlasses', 'scarf'},
        equipped: const {Slot.head: 'headphones', Slot.face: 'geekGlasses'},
      ),
    );
    final controller = await PetController.load(repo, clock: () => now);
    await tester.pumpWidget(
      RepaintBoundary(
        key: screen,
        child: ChiguiApp(controller: controller, locale: const Locale('es')),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> shoot(WidgetTester tester, String name) async {
    await tester.runAsync(() async {
      final boundary =
          screen.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(
        pixelRatio: tester.view.devicePixelRatio,
      );
      // The frame's dark sides become mint, the game's own background.
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder)..drawColor(Palette.mint, BlendMode.src);
      final phone = _height * GameFrame.phoneAspectRatio;
      // One pixel in from each edge, where the dark sides blend in.
      final side = Rect.fromLTWH(
        (_width - phone) / 2 + 1,
        0,
        phone - 2,
        _height,
      );
      canvas.drawImageRect(image, side, side, Paint());
      final framed = await recorder.endRecording().toImage(
        _width.toInt(),
        _height.toInt(),
      );
      final png = await framed.toByteData(format: ui.ImageByteFormat.png);
      File('store/screenshots/$name.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  Future<void> open(WidgetTester tester, String button) async {
    await tester.tap(find.text(button));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  setUpAll(() async {
    DevPanel.enabled = false;
    await _loadFonts();
  });

  testWidgets('home', (tester) async {
    await start(tester);
    await shoot(tester, '1-casa');
  });

  testWidgets('minigame', (tester) async {
    await start(tester);
    await open(tester, 'Jugar');
    await tester.tap(find.text('¡A jugar!'));
    await tester.pump();
    // Let the fruit fall for a while.
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await shoot(tester, '2-atrapa-la-fruta');
  });

  testWidgets('walk', (tester) async {
    await start(tester);
    await open(tester, 'Pasear');
    await tester.tap(find.text('¡Vamos!'));
    await tester.pump(const Duration(seconds: 1));
    // Halfway through a walk, tapping the feet in turn.
    for (var i = 0; i < stepsPerWalk ~/ stepsPerFootTap ~/ 2; i++) {
      await tester.tap(
        find.bySemanticsLabel(i.isEven ? 'pie izquierdo' : 'pie derecho'),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump(const Duration(seconds: 1));
    await shoot(tester, '3-paseo');
  });

  testWidgets('shop', (tester) async {
    await start(tester);
    await open(tester, 'Tienda');
    await shoot(tester, '4-tienda');
  });
}
