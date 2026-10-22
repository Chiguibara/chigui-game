import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import 'palette.dart';

/// A version's "What's new": a title and a few points.
typedef Notes = ({String title, List<String> points});

/// The notes of the running version, shown once after an update. They are
/// the Google Play notes (`distribution/whatsnew/`, one store listing per
/// language) plus the Catalan ones only shown in the game
/// (`distribution/whatsnew-game/`), bundled as assets.
class WhatsNew {
  const WhatsNew({required this.en, required this.es, required this.ca});

  static const enAsset = 'distribution/whatsnew/whatsnew-en-US';
  static const esAsset = 'distribution/whatsnew/whatsnew-es-ES';
  static const caAsset = 'distribution/whatsnew-game/whatsnew-ca-ES';

  /// Loads the bundled notes, or null if they cannot be read.
  static Future<WhatsNew?> load([AssetBundle? bundle]) async {
    final assets = bundle ?? rootBundle;
    try {
      final (en, es, ca) = await (
        assets.loadString(enAsset),
        assets.loadString(esAsset),
        assets.loadString(caAsset),
      ).wait;
      return WhatsNew(en: en, es: es, ca: ca);
    } catch (error) {
      debugPrint('No "What\'s new" notes: $error');
      return null;
    }
  }

  final String en;
  final String es;
  final String ca;

  /// Identifies this version's notes in the save: a stable hash (32-bit
  /// FNV-1a) of the English text, which changes with every production
  /// version. Fixing only a translation does not show the notes again.
  String get fingerprint {
    var hash = 0x811c9dc5;
    for (final unit in en.trim().codeUnits) {
      hash ^= unit;
      // Times the FNV prime (2²⁴ + 403) with shifts, which stay exact on
      // the web, where numbers are doubles.
      hash =
          (hash +
              (hash << 1) +
              (hash << 4) +
              (hash << 7) +
              (hash << 8) +
              (hash << 24)) &
          0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  /// Spanish and Catalan have their own notes; every other language reads
  /// the English ones (there is no store listing in German or French).
  Notes forLanguage(String languageCode) => parse(switch (languageCode) {
    'es' => es,
    'ca' => ca,
    _ => en,
  });

  /// The first line is the title; each other line is a point, with or
  /// without its "• ".
  static Notes parse(String text) {
    final lines = [
      for (final line in text.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];
    return (
      title: lines.firstOrNull ?? '',
      points: [
        for (final line in lines.skip(1))
          line.startsWith('•') ? line.substring(1).trim() : line,
      ],
    );
  }
}

/// Shows this version's notes in the player's language.
Future<void> showWhatsNewDialog(BuildContext context, WhatsNew whatsNew) {
  final notes = whatsNew.forLanguage(
    Localizations.localeOf(context).languageCode,
  );
  return showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final textTheme = Theme.of(context).textTheme;
      return AlertDialog(
        semanticLabel: l10n.whatsNewLabel,
        icon: const Icon(Icons.auto_awesome, color: Palette.ink),
        title: Text(notes.title),
        // Scrolls on short screens or with large text; short lines on PCs.
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                for (final point in notes.points)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: textTheme.bodyLarge),
                      Expanded(child: Text(point, style: textTheme.bodyLarge)),
                    ],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: Palette.ink,
              foregroundColor: Palette.mint,
              minimumSize: const Size(64, 48),
            ),
            child: Text(l10n.whatsNewOk),
          ),
        ],
      );
    },
  );
}
