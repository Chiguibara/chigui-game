import 'dart:math';

import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:chigui_game/minigame/games_screen.dart';
import 'package:chigui_game/minigame/hide_game.dart';
import 'package:chigui_game/minigame/hide_screen.dart';
import 'package:chigui_game/minigame/memory_game.dart';
import 'package:chigui_game/minigame/memory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<PetController> controller() async {
    SharedPreferences.setMockInitialValues({});
    return PetController.load(
      await JsonGameRepository.open(),
      clock: () => DateTime(2026, 10, 12, 16),
    );
  }

  Future<void> show(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(1080, 2340);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    );
  }

  /// Pumps frames for [duration], as a screen would, so chained animations
  /// run on time.
  Future<void> frames(WidgetTester tester, Duration duration) async {
    const frame = Duration(milliseconds: 50);
    for (var t = Duration.zero; t < duration; t += frame) {
      await tester.pump(frame);
    }
  }

  testWidgets('the game list opens each game', (tester) async {
    await show(tester, GamesScreen(controller: await controller()));
    for (final (game, hint) in [
      ('Fruit memory', 'Turn over two cards'),
      ('Hide and seek', 'Chigüi hides under a box'),
      ('Fruit catch', 'Drag to move Chigüi'),
    ]) {
      await tester.tap(find.text(game));
      await tester.pumpAndSettle();
      expect(find.textContaining(hint), findsOneWidget);
      await tester.tap(find.text('Other games'));
      await tester.pumpAndSettle();
    }
    expect(find.text('What shall we play?'), findsOneWidget);
  });

  testWidgets('memory: finding every pair pays a coin each', (tester) async {
    final pet = await controller();
    await show(tester, MemoryScreen(controller: pet, random: Random(5)));
    final cards = MemoryGame(pairs: 3, random: Random(5)).cards;

    await tester.tap(find.text('6 cards'));
    await tester.pump();

    // A miss first: the cards turn back and nothing is lost.
    final miss = [
      for (var i = 1; i < 6; i++)
        if (cards[i] != cards[0]) i,
    ];
    await tester.tap(find.byKey(const ValueKey('card-0')));
    await tester.tap(find.byKey(ValueKey('card-${miss.first}')));
    await tester.pump(memoryMissShown + const Duration(milliseconds: 300));

    final done = <int>{};
    for (var i = 0; i < 6; i++) {
      if (done.contains(i)) continue;
      final j = [
        for (var k = i + 1; k < 6; k++)
          if (cards[k] == cards[i]) k,
      ];
      done.addAll([i, j.single]);
      await tester.tap(find.byKey(ValueKey('card-$i')));
      await tester.tap(find.byKey(ValueKey('card-${j.single}')));
      await tester.pump(const Duration(milliseconds: 300));
    }
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Great game!'), findsOneWidget);
    expect(find.text('3 pairs found'), findsOneWidget);
    expect(pet.state.coins, 3);
    expect(pet.state.level(Need.fun), greaterThan(PetState.initialLevel));
  });

  testWidgets('hide and seek: five turns, two coins per find', (
    tester,
  ) async {
    final pet = await controller();
    await show(tester, HideScreen(controller: pet, random: Random(7)));
    // The same random choices as the screen's game.
    final game = HideGame(random: Random(7));

    await tester.tap(find.text('Start'));
    for (var turn = 0; turn < hideTurns; turn++) {
      game.startTurn();
      game.swaps.forEach(game.swap);
      while (find.text('Where is Chigüi?').evaluate().isEmpty) {
        await frames(tester, const Duration(milliseconds: 100));
      }
      // Right on even turns, wrong on odd ones.
      final box = turn.isEven
          ? game.chiguiBox
          : (game.chiguiBox + 1) % hideBoxes;
      await tester.tap(find.byKey(ValueKey('box-$box')));
      await frames(tester, const Duration(milliseconds: 900));
      expect(
        find.text(turn.isEven ? 'You found me!' : 'Peekaboo! I was over here!'),
        findsOneWidget,
      );
      game.guess(box);
      await frames(tester, const Duration(seconds: 2));
    }
    expect(find.text('Great game!'), findsOneWidget);
    expect(find.text('You found Chigüi 3 times'), findsOneWidget);
    expect(pet.state.coins, 6);
  });
}
