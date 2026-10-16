import 'dart:math';

import 'package:chigui_game/game/rules.dart';
import 'package:chigui_game/minigame/bath_game.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cleans [game]'s spots the right way, tool by tool, tapping each spot.
void wash(BathGame game) {
  while (game.stage == BathStage.wash) {
    final spot = game.spots.firstWhere((s) => s.needs != null);
    game.use(spot.needs!, spot.x, spot.y);
  }
}

void main() {
  test('the first bath has a few spots; later ones more and grittier', () {
    final first = BathGame(random: Random(1));
    expect(first.spots, hasLength(bathSpotsFirst));
    final later = BathGame(bath: 10, random: Random(1));
    expect(later.spots, hasLength(bathSpotsMost));
    for (final spot in later.spots) {
      expect(spot.y + spot.size, lessThan(0.8), reason: 'above the water');
    }
  });

  test('every bath puts the spots somewhere else', () {
    final a = BathGame(random: Random(1)).spots.map((s) => (s.x, s.y));
    final b = BathGame(random: Random(2)).spots.map((s) => (s.x, s.y));
    expect(a, isNot(equals(b)));
  });

  test('a spot needs soap, brushing, and rinsing, in that order', () {
    final game = BathGame(random: Random(3))..hopIn();
    final spot = game.spots.firstWhere((s) => s.state == SpotState.tar);
    expect(game.use(BathTool.ladle, spot.x, spot.y), isNot(BathUse.step));
    expect(spot.state, SpotState.tar);
    expect(game.use(BathTool.soap, spot.x, spot.y), BathUse.step);
    expect(spot.state, SpotState.lathered);
    // Brushing takes a few rubs.
    expect(game.use(BathTool.brush, spot.x, spot.y), BathUse.rubbing);
    while (spot.state == SpotState.lathered) {
      game.use(BathTool.brush, spot.x, spot.y, rub: 0.1);
    }
    expect(spot.state, SpotState.foam);
    game.use(BathTool.ladle, spot.x, spot.y);
    expect(spot.state, SpotState.clean);
  });

  test('gravel is brushed off before the soap', () {
    final game = BathGame(bath: 10, random: Random(4))..hopIn();
    final spot = game.spots.firstWhere((s) => s.state == SpotState.gravel);
    expect(spot.needs, BathTool.brush);
    while (spot.state == SpotState.gravel) {
      game.use(BathTool.brush, spot.x, spot.y);
    }
    expect(spot.needs, BathTool.soap);
  });

  test('a wrong tool or a miss costs nothing', () {
    final game = BathGame(random: Random(5))..hopIn();
    final states = [for (final s in game.spots) s.state];
    expect(game.use(BathTool.towel, 0.5, 0.5), BathUse.wrong);
    expect(game.use(BathTool.yuzu, 0.5, 0.5), BathUse.wrong);
    expect(game.use(BathTool.soap, 0.02, 0.02), BathUse.missed);
    expect([for (final s in game.spots) s.state], states);
  });

  test('washed, three yuzus, a soak, then the towel', () {
    final game = BathGame(random: Random(6));
    expect(game.use(BathTool.soap, 0.5, 0.5), BathUse.wrong);
    game.hopIn();
    expect(game.needed, isNotNull);
    wash(game);
    expect(game.stage, BathStage.yuzu);
    expect(game.dirt, 0);
    for (var i = 0; i < bathYuzus; i++) {
      expect(game.use(BathTool.yuzu, 0.5, 0.5), BathUse.yuzu);
    }
    expect(game.stage, BathStage.soak);
    game.hopOut();
    expect(game.needed, BathTool.towel);
    var result = BathUse.rubbing;
    while (result == BathUse.rubbing) {
      result = game.use(BathTool.towel, 0.5, 0.5, rub: 0.1);
    }
    expect(result, BathUse.dried);
    expect(game.stage, BathStage.done);
  });

  test('a bath pays a little: one coin per two spots, rounded up', () {
    expect(coinsForSpots(4), 2);
    expect(coinsForSpots(5), 3);
    expect(coinsForSpots(7), 4);
  });
}
