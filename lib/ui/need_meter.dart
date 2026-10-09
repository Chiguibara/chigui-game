import 'package:flutter/material.dart';

import '../game/pet_state.dart';
import '../l10n/app_localizations.dart';
import 'palette.dart';

/// A small, secondary meter; Chigüi's mood is the main way needs are shown.
class NeedMeter extends StatelessWidget {
  const NeedMeter({super.key, required this.need, required this.level});

  final Need need;
  final double level;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color, name) = switch (need) {
      Need.food => (Icons.eco, Palette.leaf, l10n.needFood),
      Need.affection => (Icons.favorite, Palette.blush, l10n.needAffection),
      Need.fun => (Icons.toys, Palette.furDark, l10n.needFun),
    };

    return Semantics(
      label: l10n.needMeterLabel(name, (level * 100).round()),
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          SizedBox(
            width: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: level,
                minHeight: 8,
                color: color,
                backgroundColor: Palette.ink.withValues(alpha: 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
