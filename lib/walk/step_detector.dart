// Provisional tuning; adjust after trying it on real phones.

/// How far (m/s²) the smoothed acceleration must rise above its running
/// average to count as a step.
const stepThreshold = 1.2;

/// People take 1–3 steps per second; faster bumps are noise.
const minStepInterval = 0.3; // seconds

/// Counts walking steps from the magnitude of the phone's acceleration
/// (including gravity), sampled while the walk scene is open.
///
/// Each step makes the magnitude bounce; a step is counted when the smoothed
/// signal rises above its slow-moving average by [stepThreshold], at most
/// once per [minStepInterval].
class StepDetector {
  double? _smooth;
  double? _average;
  bool _above = false;
  double _lastStep = double.negativeInfinity;

  /// Feeds one sample taken at [seconds]. Returns true if it completes a
  /// step.
  bool add(double seconds, double magnitude) {
    final smooth = _smooth = (_smooth ?? magnitude) * 0.7 + magnitude * 0.3;
    final average = _average = (_average ?? magnitude) * 0.97 + smooth * 0.03;
    final rising = smooth > average + stepThreshold;
    final step = rising && !_above && seconds - _lastStep >= minStepInterval;
    if (rising && !_above) _above = true;
    if (smooth < average) _above = false;
    if (step) _lastStep = seconds;
    return step;
  }
}
