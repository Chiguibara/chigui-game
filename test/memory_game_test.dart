import 'dart:math';

import 'package:chigui_game/minigame/memory_game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MemoryGame game() => MemoryGame(pairs: 3, random: Random(1));

  /// The other card with the same fruit as [card].
  int twin(MemoryGame g, int card) => [
    for (var i = 0; i < g.cards.length; i++)
      if (i != card && g.cards[i] == g.cards[card]) i,
  ].single;

  test('deals each fruit exactly twice', () {
    for (final pairs in memoryBoards) {
      final g = MemoryGame(pairs: pairs, random: Random(pairs));
      expect(g.cards, hasLength(pairs * 2));
      expect(g.cards.toSet(), hasLength(pairs));
    }
  });

  test('two equal cards stay face up', () {
    final g = game();
    expect(g.flip(0), Flip.first);
    expect(g.flip(twin(g, 0)), Flip.match);
    expect(g.isMatched(0), isTrue);
    expect(g.pairsFound, 1);
    expect(g.flip(0), Flip.ignored);
  });

  test('two different cards turn back, and nothing is lost', () {
    final g = game();
    final other = [
      for (var i = 1; i < g.cards.length; i++)
        if (g.cards[i] != g.cards[0]) i,
    ].first;
    g.flip(0);
    expect(g.flip(other), Flip.miss);
    expect(g.showingMiss, isTrue);
    expect(g.flip(twin(g, 0)), Flip.ignored, reason: 'wait for the miss');
    g.hideMiss();
    expect(g.isFaceUp(0), isFalse);
    expect(g.isFaceUp(other), isFalse);
    expect(g.pairsFound, 0);
  });

  test('the game is over when every pair is found', () {
    final g = game();
    for (var i = 0; i < g.cards.length; i++) {
      if (g.isFaceUp(i)) continue;
      g.flip(i);
      g.flip(twin(g, i));
    }
    expect(g.over, isTrue);
    expect(g.pairsFound, 3);
  });
}
