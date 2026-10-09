import 'package:flutter/material.dart';

import 'app.dart';
import 'data/json_game_repository.dart';
import 'game/pet_controller.dart';
import 'l10n/app_localizations.dart';
import 'sound/sound_effects.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await PetController.load(await JsonGameRepository.open());
  sfx = await SoundEffects.load();
  runApp(ChiguiApp(controller: controller, locale: _localeFromUrl()));
}

/// The website passes its language as `?lang=es` (or `en`); anything else,
/// or no parameter (e.g. outside the web), follows the device.
Locale? _localeFromUrl() {
  final code = Uri.base.queryParameters['lang'];
  return AppLocalizations.supportedLocales
      .where((l) => l.languageCode == code)
      .firstOrNull;
}
