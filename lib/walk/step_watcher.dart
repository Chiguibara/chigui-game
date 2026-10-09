import 'dart:async';

import 'motion_source.dart';
import 'step_detector.dart';

/// The game's single listener to the phone's motion sensor (web on phones),
/// shared by every screen. It turns motion into steps; screens decide what
/// steps mean.
class StepWatcher {
  StepWatcher(this._source);

  final MotionSource? _source;
  final _detector = StepDetector();
  final _steps = StreamController<void>.broadcast();
  Future<bool>? _starting;
  bool _listening = false;

  /// True once motion samples have actually arrived (a sensor exists).
  bool receiving = false;

  /// One event per detected step.
  Stream<void> get steps => _steps.stream;

  /// Starts listening; safe to call often. On iPhone the first call that
  /// comes from a tap shows the permission prompt; calls outside a tap fail
  /// there and can be retried, so call it again on the player's first tap.
  Future<bool> start() async {
    if (_listening) return true;
    final source = _source;
    if (source == null) return false;
    final ok = await (_starting ??= source.start(_onSample));
    _starting = null;
    _listening = ok;
    return ok;
  }

  void _onSample(double seconds, double magnitude) {
    receiving = true;
    if (_detector.add(seconds, magnitude)) _steps.add(null);
  }

  void dispose() {
    _source?.stop();
    _steps.close();
  }
}

// Provisional tuning: about 10 metres at a child's ~60 cm per step.
const walkStartSteps = 16;
const walkStartMaxGap = Duration(seconds: 2);

/// Notices when the player starts walking for real: [steps] steps in a row,
/// with no pause longer than [maxGap].
class WalkStartDetector {
  WalkStartDetector({
    this.steps = walkStartSteps,
    this.maxGap = walkStartMaxGap,
  });

  final int steps;
  final Duration maxGap;
  int _streak = 0;
  DateTime? _last;

  /// Feeds [count] steps at [time] (sensors may report in batches); returns
  /// true when the streak reaches the threshold (then starts over).
  bool step(DateTime time, [int count = 1]) {
    final last = _last;
    _last = time;
    _streak = last != null && time.difference(last) <= maxGap
        ? _streak + count
        : count;
    if (_streak < steps) return false;
    _streak = 0;
    return true;
  }

  void reset() {
    _streak = 0;
    _last = null;
  }
}
