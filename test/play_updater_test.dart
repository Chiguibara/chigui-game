import 'package:chigui_game/app.dart';
import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/update/play_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Google Play as tests set it up by hand.
class FakePlayUpdates implements PlayUpdateApi {
  PlayUpdateStatus status = PlayUpdateStatus.none;
  bool agree = true;
  int prompts = 0;
  int installs = 0;
  VoidCallback? onDownloaded;

  @override
  Future<PlayUpdateStatus> check() async => status;

  @override
  Future<bool> download() async {
    prompts++;
    if (agree) status = PlayUpdateStatus.none; // Downloading.
    return agree;
  }

  @override
  Future<void> install() async => installs++;

  @override
  void listen(VoidCallback onDownloaded) => this.onDownloaded = onDownloaded;

  /// Play finishes the download while the game runs.
  void finish() {
    status = PlayUpdateStatus.downloaded;
    onDownloaded?.call();
  }
}

void main() {
  // Monday 16:00: after school, before the routine starts at 17:00.
  final now = DateTime(2026, 10, 12, 16);

  test('downloads when Play has an update, then is ready', () async {
    SharedPreferences.setMockInitialValues({});
    final play = FakePlayUpdates();
    final updater = PlayUpdater(
      play,
      await SharedPreferences.getInstance(),
      clock: () => now,
    );
    addTearDown(updater.dispose);

    await updater.start();
    expect(play.prompts, 0);
    expect(updater.updateReady, isFalse);

    play.status = PlayUpdateStatus.available;
    await updater.check();
    expect(play.prompts, 1);
    expect(updater.updateReady, isFalse);

    play.finish();
    expect(updater.updateReady, isTrue);
    updater.update();
    expect(play.installs, 1);
  });

  test('a download finished earlier is ready when checked', () async {
    SharedPreferences.setMockInitialValues({});
    final play = FakePlayUpdates()..status = PlayUpdateStatus.downloaded;
    final updater = PlayUpdater(play, await SharedPreferences.getInstance());
    addTearDown(updater.dispose);

    await updater.start();
    expect(updater.updateReady, isTrue);
    expect(play.prompts, 0);
  });

  test('after a "no", asks again only a day later', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    var clock = now;
    final play = FakePlayUpdates()
      ..status = PlayUpdateStatus.available
      ..agree = false;
    final updater = PlayUpdater(play, prefs, clock: () => clock);
    addTearDown(updater.dispose);

    await updater.start();
    expect(play.prompts, 1);

    clock = now.add(const Duration(hours: 23));
    await updater.check();
    expect(play.prompts, 1);

    // Remembered across restarts.
    final restarted = PlayUpdater(play, prefs, clock: () => clock);
    addTearDown(restarted.dispose);
    await restarted.start();
    expect(play.prompts, 1);

    clock = now.add(PlayUpdater.askEvery);
    await updater.check();
    expect(play.prompts, 2);
    expect(updater.updateReady, isFalse);
  });

  testWidgets('home offers to restart once Play has downloaded', (
    tester,
  ) async {
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
    final play = FakePlayUpdates()..status = PlayUpdateStatus.available;
    final updater = PlayUpdater(play, await SharedPreferences.getInstance());
    await updater.start();
    await tester.pumpWidget(
      ChiguiApp(controller: controller, updates: updater),
    );
    expect(find.text('New version! Update'), findsNothing);

    play.finish();
    await tester.pump();
    expect(find.text('New version! Update'), findsOneWidget);

    await tester.tap(find.text('New version! Update'));
    expect(play.installs, 1);
    updater.dispose();
  });
}
