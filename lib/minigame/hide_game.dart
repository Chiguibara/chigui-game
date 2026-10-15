import 'dart:math';

// Provisional tuning; adjust after playtests.

/// Turns per round, and boxes Chigüi can hide in.
const hideTurns = 5;
const hideBoxes = 3;

/// Swaps per turn and how long each takes, from the first turn to the last:
/// slow and few at first, a bit trickier later, never frantic.
const hideSwapsFirst = 2;
const hideSwapsLast = 6;
const hideSwapTimeFirst = Duration(milliseconds: 700);
const hideSwapTimeLast = Duration(milliseconds: 380);

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

  /// This turn's swaps, as pairs of boxes, in order.
  var swaps = <(int, int)>[];

  /// Turns played so far.
  int turn = 0;
  int found = 0;

  bool get over => turn >= hideTurns;

  double get _progress => hideTurns > 1 ? turn / (hideTurns - 1) : 0;

  Duration get swapTime =>
      hideSwapTimeFirst + (hideSwapTimeLast - hideSwapTimeFirst) * _progress;

  /// Chigüi picks a box and the swaps for this turn are planned.
  void startTurn() {
    chiguiBox = _random.nextInt(hideBoxes);
    final count =
        hideSwapsFirst + ((hideSwapsLast - hideSwapsFirst) * _progress).round();
    swaps = [
      for (var i = 0; i < count; i++)
        () {
          final a = _random.nextInt(hideBoxes);
          final b = (a + 1 + _random.nextInt(hideBoxes - 1)) % hideBoxes;
          return (a, b);
        }(),
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
