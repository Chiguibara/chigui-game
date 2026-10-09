import 'dart:math';

// Provisional tuning; adjust after playtests. Positions are fractions of the
// play area (0 = left/top, 1 = right/bottom), so the game scales to any size.

const roundLength = Duration(seconds: 30);
const spawnEvery = 0.8; // seconds
const fallSpeedStart = 0.35; // play-area heights per second
const fallSpeedEnd = 0.6;

/// Where Chigüi's mouth catches fruit, and how close a fruit must be.
const catchLine = 0.82;
const catchReach = 0.13;

/// How fast Chigüi follows the player's finger, in widths per second.
const chiguiSpeed = 2.5;

enum FruitKind { watermelon, orange }

class Fruit {
  Fruit(this.kind, this.x, this.y);

  final FruitKind kind;
  final double x;
  double y;
}

/// "Fruit catch": fruit falls and the player moves Chigüi to catch it.
/// Missing fruit costs nothing; the round simply ends after [roundLength].
class CatchGame {
  CatchGame({Random? random}) : _random = random ?? Random();

  final Random _random;
  final fruits = <Fruit>[];

  /// How close (in play-area widths) a fruit must land to be caught. The
  /// screen adjusts it to Chigüi's drawn size, so wide screens stay fair.
  double reach = catchReach;

  double chiguiX = 0.5;
  double targetX = 0.5;
  int caught = 0;
  double _elapsed = 0;
  double _untilSpawn = 0;

  double get timeLeft => max(0, roundLength.inMilliseconds / 1000 - _elapsed);
  bool get over => timeLeft == 0;

  /// Moves Chigüi towards [x] (e.g. the player's finger).
  void aimAt(double x) => targetX = x.clamp(0.08, 0.92);

  /// Advances the game by [seconds]. Returns how many fruits were caught in
  /// this step. Large steps are split so nothing tunnels past Chigüi.
  int update(double seconds) {
    var caughtNow = 0;
    var left = seconds;
    while (left > 0 && !over) {
      final dt = min(left, 1 / 30);
      left -= dt;
      caughtNow += _step(dt);
    }
    return caughtNow;
  }

  int _step(double dt) {
    _elapsed += dt;

    final move = chiguiSpeed * dt;
    chiguiX += (targetX - chiguiX).clamp(-move, move);

    _untilSpawn -= dt;
    if (_untilSpawn <= 0) {
      _untilSpawn += spawnEvery;
      fruits.add(
        Fruit(
          FruitKind.values[_random.nextInt(FruitKind.values.length)],
          0.08 + _random.nextDouble() * 0.84,
          -0.05,
        ),
      );
    }

    final progress = _elapsed / (roundLength.inMilliseconds / 1000);
    final speed = fallSpeedStart + (fallSpeedEnd - fallSpeedStart) * progress;
    var caughtNow = 0;
    fruits.removeWhere((fruit) {
      final before = fruit.y;
      fruit.y += speed * dt;
      if (before < catchLine &&
          fruit.y >= catchLine &&
          (fruit.x - chiguiX).abs() <= reach) {
        caughtNow++;
        return true;
      }
      return fruit.y > 1.1;
    });
    caught += caughtNow;
    return caughtNow;
  }
}
