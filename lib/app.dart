import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'ui/home_screen.dart';
import 'ui/palette.dart';

class ChiguiApp extends StatelessWidget {
  const ChiguiApp({super.key});

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
      home: const HomeScreen(),
    );
  }
}
