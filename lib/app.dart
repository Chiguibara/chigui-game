import 'package:flutter/material.dart';

import 'game/pet_controller.dart';
import 'l10n/app_localizations.dart';
import 'store/packs_controller.dart';
import 'walk/pedometer.dart';
import 'walk/step_watcher.dart';
import 'ui/home_screen.dart';
import 'ui/palette.dart';

class ChiguiApp extends StatelessWidget {
  const ChiguiApp({
    super.key,
    required this.controller,
    this.packs,
    this.steps,
    this.pedometer,
    this.locale,
  });

  final PetController controller;

  /// Real-money packs; null where they are not sold.
  final PacksController? packs;

  /// Real steps from the phone's sensor (web on phones); null elsewhere.
  final StepWatcher? steps;

  /// The Android system step counter; null elsewhere.
  final Pedometer? pedometer;

  /// Forces a language (e.g. from the website's URL); null follows the device.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.mint),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      // Any first tap lets iPhone show its motion-permission prompt.
      builder: (context, child) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => steps?.start(),
        child: child,
      ),
      home: HomeScreen(
        controller: controller,
        packs: packs,
        steps: steps,
        pedometer: pedometer,
      ),
    );
  }
}
