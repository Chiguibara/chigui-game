import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'chigui_view.dart';
import 'palette.dart';
import 'phone_frame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _happy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Palette.outside,
      body: PhoneFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final petSize = constraints.maxWidth * 0.75;
                return Column(
                  children: [
                    const Spacer(),
                    Text(
                      l10n.chiguiName,
                      style: textTheme.headlineMedium?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ChiguiView(
                      size: petSize,
                      onHappyChanged: (happy) => setState(() => _happy = happy),
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _happy ? l10n.happyStatus : l10n.tapHint,
                        style: textTheme.titleMedium?.copyWith(
                          color: Palette.ink,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
