import 'dart:math';

import 'package:chigui_game/walk/step_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const gravity = 9.81;
  const rate = 60; // samples per second, typical for devicemotion

  int countSteps(double Function(double t) signal, double seconds) {
    final detector = StepDetector();
    var steps = 0;
    for (var i = 0; i < seconds * rate; i++) {
      final t = i / rate;
      if (detector.add(t, signal(t))) steps++;
    }
    return steps;
  }

  test('counts a normal walk of about two steps per second', () {
    final steps = countSteps((t) => gravity + 3 * sin(2 * pi * 2 * t), 10);
    expect(steps, inInclusiveRange(18, 21));
  });

  test('ignores a phone lying still with sensor noise', () {
    final random = Random(1);
    final steps = countSteps(
      (t) => gravity + (random.nextDouble() - 0.5) * 0.4,
      10,
    );
    expect(steps, 0);
  });

  test('ignores shaking much faster than anyone walks', () {
    final steps = countSteps((t) => gravity + 3 * sin(2 * pi * 8 * t), 10);
    expect(steps, lessThanOrEqualTo(10 / minStepInterval));
  });
}
