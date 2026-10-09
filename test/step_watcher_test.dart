import 'package:chigui_game/walk/step_watcher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_motion.dart';

void main() {
  test('counts steps from motion', () async {
    final motion = FakeMotion();
    final watcher = StepWatcher(motion);
    var steps = 0;
    watcher.steps.listen((_) => steps++);
    expect(await watcher.start(), isTrue);
    motion.walk(10);
    await Future<void>.delayed(Duration.zero);
    expect(steps, inInclusiveRange(8, 11));
    expect(watcher.receiving, isTrue);
  });

  test('retries after a refused start (iPhone before the first tap)', () async {
    final watcher = StepWatcher(FakeMotion(refusals: 1));
    expect(await watcher.start(), isFalse);
    expect(await watcher.start(), isTrue);
    expect(await watcher.start(), isTrue, reason: 'safe to call again');
  });

  test('without a sensor there is nothing to start', () async {
    expect(await StepWatcher(null).start(), isFalse);
  });

  group('WalkStartDetector', () {
    final t0 = DateTime(2026, 10, 12, 12);

    test('fires after enough steps in a row', () {
      final d = WalkStartDetector();
      var fired = 0;
      for (var i = 0; i < walkStartSteps; i++) {
        if (d.step(t0.add(Duration(milliseconds: 500 * i)))) fired++;
      }
      expect(fired, 1);
    });

    test('a pause starts the count over', () {
      final d = WalkStartDetector();
      var time = t0;
      for (var i = 0; i < walkStartSteps - 1; i++) {
        expect(
          d.step(time = time.add(const Duration(milliseconds: 500))),
          isFalse,
        );
      }
      time = time.add(walkStartMaxGap + const Duration(seconds: 1));
      expect(d.step(time), isFalse);
    });
  });
}
