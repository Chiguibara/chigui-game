import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../l10n/app_localizations.dart';
import '../ui/bath_art.dart';
import '../ui/game_frame.dart';
import '../ui/palette.dart';
import '../ui/sprites.dart';
import 'bath_screen.dart';
import 'catch_game.dart' show FruitKind;
import 'game_parts.dart';
import 'hide_screen.dart';
import 'memory_screen.dart';
import 'minigame_screen.dart';

/// Picks a minigame: big cards in a column on phones, in rows on wide
/// screens.
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key, required this.controller});

  final PetController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));

    final games = [
      (
        l10n.minigameTitle,
        const FruitSprite(kind: FruitKind.watermelon, size: 56),
        () => open(MinigameScreen(controller: controller)),
      ),
      (
        l10n.memoryTitle,
        const _CardsIcon(),
        () => open(MemoryScreen(controller: controller)),
      ),
      (
        l10n.hideTitle,
        const HidingBox(size: 60),
        () => open(HideScreen(controller: controller)),
      ),
      (
        l10n.bathTitle,
        const _TubIcon(),
        () => open(BathScreen(controller: controller)),
      ),
    ];

    return MinigameScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = isWide(constraints);
          final cards = [
            for (final (title, picture, onTap) in games)
              _GameCard(title: title, picture: picture, onTap: onTap),
          ];
          return GameMenu(
            children: [
              Text(l10n.gamesTitle, style: gameTitleStyle(textTheme)),
              const SizedBox(height: 24),
              if (wide)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final card in cards) SizedBox(width: 240, child: card),
                  ],
                )
              else
                SizedBox(
                  width: 300,
                  child: Column(spacing: 12, children: cards),
                ),
              const SizedBox(height: 16),
              GameTextButton(
                label: l10n.backHomeButton,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.title,
    required this.picture,
    required this.onTap,
  });

  final String title;
  final Widget picture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Palette.ink,
    borderRadius: BorderRadius.circular(20),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 64,
              child: Center(child: ExcludeSemantics(child: picture)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Palette.mint,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The bath's hinoki tub with a yuzu floating.
class _TubIcon extends StatelessWidget {
  const _TubIcon();

  @override
  Widget build(BuildContext context) => const Stack(
    children: [
      HinokiTub(part: TubPart.back, width: 60),
      HinokiTub(part: TubPart.front, width: 60, yuzus: 2),
    ],
  );
}

/// Two memory cards, one face down and one showing a fruit.
class _CardsIcon extends StatelessWidget {
  const _CardsIcon();

  @override
  Widget build(BuildContext context) {
    Widget card(Color color, Widget child, double angle) => Transform.rotate(
      angle: angle,
      child: Container(
        width: 34,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Palette.mint, width: 2),
        ),
        child: Center(child: child),
      ),
    );
    return SizedBox(
      width: 60,
      height: 56,
      child: Stack(
        children: [
          Positioned(
            left: 2,
            top: 4,
            child: card(
              Palette.ink,
              const Icon(Icons.question_mark_rounded, color: Palette.mint),
              -0.2,
            ),
          ),
          Positioned(
            right: 2,
            top: 6,
            child: card(
              Palette.cloud,
              const FruitSprite(kind: FruitKind.orange, size: 24),
              0.15,
            ),
          ),
        ],
      ),
    );
  }
}
