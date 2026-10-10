import 'package:chigui_game/app.dart';
import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/catalog.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/rules.dart' show stepsPerFootTap;
import 'package:chigui_game/sound/sound_effects.dart';
import 'package:chigui_game/store/pack_store.dart';
import 'package:chigui_game/store/packs_controller.dart';
import 'package:chigui_game/ui/action_tile.dart';
import 'package:chigui_game/ui/chigui_view.dart';
import 'package:chigui_game/ui/home_screen.dart';
import 'package:chigui_game/walk/pedometer.dart';
import 'package:chigui_game/walk/step_watcher.dart';
import 'package:chigui_game/ui/poop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_motion.dart';
import 'fake_pack_store.dart';

void main() {
  // Monday noon: no routine moment is active.
  final noon = DateTime(2026, 10, 12, 12);

  Future<PetController> controllerWith(
    PetState Function(PetState fresh) setUp, {
    DateTime? now,
  }) async {
    final time = now ?? noon;
    SharedPreferences.setMockInitialValues({});
    final repo = await JsonGameRepository.open();
    await repo.saveState(
      setUp(
        PetState(
          needs: {for (final n in Need.values) n: 0.8},
          updatedAt: time,
          seed: 42,
        ),
      ),
    );
    return PetController.load(repo, clock: () => time);
  }

  Future<PetController> start(
    WidgetTester tester,
    PetState Function(PetState) setUp, {
    DateTime? now,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    addTearDown(tester.view.reset);
    final controller = await controllerWith(setUp, now: now);
    await tester.pumpWidget(ChiguiApp(controller: controller));
    return controller;
  }

  PetState same(PetState s) => s;

  ActionTile actionTile(WidgetTester tester, String label) =>
      tester.widget<ActionTile>(
        find.ancestor(of: find.text(label), matching: find.byType(ActionTile)),
      );

  Finder chigui() => find.descendant(
    of: find.byType(ChiguiView),
    matching: find.bySemanticsLabel('Chigüi'),
  );

  Future<void> finishReaction(WidgetTester tester) =>
      tester.pump(const Duration(milliseconds: 1300));

  testWidgets('shows Chigüi with the English prompt', (tester) async {
    await start(tester, same);
    expect(find.byType(ChiguiView), findsOneWidget);
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('petting makes Chigüi happy and raises affection', (
    tester,
  ) async {
    final controller = await start(tester, same);

    await tester.tap(chigui());
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
    expect(controller.state.level(Need.affection), closeTo(0.9, 1e-9));

    await finishReaction(tester);
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('petting with low affection invites more cuddles', (
    tester,
  ) async {
    await start(
      tester,
      (s) => s.copyWith(needs: {...s.needs, Need.affection: 0.2}),
    );
    await tester.tap(chigui());
    await tester.pump();
    expect(
      find.text('Chigüi liked that! More cuddles, please?'),
      findsOneWidget,
    );
    await finishReaction(tester);

    for (var i = 0; i < 3; i++) {
      await tester.tap(chigui());
      await tester.pump();
    }
    expect(find.text('That feels nice! A little more?'), findsOneWidget);
    await finishReaction(tester);
  });

  testWidgets('a hungry Chigüi says so, and feeding helps', (tester) async {
    final controller = await start(
      tester,
      (s) => s.copyWith(needs: {...s.needs, Need.food: 0.3}),
    );
    expect(find.text('Chigüi could go for a snack'), findsOneWidget);

    await tester.tap(find.text('Feed'));
    await tester.pump();
    expect(find.text('Yum! Thank you!'), findsOneWidget);
    expect(controller.state.level(Need.food), closeTo(0.6, 1e-9));
    // The same big chomp as in the minigame, with its "Chomp!".
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Chomp!'), findsOneWidget);
    // The thank-you stays a moment after the quick chomp.
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Yum! Thank you!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Yum! Thank you!'), findsNothing);
  });

  testWidgets('a full Chigüi politely refuses a snack', (tester) async {
    await start(tester, (s) => s.copyWith(needs: {...s.needs, Need.food: 1}));

    await tester.tap(find.text('Feed'));
    await tester.pump();
    expect(find.text('Chigüi has had enough for now'), findsOneWidget);
    await finishReaction(tester);
  });

  testWidgets('the toilet button appears only when needed', (tester) async {
    final controller = await start(
      tester,
      (s) => s.copyWith(pottyUrgeSince: noon),
    );
    expect(find.text('Chigüi needs the toilet!'), findsOneWidget);

    await tester.tap(find.text('Toilet'));
    await tester.pump();
    expect(find.text('Phew, much better!'), findsOneWidget);
    expect(controller.state.needsPotty, isFalse);
    expect(find.text('Toilet'), findsNothing);
    await finishReaction(tester);
  });

  testWidgets('tapping a mess cleans it up', (tester) async {
    final controller = await start(tester, (s) => s.copyWith(messes: 1));
    expect(find.text('Something smells… time to clean up!'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('clean up'));
    await tester.pump();
    expect(controller.state.messes, 0);
    expect(find.text('All clean!'), findsOneWidget);
    await finishReaction(tester);
    expect(find.byType(Poop), findsNothing);
  });

  testWidgets('a sick Chigüi gets better at the vet', (tester) async {
    final controller = await start(tester, (s) => s.copyWith(sick: true));
    expect(
      find.text("Chigüi doesn't feel well. Time for the vet!"),
      findsOneWidget,
    );

    await tester.tap(find.text('Vet'));
    await tester.pump();
    expect(find.text('All better! So brave!'), findsOneWidget);
    expect(controller.state.sick, isFalse);
    await finishReaction(tester);
    expect(find.text('Vet'), findsNothing);
  });

  testWidgets('at bedtime Chigüi can be sent to bed', (tester) async {
    final controller = await start(
      tester,
      same,
      now: DateTime(2026, 10, 12, 21, 5),
    );
    expect(find.text('Chigüi is sleepy'), findsOneWidget);

    await tester.tap(find.text('Bedtime'));
    await tester.pump();
    expect(controller.asleep, isTrue);
    expect(find.text('Shh… Chigüi is sleeping'), findsOneWidget);
    expect(actionTile(tester, 'Feed').onPressed, isNull);
  });

  testWidgets('a grumpy Chigüi is won over with a cuddle', (tester) async {
    final controller = await start(tester, (s) => s.copyWith(grumpy: true));
    expect(find.textContaining('grumpy'), findsOneWidget);

    await tester.tap(chigui());
    await tester.pump();
    expect(controller.state.grumpy, isFalse);
    await finishReaction(tester);
  });

  testWidgets('a minigame round raises fun and goes back home', (tester) async {
    final controller = await start(
      tester,
      (s) => s.copyWith(needs: {...s.needs, Need.fun: 0.4}),
    );

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.text('Fruit catch'), findsOneWidget);

    await tester.tap(find.text('Start'));
    for (var i = 0; i < 31 * 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Great game!'), findsOneWidget);
    expect(controller.state.level(Need.fun), closeTo(0.7, 1e-9));

    await tester.tap(find.text('Back home'));
    // Chigüi keeps breathing, so the screen never fully settles.
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Feed'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp(r'^\d+ coins?$')), findsOneWidget);
  });

  testWidgets('a sleeping Chigüi cannot play or walk', (tester) async {
    await start(
      tester,
      (s) => s.copyWith(asleepUntil: DateTime(2026, 10, 12, 13)),
    );
    expect(actionTile(tester, 'Play').onPressed, isNull);
    expect(actionTile(tester, 'Walk').onPressed, isNull);
  });

  testWidgets('the dev panel simulates steps, and Chigüi walks', (
    tester,
  ) async {
    final controller = await start(tester, same);

    await tester.tap(find.text('+1000 steps'));
    await tester.pump();
    expect(find.text('What a lovely walk!'), findsOneWidget);
    expect(controller.stepsToday, 1000);
    expect(controller.state.coins, 5);
    expect(find.bySemanticsLabel('1000 steps today'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('the shop sells, dresses up, and jokes about seasons', (
    tester,
  ) async {
    final controller = await start(tester, (s) => s.copyWith(coins: 30));
    // A tall screen so every shop item is laid out.
    tester.view.physicalSize = const Size(1080, 4000);
    await tester.pump();

    await tester.tap(find.text('Shop'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text("Chigüi's shop"), findsOneWidget);

    // 12 October: Spooktober items are on sale, Christmas ones are not.
    expect(find.text('Spooktober'), findsWidgets);
    await tester.tap(find.text('Santa hat'));
    await tester.pump();
    expect(find.textContaining('compiling the presents'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Headphones'));
    await tester.pump();
    expect(find.textContaining('Error 402: 5 coins missing'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Geek glasses'));
    await tester.pump();
    expect(find.text('New look unlocked!'), findsOneWidget);
    expect(controller.state.coins, 5);
    expect(controller.state.equipped, {Slot.face: 'geekGlasses'});
    expect(find.text('Take off'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Geek glasses'));
    await tester.pump(const Duration(seconds: 2));
    expect(controller.state.equipped, isEmpty);
    expect(find.text('Wear'), findsOneWidget);
  });

  group('wide screens (PC)', () {
    Future<PetController> startWide(WidgetTester tester) async {
      final controller = await start(
        tester,
        (s) => s.copyWith(coins: 50, pottyUrgeSince: noon, messes: 2),
      );
      tester.view.physicalSize = const Size(1280 * 3, 720 * 3);
      tester.view.devicePixelRatio = 3;
      await tester.pump();
      return controller;
    }

    testWidgets('home puts Chigüi beside the controls', (tester) async {
      await startWide(tester);
      final chiguiBox = tester.getRect(find.byType(ChiguiView));
      final feed = tester.getRect(find.text('Feed'));
      expect(feed.left, greaterThan(chiguiBox.right));
      await tester.tap(find.text('Toilet'));
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('the shop and the minigame fit', (tester) async {
      await startWide(tester);
      await tester.tap(find.text('Shop'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text("Chigüi's shop"), findsOneWidget);
      await tester.tap(find.byTooltip('Back home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Play'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.text('Start'));
      for (var i = 0; i < 31 * 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('Great game!'), findsOneWidget);
    });
  });

  group('sounds', () {
    late List<Sfx> played;

    setUp(() {
      played = [];
      sfx = SoundEffects(player: (s, _) => played.add(s));
    });
    tearDown(() => sfx = SoundEffects());

    testWidgets('actions make their sounds', (tester) async {
      await start(tester, same);
      await tester.tap(chigui());
      await tester.pump();
      await tester.tap(find.text('Feed'));
      await tester.pump(const Duration(seconds: 2));
      expect(played, [Sfx.pet, Sfx.chomp]);
    });

    testWidgets('an "uh-oh" when Chigüi needs the toilet', (tester) async {
      final controller = await start(tester, same);
      // Skip to just past the first potty urge of the day.
      for (var i = 0; i < 4 * 12 && !controller.state.needsPotty; i++) {
        await tester.tap(find.text('+15m'));
        await tester.pump();
      }
      expect(controller.state.needsPotty, isTrue);
      expect(played, contains(Sfx.uhOh));
    });

    testWidgets('a sleeping Chigüi snores softly, but not under the shop', (
      tester,
    ) async {
      final controller = await start(
        tester,
        (s) => s.copyWith(asleepUntil: noon.add(const Duration(hours: 1))),
      );
      await tester.pump(HomeScreen.snoreEvery);
      await tester.pump(HomeScreen.snoreEvery);
      expect(played.where((s) => s == Sfx.snore), hasLength(2));

      // Not while the shop covers the home screen.
      played.clear();
      await tester.tap(find.text('Shop'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(HomeScreen.snoreEvery);
      expect(played, isNot(contains(Sfx.snore)));
      expect(controller.asleep, isTrue);
    });

    testWidgets('an awake Chigüi does not snore', (tester) async {
      await start(tester, same);
      await tester.pump(HomeScreen.snoreEvery * 3);
      expect(played, isNot(contains(Sfx.snore)));
    });

    testWidgets('muting silences everything and is remembered', (tester) async {
      final prefs = await SharedPreferences.getInstance();
      sfx = SoundEffects(player: (s, _) => played.add(s), prefs: prefs);
      await start(tester, same);

      await tester.tap(find.byTooltip('Mute sounds'));
      await tester.pump();
      await tester.tap(chigui());
      await tester.pump(const Duration(seconds: 2));
      expect(played, isEmpty);
      expect(prefs.getBool(SoundEffects.mutedKey), isTrue);
      expect(SoundEffects(prefs: prefs).muted, isTrue);
      expect(find.byTooltip('Turn sounds on'), findsOneWidget);
    });
  });

  group('packs', () {
    testWidgets('no packs where they are not sold', (tester) async {
      await start(tester, same);
      tester.view.physicalSize = const Size(1080, 4000);
      await tester.pump();
      await tester.tap(find.text('Shop'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Packs'), findsNothing);
      expect(find.text('Wizard hat'), findsNothing);
    });

    testWidgets('buying a pack: confirm, wait for a grown-up, wear it', (
      tester,
    ) async {
      final store = FakePackStore();
      tester.view.physicalSize = const Size(1080, 5000);
      addTearDown(tester.view.reset);
      final controller = await controllerWith(same);
      final packs = PacksController(store, controller);
      await packs.start();
      await tester.pumpWidget(ChiguiApp(controller: controller, packs: packs));

      await tester.tap(find.text('Shop'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Geek pack'), findsOneWidget);

      await tester.tap(find.text('0,99 €').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('This costs real money'), findsOneWidget);
      await tester.tap(find.text('Continue to payment'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(store.bought, ['pack_geek']);

      store.report('pack_geek', PackStatus.pending);
      await tester.pump();
      expect(find.text('Waiting for a grown-up to approve…'), findsOneWidget);

      store.report('pack_geek', PackStatus.purchased);
      await tester.pump();
      expect(
        find.text('New pack unlocked! Look in Accessories.'),
        findsOneWidget,
      );
      expect(find.text('Yours!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));

      // The shop is long; scroll to the new item in Accessories.
      await tester.scrollUntilVisible(
        find.text('Wizard hat'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Wizard hat'));
      await tester.pump(const Duration(seconds: 2));
      expect(controller.state.equipped[Slot.head], 'wizardHat');
    });
  });

  group('walking for real opens the walk', () {
    Future<(PetController, FakeMotion)> startWalker(
      WidgetTester tester, {
      PetState Function(PetState)? setUp,
    }) async {
      final motion = FakeMotion();
      final steps = StepWatcher(motion);
      await steps.start();
      tester.view.physicalSize = const Size(1080, 2340);
      addTearDown(tester.view.reset);
      final controller = await controllerWith(setUp ?? same);
      await tester.pumpWidget(ChiguiApp(controller: controller, steps: steps));
      return (controller, motion);
    }

    Future<void> walk(WidgetTester tester, FakeMotion motion, int steps) async {
      for (var i = 0; i < steps; i++) {
        motion.walk(1);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('after about 10 m, without pressing anything', (tester) async {
      final (controller, motion) = await startWalker(tester);
      await walk(tester, motion, 8);
      expect(
        find.text('Walk with the phone in your hand, or tap the feet!'),
        findsNothing,
      );

      await walk(tester, motion, 12);
      expect(
        find.text('Walk with the phone in your hand, or tap the feet!'),
        findsOneWidget,
      );

      // Leaving keeps the steps, and it does not reopen right away.
      await tester.tap(find.byTooltip('Back home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(controller.stepsToday, greaterThanOrEqualTo(walkStartSteps));
      await walk(tester, motion, 20);
      expect(find.text('Walk with Chigüi'), findsNothing);
    });

    testWidgets('Android pedometer: about 100 m opens the walk', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2340);
      addTearDown(tester.view.reset);
      final controller = await controllerWith(same);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(Pedometer.lastTotalKey, 5000);
      final pedometer = Pedometer(controller, prefs);
      await tester.pumpWidget(
        ChiguiApp(controller: controller, pedometer: pedometer),
      );
      pedometer.onTotal(5000); // Catching up: nothing new.
      var total = 5000;
      Future<void> walkBatch(int steps) async {
        pedometer.onTotal(total += steps);
        await tester.pump(const Duration(milliseconds: 16));
      }

      for (var i = 0; i < 7; i++) {
        await walkBatch(20);
      }
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Walk with Chigüi'), findsNothing);

      await walkBatch(30);
      await tester.pump(const Duration(seconds: 1));
      expect(
        find.text(
          'Walk for real (even with the phone in your pocket), or tap the feet!',
        ),
        findsOneWidget,
      );
      expect(controller.stepsToday, 170, reason: 'counted once, not twice');

      // Sitting still: the feet still work alongside the pedometer.
      await tester.tap(find.bySemanticsLabel('left foot'));
      await tester.pump();
      expect(controller.stepsToday, 170 + stepsPerFootTap);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('not while Chigüi sleeps', (tester) async {
      final (_, motion) = await startWalker(
        tester,
        setUp: (s) =>
            s.copyWith(asleepUntil: noon.add(const Duration(hours: 1))),
      );
      await walk(tester, motion, 20);
      expect(find.text('Walk with Chigüi'), findsNothing);
    });
  });

  testWidgets('the dev panel skips time', (tester) async {
    final controller = await start(tester, same);
    final before = controller.now;

    await tester.tap(find.text('+1h'));
    await tester.pump();
    expect(controller.now.difference(before), const Duration(hours: 1));
  });

  testWidgets('uses Spanish when the device language is Spanish', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await start(tester, same);

    expect(find.text('Toca a Chigüi para saludar'), findsOneWidget);
    expect(find.text('Dar de comer'), findsOneWidget);
  });

  testWidgets('works with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await start(tester, same);

    await tester.tap(chigui());
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
    await finishReaction(tester);
  });
}
