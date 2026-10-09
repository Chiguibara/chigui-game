import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/rules.dart';
import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:chigui_game/walk/motion_source.dart';
import 'package:chigui_game/walk/walk_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A pretend phone sensor the test can shake.
class FakeMotion implements MotionSource {
  MotionListener? listener;
  bool stopped = false;

  @override
  Future<bool> start(MotionListener onSample) async {
    listener = onSample;
    return true;
  }

  @override
  void stop() => stopped = true;
}

void main() {
  final now = DateTime(2026, 10, 12, 12);

  Future<PetController> open(
    WidgetTester tester, {
    MotionSource? motion,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final controller = await PetController.load(
      await JsonGameRepository.open(),
      clock: () => now,
    );
    tester.view.physicalSize = const Size(1080, 2340);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WalkScreen(controller: controller, motion: motion),
      ),
    );
    await tester.tap(find.text("Let's go!"));
    await tester.pump();
    return controller;
  }

  testWidgets('without a sensor, tapping the feet in turn walks', (
    tester,
  ) async {
    final controller = await open(tester, motion: FakeMotion());
    // The fake never sends samples, like a PC: after a moment, feet appear.
    await tester.pump(WalkScreen.sensorTimeout);
    await tester.pump();
    expect(find.text('Left, right, left, right…'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('left foot'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('left foot'));
    await tester.pump();
    expect(find.text('The other foot!'), findsOneWidget);
    expect(controller.stepsToday, stepsPerFootTap);

    final taps = stepsPerWalk ~/ stepsPerFootTap;
    for (var i = 1; i < taps; i++) {
      await tester.tap(
        find.bySemanticsLabel(i.isOdd ? 'right foot' : 'left foot'),
      );
      await tester.pump();
    }
    expect(controller.walksToday, 1);
    expect(controller.state.coins, coinsPerWalk);
    expect(find.text('What a lovely walk!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('with a sensor, real steps are counted', (tester) async {
    final motion = FakeMotion();
    final controller = await open(tester, motion: motion);

    // Two steps per second for 10 seconds.
    for (var i = 0; i < 600; i++) {
      final t = i / 60;
      motion.listener!(t, 9.81 + 3 * (i % 30 < 15 ? 1 : -1));
      if (i % 60 == 0) await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pump();
    expect(
      find.text('Walking for real! Keep the phone in your hand.'),
      findsOneWidget,
    );

    // Steps are saved in batches, and the rest when leaving.
    await tester.tap(find.byTooltip('Back home'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(controller.stepsToday, inInclusiveRange(15, 21));
    expect(motion.stopped, isTrue);
  });
}
