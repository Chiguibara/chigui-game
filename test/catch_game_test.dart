import 'dart:math';

import 'package:chigui_game/minigame/catch_game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a round lasts 30 seconds', () {
    final game = CatchGame(random: Random(1));
    game.update(29.9);
    expect(game.over, isFalse);
    game.update(0.2);
    expect(game.over, isTrue);
    expect(game.timeLeft, 0);
  });

  test('fruit keeps falling in', () {
    final game = CatchGame(random: Random(1));
    game.update(2);
    expect(game.fruits, isNotEmpty);
  });

  test('Chigüi catches fruit that falls on them', () {
    final game = CatchGame(random: Random(1));
    game.fruits.add(Fruit(FruitKind.orange, 0.5, catchLine - 0.01));
    expect(game.update(0.1), 1);
    expect(game.caught, 1);
  });

  test('fruit that falls far away is simply missed', () {
    final game = CatchGame(random: Random(1));
    game.fruits.add(Fruit(FruitKind.orange, 0.9, catchLine - 0.01));
    expect(game.update(0.1), 0);
    expect(game.caught, 0);
  });

  test('Chigüi moves towards the finger at a limited speed', () {
    final game = CatchGame(random: Random(1))..aimAt(1);
    expect(game.targetX, 0.92);
    game.update(0.1);
    expect(game.chiguiX, closeTo(0.5 + chiguiSpeed * 0.1, 1e-9));
    game.update(1);
    expect(game.chiguiX, 0.92);
  });

  test('a big time step cannot skip past Chigüi', () {
    final game = CatchGame(random: Random(1));
    game.fruits.add(Fruit(FruitKind.watermelon, 0.5, catchLine - 0.2));
    game.update(3);
    expect(game.caught, greaterThanOrEqualTo(1));
  });

  test('an attentive player catches most of the fruit', () {
    final game = CatchGame(random: Random(3));
    var spawned = 0;
    while (!game.over) {
      final before = game.fruits.length;
      game.update(1 / 60);
      if (game.fruits.length > before) spawned++;
      final next = game.fruits
          .where((f) => f.y < catchLine)
          .fold<Fruit?>(null, (a, f) => a == null || f.y > a.y ? f : a);
      if (next != null) game.aimAt(next.x);
    }
    expect(game.caught, greaterThan(spawned * 0.6));
  });
}
