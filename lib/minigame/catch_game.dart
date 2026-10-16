import 'dart:math';

// Provisional tuning; adjust after playtests. Positions are fractions of the
// play area (0 = left/top, 1 = right/bottom), so the game scales to any size.

const roundLength = Duration(seconds: 30);

/// Fruit falls faster and more often as the round goes on, with some jitter
/// so the rhythm cannot be counted.
const spawnEveryStart = 0.85; // seconds
const spawnEveryEnd = 0.5;
const spawnJitter = 0.25; // ± this fraction of the interval
const fallSpeedStart = 0.5; // play-area heights per second
const fallSpeedEnd = 1.0;

/// Now and then a stone falls instead of fruit, at random: never in the first
/// seconds (how many changes every round) and never two in a row, so there
/// are only a few per round and children cannot learn when they come.
const stoneChance = 0.1;
const stonesFromEarliest = 3.0; // seconds into the round
const stonesFromLatest = 7.0;

/// Where Chigüi's mouth catches fruit, and how close a fruit must be.
const catchLine = 0.82;
const catchReach = 0.13;

/// How fast Chigüi follows the player's finger, in widths per second.
const chiguiSpeed = 2.5;

enum FruitKind {
  orange,
  guava,
  mango,
  starApple,
  watermelon,
  melon,
  banana,
  apple,

  /// Not fruit: a stone that bonks Chigüi (who says "Ouch!"). It gives no
  /// coins, but takes none either: a mistake is never punished.
  stone,
}

final fruitKinds = [
  for (final kind in FruitKind.values)
    if (kind != FruitKind.stone) kind,
];

class Fruit {
  Fruit(this.kind, this.x, this.y);

  final FruitKind kind;
  final double x;
  double y;
}

/// "Fruit catch": fruit falls and the player moves Chigüi to catch it.
/// Missing fruit costs nothing; the round simply ends after [roundLength].
/// Stones that land on Chigüi count as [bonks]; dodged ones just fall away.
class CatchGame {
  CatchGame({Random? random}) : _random = random ?? Random() {
    _stonesFrom =
        stonesFromEarliest +
        _random.nextDouble() * (stonesFromLatest - stonesFromEarliest);
  }

  final Random _random;
  late final double _stonesFrom;
  final fruits = <Fruit>[];

  /// How close (in play-area widths) a fruit must land to be caught. The
  /// screen adjusts it to Chigüi's drawn size, so wide screens stay fair.
  double reach = catchReach;

  double chiguiX = 0.5;
  double targetX = 0.5;
  int caught = 0;
  int bonks = 0;
  double _elapsed = 0;
  double _untilSpawn = 0;
  bool _lastWasStone = false;

  double get timeLeft => max(0, roundLength.inMilliseconds / 1000 - _elapsed);
  bool get over => timeLeft == 0;

  /// Moves Chigüi towards [x] (e.g. the player's finger).
  void aimAt(double x) => targetX = x.clamp(0.08, 0.92);

  /// Advances the game by [seconds]. Returns how many fruits were caught and
  /// how many stones bonked Chigüi in this step. Large steps are split so
  /// nothing tunnels past Chigüi.
  ({int caught, int bonks}) update(double seconds) {
    final caughtBefore = caught;
    final bonksBefore = bonks;
    var left = seconds;
    while (left > 0 && !over) {
      final dt = min(left, 1 / 30);
      left -= dt;
      _step(dt);
    }
    return (caught: caught - caughtBefore, bonks: bonks - bonksBefore);
  }

  void _step(double dt) {
    _elapsed += dt;
    final progress = _elapsed / (roundLength.inMilliseconds / 1000);

    final move = chiguiSpeed * dt;
    chiguiX += (targetX - chiguiX).clamp(-move, move);

    _untilSpawn -= dt;
    if (_untilSpawn <= 0) {
      final every =
          spawnEveryStart + (spawnEveryEnd - spawnEveryStart) * progress;
      _untilSpawn +=
          every * (1 - spawnJitter + 2 * spawnJitter * _random.nextDouble());
      final stone =
          _elapsed >= _stonesFrom &&
          !_lastWasStone &&
          _random.nextDouble() < stoneChance;
      _lastWasStone = stone;
      fruits.add(
        Fruit(
          stone
              ? FruitKind.stone
              : fruitKinds[_random.nextInt(fruitKinds.length)],
          0.08 + _random.nextDouble() * 0.84,
          -0.05,
        ),
      );
    }

    final speed = fallSpeedStart + (fallSpeedEnd - fallSpeedStart) * progress;
    fruits.removeWhere((fruit) {
      final before = fruit.y;
      fruit.y += speed * dt;
      if (before < catchLine &&
          fruit.y >= catchLine &&
          (fruit.x - chiguiX).abs() <= reach) {
        if (fruit.kind == FruitKind.stone) {
          bonks++;
        } else {
          caught++;
        }
        return true;
      }
      return fruit.y > 1.1;
    });
  }
}
