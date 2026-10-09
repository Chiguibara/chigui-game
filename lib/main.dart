import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'data/json_game_repository.dart';
import 'game/pet_controller.dart';
import 'l10n/app_localizations.dart';
import 'sound/sound_effects.dart';
import 'store/create_pack_store.dart';
import 'store/packs_controller.dart';
import 'walk/motion_source.dart';
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
  runApp(
    ChiguiApp(
      controller: controller,
      packs: packs,
      steps: steps,
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
