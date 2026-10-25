import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/achievements.dart';
import '../game/pet_controller.dart';
import '../game/rules.dart' show fruitMuncherFruits;
import '../l10n/app_localizations.dart';
import '../minigame/catch_game.dart' show FruitKind;
import '../sound/sound_effects.dart';
import 'game_frame.dart';
import 'palette.dart';
import 'sprites.dart';
import 'pet_name.dart';

/// Player-facing names and how to earn each achievement.
extension AchievementTexts on AppLocalizations {
  String achievementName(Achievement a) => switch (a) {
    Achievement.collector => achievementCollector,
    Achievement.fruitMuncher => achievementFruitMuncher,
    Achievement.cleanestInPond => achievementCleanestInPond,
    Achievement.capybaraEye => achievementCapybaraEye,
    Achievement.capybaraMemory => achievementCapybaraMemory,
    Achievement.mathWhiz => achievementMathWhiz,
  };

  String achievementHow(Achievement a, String name) => switch (a) {
    Achievement.collector => achievementCollectorHow,
    Achievement.fruitMuncher => achievementFruitMuncherHow(fruitMuncherFruits),
    Achievement.cleanestInPond => achievementCleanestInPondHow(name),
    Achievement.capybaraEye => achievementCapybaraEyeHow(name),
    Achievement.capybaraMemory => achievementCapybaraMemoryHow,
    Achievement.mathWhiz => achievementMathWhizHow,
  };
}

/// A gold medal on a ribbon with the achievement's picture; a pale one
/// while not earned yet.
class AchievementMedal extends StatelessWidget {
  const AchievementMedal({
    super.key,
    required this.achievement,
    this.size = 72,
    this.earned = true,
  });

  final Achievement achievement;
  final double size;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final picture = size * 0.36;
    final color = earned ? Palette.ink : Palette.ink.withValues(alpha: 0.25);
    final Widget inner = switch (achievement) {
      Achievement.fruitMuncher => Opacity(
        opacity: earned ? 1 : 0.3,
        child: FruitSprite(kind: FruitKind.watermelon, size: picture * 1.1),
      ),
      _ => Icon(
        switch (achievement) {
          Achievement.collector => Icons.auto_stories,
          Achievement.cleanestInPond => Icons.bathtub,
          Achievement.capybaraEye => Icons.visibility,
          Achievement.capybaraMemory => Icons.psychology,
          _ => Icons.calculate,
        },
        size: picture,
        color: color,
      ),
    };
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _MedalPainter(earned: earned),
        child: Align(
          // The disc's center, below the ribbon.
          alignment: const Alignment(0, 0.3),
          child: ExcludeSemantics(child: inner),
        ),
      ),
    );
  }
}

class _MedalPainter extends CustomPainter {
  _MedalPainter({required this.earned});

  final bool earned;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final pale = Palette.ink.withValues(alpha: 0.08);
    final outline = Paint()
      ..color = earned
          ? Palette.furOutline
          : Palette.ink.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeJoin = StrokeJoin.round;

    // Two ribbon tails meeting behind the disc.
    for (final (side, color) in [
      (-1.0, Palette.santaRed),
      (1.0, Palette.beanie),
    ]) {
      final tail = Path()
        ..moveTo(w * (0.5 + side * 0.32), 0)
        ..lineTo(w * (0.5 + side * 0.12), 0)
        ..lineTo(w * (0.5 - side * 0.06), w * 0.5)
        ..lineTo(w * (0.5 + side * 0.16), w * 0.5)
        ..close();
      canvas.drawPath(tail, Paint()..color = earned ? color : pale);
      canvas.drawPath(tail, outline);
    }

    final center = Offset(w * 0.5, w * 0.65);
    final r = w * 0.32;
    canvas.drawCircle(
      center,
      r,
      Paint()..color = earned ? Palette.sparkle : Palette.cloud,
    );
    canvas.drawCircle(center, r, outline);
    canvas.drawCircle(
      center,
      r * 0.78,
      Paint()
        ..color = earned
            ? Palette.coinRim.withValues(alpha: 0.6)
            : Palette.ink.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.02,
    );
    if (earned) {
      // A little shine.
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.9),
        math.pi * 1.1,
        math.pi * 0.3,
        false,
        Paint()
          ..color = Palette.cloud.withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = w * 0.03,
      );
    }
  }

  @override
  bool shouldRepaint(_MedalPainter old) => old.earned != earned;
}

/// Celebrates a newly earned achievement, e.g. after buying the last
/// sticker.
Future<void> showAchievementDialog(BuildContext context, Achievement a) {
  sfx.play(Sfx.reward);
  return showDialog<void>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      final textTheme = Theme.of(context).textTheme;
      return AlertDialog(
        icon: AchievementMedal(achievement: a, size: 96),
        title: Text(l10n.achievementUnlocked),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.achievementName(a),
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.achievementWhere,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: Palette.ink,
              foregroundColor: Palette.mint,
              minimumSize: const Size(64, 48),
            ),
            child: Text(l10n.achievementOk),
          ),
        ],
      );
    },
  );
}

/// Every achievement: earned ones shine, the rest show how to earn them.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required this.controller});

  final PetController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final earned = controller.state.achievements;
    return Scaffold(
      backgroundColor: Palette.outside,
      body: GameFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        tooltip: l10n.albumButton,
                        color: Palette.ink,
                        iconSize: 28,
                      ),
                      Expanded(
                        child: Text(
                          l10n.achievementsTitle,
                          style: textTheme.titleLarge?.copyWith(
                            color: Palette.ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        l10n.achievementsCount(
                          earned.length,
                          Achievement.values.length,
                        ),
                        style: textTheme.titleMedium?.copyWith(
                          color: Palette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final a in Achievement.values)
                          _card(a, earned.contains(a), l10n, textTheme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(
    Achievement a,
    bool earned,
    AppLocalizations l10n,
    TextTheme textTheme,
  ) => Container(
    width: 320,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: earned ? Palette.cloud : Palette.cloud.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Palette.ink.withValues(alpha: 0.15), width: 2),
    ),
    child: Row(
      children: [
        AchievementMedal(achievement: a, earned: earned),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.achievementName(a),
                style: textTheme.titleMedium?.copyWith(
                  color: Palette.ink.withValues(alpha: earned ? 1 : 0.6),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.achievementHow(a, l10n.petName(controller.state)),
                style: textTheme.bodyMedium?.copyWith(color: Palette.ink),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
