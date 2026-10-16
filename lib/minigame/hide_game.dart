import 'dart:math';

// Provisional tuning; adjust after playtests.

/// Turns per round, and boxes Chigüi can hide in.
const hideTurns = 5;
const hideBoxes = 3;

/// Swaps per turn and how long each takes, from the first turn to the last:
/// brisk from the start and harder every turn. Each turn adds up to
/// [hideSwapsJitter] extra swaps and every swap's speed varies by up to
/// [hideSwapTimeJitter], at random, so no two rounds play the same.
const hideSwapsFirst = 3;
const hideSwapsLast = 8;
const hideSwapsJitter = 2;
const hideSwapTimeFirst = Duration(milliseconds: 480);
const hideSwapTimeLast = Duration(milliseconds: 260);
const hideSwapTimeJitter = 0.2; // ± this fraction

/// After this long without finding Chigüi, Chigüi's box trembles very
/// slightly while the player picks: a subtle hint.
const hideHintAfter = Duration(minutes: 5);

/// "Hide and seek": Chigüi hides under one of the boxes, the boxes swap
/// places, and the player taps where Chigüi is. A wrong guess costs nothing:
/// Chigüi just pops out of the right box.
class HideGame {
  HideGame({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Where each box is: [slotOf] box i is at position slotOf[i].
  final slotOf = List<int>.generate(hideBoxes, (i) => i);

  /// The box Chigüi is under.
  int chiguiBox = 0;

  /// This turn's swaps, as pairs of boxes, in order, and how long each takes.
  var swaps = <(int, int)>[];
  var swapTimes = <Duration>[];

  /// Turns played so far.
  int turn = 0;
  int found = 0;

  bool get over => turn >= hideTurns;

  double get _progress => hideTurns > 1 ? turn / (hideTurns - 1) : 0;

  /// This turn's usual time for a swap, before the random variation.
  Duration get swapTime =>
      hideSwapTimeFirst + (hideSwapTimeLast - hideSwapTimeFirst) * _progress;

  /// Chigüi picks a box and the swaps for this turn are planned.
  void startTurn() {
    chiguiBox = _random.nextInt(hideBoxes);
    final count =
        hideSwapsFirst +
        ((hideSwapsLast - hideSwapsFirst) * _progress).round() +
        _random.nextInt(hideSwapsJitter + 1);
    swaps = [
      for (var i = 0; i < count; i++)
        () {
          final a = _random.nextInt(hideBoxes);
          final b = (a + 1 + _random.nextInt(hideBoxes - 1)) % hideBoxes;
          return (a, b);
        }(),
    ];
    swapTimes = [
      for (var i = 0; i < count; i++)
        swapTime *
            (1 -
                hideSwapTimeJitter +
                2 * hideSwapTimeJitter * _random.nextDouble()),
    ];
  }

  /// Boxes [a] and [b] trade places.
  void swap((int, int) boxes) {
    final (a, b) = boxes;
    final slot = slotOf[a];
    slotOf[a] = slotOf[b];
    slotOf[b] = slot;
  }

  /// The player taps [box]; true when Chigüi is there.
  bool guess(int box) {
    turn++;
    final right = box == chiguiBox;
    if (right) found++;
    return right;
  }
}
