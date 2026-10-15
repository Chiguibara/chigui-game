import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../l10n/app_localizations.dart';
import '../ui/game_frame.dart';
import '../ui/palette.dart';
import '../ui/sprites.dart';

/// What a finished round gave: coins can be fewer than it was worth when the
/// daily limit is reached.
typedef RoundPay = ({int earned, bool piggyBankFull});

/// Ends a round worth [coins]: Chigüi has more fun and gets the coins the
/// daily limit (shared by all minigames) still allows.
RoundPay payRound(PetController pet, int coins) {
  final earned = math.min(coins, math.max(0, pet.minigameCoinsLeft));
  pet.finishRound(coins);
  return (earned: earned, piggyBankFull: earned < coins);
}

/// The mint play area every minigame screen sits on.
class MinigameScaffold extends StatelessWidget {
  const MinigameScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Palette.outside,
    body: GameFrame(
      child: ColoredBox(
        color: Palette.mint,
        child: SafeArea(child: child),
      ),
    ),
  );
}

/// A centered column, for a minigame's intro and results.
class GameMenu extends StatelessWidget {
  const GameMenu({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    ),
  );
}

class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
    style: FilledButton.styleFrom(
      backgroundColor: Palette.ink,
      foregroundColor: Palette.mint,
      minimumSize: const Size(180, 52),
    ),
  );
}

/// A quiet text button, e.g. to go back.
class GameTextButton extends StatelessWidget {
  const GameTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Palette.ink,
      minimumSize: const Size(120, 48),
    ),
    child: Text(label),
  );
}

/// A minigame's title, how to play, and how to start.
class GameIntro extends StatelessWidget {
  const GameIntro({
    super.key,
    required this.title,
    required this.hint,
    required this.start,
  });

  final String title;
  final String hint;

  /// The start button, or several (e.g. one per board size).
  final List<Widget> start;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return GameMenu(
      children: [
        Text(title, style: gameTitleStyle(textTheme)),
        const SizedBox(height: 16),
        Text(hint, textAlign: TextAlign.center, style: textTheme.titleMedium),
        const SizedBox(height: 32),
        ...start,
        const SizedBox(height: 12),
        GameTextButton(
          label: l10n.otherGamesButton,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// The results: what the round was about, the coins, and what next.
class RoundResult extends StatelessWidget {
  const RoundResult({
    super.key,
    required this.summary,
    required this.pay,
    required this.onPlayAgain,
  });

  final String summary;
  final RoundPay pay;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final navigator = Navigator.of(context);
    return GameMenu(
      children: [
        Text(l10n.roundDone, style: gameTitleStyle(textTheme)),
        const SizedBox(height: 16),
        Text(
          summary,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pay.earned > 0) ...[
              const Coin(size: 28),
              const SizedBox(width: 8),
            ],
            Text(l10n.coinsEarned(pay.earned), style: textTheme.titleMedium),
          ],
        ),
        if (pay.piggyBankFull) ...[
          const SizedBox(height: 12),
          Text(
            l10n.piggyBankFull,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
        ],
        const SizedBox(height: 32),
        GameButton(
          icon: Icons.replay,
          label: l10n.playAgainButton,
          onPressed: onPlayAgain,
        ),
        const SizedBox(height: 12),
        GameTextButton(label: l10n.otherGamesButton, onPressed: navigator.pop),
        GameTextButton(
          label: l10n.backHomeButton,
          onPressed: () => navigator.popUntil((route) => route.isFirst),
        ),
      ],
    );
  }
}

TextStyle? gameTitleStyle(TextTheme textTheme) => textTheme.headlineMedium
    ?.copyWith(color: Palette.ink, fontWeight: FontWeight.w700);
