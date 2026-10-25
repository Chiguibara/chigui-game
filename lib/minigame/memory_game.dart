import 'dart:math';

import 'catch_game.dart' show FruitKind, fruitKinds;

// Provisional tuning; adjust after playtests.

/// Board sizes to choose from, in pairs: small for the youngest, up to all
/// eight fruits. There is no time limit.
const memoryBoards = [3, 6, 8];

/// How long two different cards stay face up before turning back.
const memoryMissShown = Duration(milliseconds: 900);

enum Flip {
  /// The first card of a turn.
  first,
  match,
  miss,

  /// Already face up, or two cards are still showing.
  ignored,
}

/// "Memory": fruit cards face down; turning two equal ones keeps them up.
/// A miss costs nothing, the cards just turn back.
class MemoryGame {
  MemoryGame({required int pairs, Random? random})
    : assert(pairs >= 1 && pairs <= fruitKinds.length),
      cards = _deal(pairs, random ?? Random());

  static List<FruitKind> _deal(int pairs, Random random) {
    final kinds = [...fruitKinds]..shuffle(random);
    return [...kinds.take(pairs), ...kinds.take(pairs)]..shuffle(random);
  }

  final List<FruitKind> cards;
  final _matched = <int>{};
  final _shown = <int>[];
  final _seen = <int>{};

  /// Misses that memory could have avoided: the first card's twin had
  /// already been seen. Pure bad luck does not count.
  int slips = 0;

  int get pairs => cards.length ~/ 2;
  int get pairsFound => _matched.length ~/ 2;
  bool get over => _matched.length == cards.length;

  /// Two different cards are face up, waiting for [hideMiss].
  bool get showingMiss => _shown.length == 2;

  bool isFaceUp(int card) => _matched.contains(card) || _shown.contains(card);
  bool isMatched(int card) => _matched.contains(card);

  Flip flip(int card) {
    if (showingMiss || isFaceUp(card)) return Flip.ignored;
    _shown.add(card);
    if (_shown.length == 1) {
      _seen.add(card);
      return Flip.first;
    }
    final first = _shown[0];
    final twinSeen = _seen.any((c) => c != first && cards[c] == cards[first]);
    _seen.add(card);
    if (cards[first] == cards[card]) {
      _matched.addAll(_shown);
      _shown.clear();
      return Flip.match;
    }
    if (twinSeen) slips++;
    return Flip.miss;
  }

  /// Turns the two different cards back face down.
  void hideMiss() {
    if (showingMiss) _shown.clear();
  }
}
