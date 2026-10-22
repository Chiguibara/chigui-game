import 'package:chigui_game/app.dart';
import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/update/update_watcher.dart';
import 'package:chigui_game/update/version_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A deployed version that tests change by hand; null is "offline".
class FakeVersionSource implements VersionSource {
  FakeVersionSource(this.version);

  String? version;
  int reloads = 0;

  @override
  Future<String?> latest() async => version;

  @override
  void reload() => reloads++;
}

void main() {
  // Monday 16:00: after school, before the routine starts at 17:00.
  final now = DateTime(2026, 10, 12, 16);

  test('notices a new version only when it differs', () async {
    final source = FakeVersionSource(null);
    final watcher = UpdateWatcher(source);
    addTearDown(watcher.dispose);

    // Offline at first: nothing is known yet.
    await watcher.start();
    source.version = '1.0.3+57';
    await watcher.check();
    await watcher.check();
    expect(watcher.updateReady, isFalse);

    source.version = null;
    await watcher.check();
    expect(watcher.updateReady, isFalse);

    source.version = '1.0.4+58';
    await watcher.check();
    expect(watcher.updateReady, isTrue);
    watcher.update();
    expect(source.reloads, 1);
  });

  testWidgets('home offers to update after a new deploy', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final repo = await JsonGameRepository.open();
    await repo.saveState(
      PetState(
        needs: {for (final n in Need.values) n: 0.8},
        updatedAt: now,
        seed: 42,
      ),
    );
    final controller = await PetController.load(repo, clock: () => now);
    final source = FakeVersionSource('1.0.3+57');
    final watcher = UpdateWatcher(source);
    await watcher.start();
    await tester.pumpWidget(
      ChiguiApp(controller: controller, updates: watcher),
    );
    expect(find.text('New version! Update'), findsNothing);

    // Checked again later, as on a timer or when the tab is shown again.
    source.version = '1.0.4+58';
    await tester.pump(UpdateWatcher.checkEvery);
    await tester.pump();
    expect(find.text('New version! Update'), findsOneWidget);

    await tester.tap(find.text('New version! Update'));
    expect(source.reloads, 1);
    watcher.dispose();
  });
}
