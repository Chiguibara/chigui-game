import 'package:chigui_game/walk/motion_source.dart';

/// A pretend phone sensor the test can shake.
class FakeMotion implements MotionSource {
  FakeMotion({this.refusals = 0});

  /// How many start() calls fail first (like iPhone before a tap).
  int refusals;
  MotionListener? listener;
  bool stopped = false;

  @override
  Future<bool> start(MotionListener onSample) async {
    if (refusals > 0) {
      refusals--;
      return false;
    }
    listener = onSample;
    return true;
  }

  @override
  void stop() => stopped = true;

  double _t = 0;

  /// About [steps] walking steps at two per second.
  void walk(int steps) {
    for (var i = 0; i < steps * 30; i++) {
      _t += 1 / 60;
      listener!(_t, 9.81 + 3 * ((i % 30) < 15 ? 1 : -1));
    }
  }
}
