import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/json_game_repository.dart';
import 'game/pet_controller.dart';
import 'l10n/app_localizations.dart';
import 'notify/reminders.dart';
import 'notify/system_notice_board.dart';
import 'sound/sound_effects.dart';
import 'store/create_pack_store.dart';
import 'store/packs_controller.dart';
import 'ui/whats_new.dart';
import 'update/play_updater.dart';
import 'update/update_notice.dart';
import 'update/update_watcher.dart';
import 'update/version_source.dart';
import 'walk/motion_source.dart';
import 'walk/pedometer.dart';
import 'walk/step_watcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await PetController.load(await JsonGameRepository.open());
  sfx = await SoundEffects.load();
  final packs = PacksController(await createPackStore(), controller);
  // Talks to the store in the background; the game starts right away.
  unawaited(packs.start());
  // Phones' browsers: listen for real steps from the start (Android needs
  // no permission; iPhone asks on the first tap, see ChiguiApp).
  final onPhoneWeb =
      kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  final steps = onPhoneWeb ? StepWatcher(createMotionSource()) : null;
  unawaited(steps?.start());
  // The Android app: the system step counter, which also counts while the
  // app is closed (asks for "physical activity" on first launch).
  final pedometer = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? Pedometer(controller, await SharedPreferences.getInstance())
      : null;
  final pedometerStarted = pedometer?.start();
  unawaited(pedometerStarted);
  // The Android app: gentle routine reminders, on unless the player says no
  // when asked; scheduled only while the game is in the background.
  final reminders = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? Reminders(
          SystemNoticeBoard(),
          await SharedPreferences.getInstance(),
          controller,
        )
      : null;
  if (reminders != null) {
    void opened() {
      unawaited(reminders.refresh());
      unawaited(reminders.clear());
    }

    // After the steps permission, so the two questions do not overlap.
    final Future<void> asked = pedometerStarted ?? Future.value();
    unawaited(asked.then((_) => opened()));
    AppLifecycleListener(onHide: reminders.scheduleAhead, onShow: opened);
  }
  // The web: tabs left open for days notice when a new version is deployed.
  final versions = createVersionSource();
  final webUpdates = versions != null ? UpdateWatcher(versions) : null;
  if (webUpdates != null) {
    unawaited(webUpdates.start());
    AppLifecycleListener(onShow: webUpdates.check);
  }
  // The Android app: Google Play downloads newer versions in the background
  // (asking at most once a day), then home offers to restart into them.
  final playUpdates = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? PlayUpdater(PlayUpdateChannel(), await SharedPreferences.getInstance())
      : null;
  if (playUpdates != null) {
    // After the steps permission, so Play's prompt does not overlap it.
    final Future<void> asked = pedometerStarted ?? Future.value();
    unawaited(asked.then((_) => playUpdates.start()));
    AppLifecycleListener(onShow: playUpdates.check);
  }
  final UpdateNotice? updates = webUpdates ?? playUpdates;
  final whatsNew = await WhatsNew.load();
  runApp(
    ChiguiApp(
      controller: controller,
      packs: packs,
      steps: steps,
      pedometer: pedometer,
      reminders: reminders,
      updates: updates,
      whatsNew: whatsNew,
      locale: _localeFromUrl(),
    ),
  );
}

/// The website passes its language as `?lang=es` (or `en`); anything else,
/// or no parameter (e.g. outside the web), follows the device.
Locale? _localeFromUrl() {
  final code = Uri.base.queryParameters['lang'];
  return AppLocalizations.supportedLocales
      .where((l) => l.languageCode == code)
      .firstOrNull;
}
