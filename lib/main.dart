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
  runApp(
    ChiguiApp(
      controller: controller,
      packs: packs,
      steps: steps,
      pedometer: pedometer,
      reminders: reminders,
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
