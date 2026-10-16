import 'dart:math';

// Provisional tuning; adjust after playtests. Positions are fractions of
// Chigüi's square canvas (as in the painter), so the bath scales to any size.

/// Sticky spots on the first bath of a visit; each bath in a row adds one,
/// up to [bathSpotsMost], and more of them have gravel stuck on top.
const bathSpotsFirst = 4;
const bathSpotsMost = 7;
const bathGravelFirst = 0.2; // chance per spot
const bathGravelStep = 0.15;
const bathGravelMost = 0.6;

/// How much brushing a spot needs, in canvas widths of rubbing; a tap counts
/// as [bathTapRub]. Drying Chigüi with the towel needs [bathDryNeeded].
const bathScrubNeeded = 0.8;
const bathDryNeeded = 1.6;
const bathTapRub = 0.2;

/// How far beyond a spot's edge a tool still reaches it; the ladle pours
/// over a wide area.
const bathReach = 0.04;
const bathLadleReach = 0.16;

/// Yuzus to toss into the water before Chigüi has a soak.
const bathYuzus = 3;

/// After this long without cleaning anything, the tool needed next hops.
const bathHintAfter = Duration(seconds: 8);

enum BathTool {
  soap,
  brush,
  ladle,
  yuzu,
  towel,
}

/// The bath goes: Chigüi arrives dirty, hops into the tub, gets washed,
/// gets yuzus in the water, has a soak, hops out, and is dried.
enum BathStage {
  arrive,
  wash,
  yuzu,
  soak,
  dry,
  done,
}

/// A sticky spot, from dirtiest to clean: gravel is brushed off the tar, tar
/// is soaped, the lather is brushed, and the dirty foam is rinsed away.
enum SpotState {
  gravel,
  tar,
  lathered,
  foam,
  clean,
}

class Spot {
  Spot(this.x, this.y, this.size, this.state, this.seed);

  final double x;
  final double y;

  /// Radius, in canvas widths.
  final double size;
  SpotState state;

  /// For drawing: the same blob shape every frame.
  final int seed;

  /// Brushing done on the current step, 0 to 1.
  double scrubbed = 0;

  BathTool? get needs => switch (state) {
    SpotState.gravel || SpotState.lathered => BathTool.brush,
    SpotState.tar => BathTool.soap,
    SpotState.foam => BathTool.ladle,
    SpotState.clean => null,
  };
}

/// What using a tool did.
enum BathUse {
  /// Not this tool's turn: nothing needs it now.
  wrong,

  /// The right tool, but not on anything it can clean.
  missed,

  /// Brushing or drying, not finished yet.
  rubbing,

  /// A spot moved on to its next step.
  step,

  /// The last spot is clean.
  washed,

  /// A yuzu splashed into the water.
  yuzu,

  /// Chigüi is dry: the bath is over.
  dried,
}

/// "Bath time": Chigüi comes back from playing covered in sticky tar and
/// gravel. Every spot needs the right tools in order; using the wrong one
/// costs nothing, it just does nothing.
class BathGame {
  BathGame({int bath = 0, Random? random}) : _random = random ?? Random() {
    final count = min(bathSpotsFirst + bath, bathSpotsMost);
    final gravel = min(bathGravelFirst + bathGravelStep * bath, bathGravelMost);
    for (var tries = 0; spots.length < count && tries < 2000; tries++) {
      final size = 0.08 + _random.nextDouble() * 0.04;
      final (x, y) = _place();
      // Keep the eye and the mouth clear, and spots apart.
      if (_near(x, y, 0.6, 0.34, 0.06 + size) ||
          _near(x, y, 0.8, 0.47, 0.04 + size)) {
        continue;
      }
      // Spots may overlap a little, like one big sticky mess.
      if (spots.any((s) => _near(x, y, s.x, s.y, (s.size + size) * 0.7))) {
        continue;
      }
      spots.add(
        Spot(
          x,
          y,
          size,
          _random.nextDouble() < gravel ? SpotState.gravel : SpotState.tar,
          _random.nextInt(1 << 30),
        ),
      );
    }
  }

  final Random _random;
  final spots = <Spot>[];
  BathStage stage = BathStage.arrive;
  int yuzus = 0;

  /// How wet Chigüi is after the bath, from 1 (dripping) to 0 (dry).
  double wet = 1;

  /// A spot on the head or the upper body, above the water line.
  (double, double) _place() {
    if (_random.nextBool()) {
      return (
        0.42 + _random.nextDouble() * 0.4,
        0.27 + _random.nextDouble() * 0.27,
      );
    }
    return (
      0.18 + _random.nextDouble() * 0.44,
      0.48 + _random.nextDouble() * 0.12,
    );
  }

  static bool _near(double x, double y, double x2, double y2, double r) =>
      (x - x2) * (x - x2) + (y - y2) * (y - y2) < r * r;

  /// How much of the dirt is left, from 1 (all of it) to 0.
  double get dirt {
    if (spots.isEmpty) return 0;
    final left = spots.where((s) => s.state.index < SpotState.lathered.index);
    return left.length / spots.length;
  }

  /// The tool the bath needs next, for hints.
  BathTool? get needed => switch (stage) {
    BathStage.wash => spots.map((s) => s.needs).nonNulls.firstOrNull,
    BathStage.yuzu => BathTool.yuzu,
    BathStage.dry => BathTool.towel,
    _ => null,
  };

  void hopIn() {
    if (stage == BathStage.arrive) stage = BathStage.wash;
  }

  /// After the soak, Chigüi hops out to be dried.
  void hopOut() {
    if (stage == BathStage.soak) stage = BathStage.dry;
  }

  /// Uses [tool] at ([x], [y]); [rub] is how far it was rubbed, 0 for a tap.
  BathUse use(BathTool tool, double x, double y, {double rub = 0}) {
    final scrub = rub > 0 ? rub : bathTapRub;
    switch (stage) {
      case BathStage.wash:
        if (!spots.any((s) => s.needs == tool)) return BathUse.wrong;
        final reach = tool == BathTool.ladle ? bathLadleReach : bathReach;
        final hit = spots.where(
          (s) => s.needs == tool && _near(x, y, s.x, s.y, s.size + reach),
        );
        if (hit.isEmpty) return BathUse.missed;
        var stepped = false;
        for (final spot in hit) {
          if (tool == BathTool.brush) {
            spot.scrubbed += scrub / bathScrubNeeded;
            if (spot.scrubbed < 1) continue;
            spot.scrubbed = 0;
          }
          spot.state = SpotState.values[spot.state.index + 1];
          stepped = true;
        }
        if (spots.every((s) => s.state == SpotState.clean)) {
          stage = BathStage.yuzu;
          return BathUse.washed;
        }
        return stepped ? BathUse.step : BathUse.rubbing;
      case BathStage.yuzu:
        if (tool != BathTool.yuzu) return BathUse.wrong;
        yuzus++;
        if (yuzus >= bathYuzus) stage = BathStage.soak;
        return BathUse.yuzu;
      case BathStage.dry:
        if (tool != BathTool.towel) return BathUse.wrong;
        wet = max(0, wet - scrub / bathDryNeeded);
        if (wet > 0) return BathUse.rubbing;
        stage = BathStage.done;
        return BathUse.dried;
      case BathStage.arrive || BathStage.soak || BathStage.done:
        return BathUse.wrong;
    }
  }
}
