import 'dart:math';

import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:chigui_game/minigame/catch_game.dart';
import 'package:chigui_game/minigame/minigame_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('catching fruit plays the chomp', (tester) async {
    final now = DateTime(2026, 10, 12, 12);
    SharedPreferences.setMockInitialValues({});
    final controller = await PetController.load(
      await JsonGameRepository.open(),
      clock: () => now,
    );
    // One fruit a little above Chigüi. A new fruit spawns at the start, so
    // when this one is caught the list of fruit gets shorter, which used to
    // rebuild Chigüi and lose the animation.
    final game = CatchGame(random: Random(1))
      ..fruits.add(Fruit(FruitKind.orange, 0.5, catchLine - 0.1));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MinigameScreen(controller: controller, game: game),
      ),
    );
    await tester.tap(find.text('Start'));
    await tester.pump();
    while (game.caught == 0) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(game.fruits, hasLength(1));

    // The chomp's "Chomp!" pops out a moment after the bite.
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Chomp!'), findsOneWidget);
  });
}
