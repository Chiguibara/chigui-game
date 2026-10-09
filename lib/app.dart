import 'package:flutter/material.dart';

import 'game/pet_controller.dart';
import 'l10n/app_localizations.dart';
import 'ui/home_screen.dart';
import 'ui/palette.dart';

class ChiguiApp extends StatelessWidget {
  const ChiguiApp({super.key, required this.controller});

  final PetController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.mint),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(controller: controller),
    );
  }
}
