import 'dart:math';

import 'package:chigui_game/minigame/hide_game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('swaps move boxes, never a box with itself', () {
    final g = HideGame(random: Random(1))..startTurn();
    for (final swap in g.swaps) {
      final (a, b) = swap;
      expect(a, isNot(b));
      final slots = [...g.slotOf];
      g.swap(swap);
      expect(g.slotOf[a], slots[b]);
      expect(g.slotOf[b], slots[a]);
    }
    expect(g.slotOf.toSet(), {0, 1, 2});
  });

  test('later turns have more and quicker swaps, varying at random', () {
    final g = HideGame(random: Random(2))..startTurn();
    final first = (g.swaps.length, g.swapTime);
    expect(first.$1, inInclusiveRange(hideSwapsFirst, hideSwapsFirst + 2));
    while (g.turn < hideTurns - 1) {
      g.guess(0);
    }
    g.startTurn();
    expect(g.swaps.length, inInclusiveRange(hideSwapsLast, hideSwapsLast + 2));
    expect(g.swapTime, lessThan(first.$2));
    expect(g.swapTimes, hasLength(g.swaps.length));
    for (final time in g.swapTimes) {
      expect(time, greaterThanOrEqualTo(g.swapTime * 0.8));
      expect(time, lessThanOrEqualTo(g.swapTime * 1.2));
    }
    expect(g.swapTimes.toSet().length, greaterThan(1));
  });

  test('guessing counts finds, and a wrong guess costs nothing', () {
    final g = HideGame(random: Random(3))..startTurn();
    expect(g.guess(g.chiguiBox), isTrue);
    g.startTurn();
    expect(g.guess((g.chiguiBox + 1) % hideBoxes), isFalse);
    expect(g.found, 1);
    expect(g.turn, 2);
    expect(g.over, isFalse);
  });
}
