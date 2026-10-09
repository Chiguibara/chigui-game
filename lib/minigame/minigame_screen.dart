import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsPerFruit;
import '../l10n/app_localizations.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import '../ui/game_frame.dart';
import '../ui/sprites.dart';
import 'catch_game.dart';

enum _Phase { ready, playing, done }

/// "Fruit catch": a 30-second round that raises fun and earns coins.
class MinigameScreen extends StatefulWidget {
  const MinigameScreen({super.key, required this.controller, this.game});

  final PetController controller;

  /// For tests: a game with a fixed random seed.
  final CatchGame? game;

  @override
  State<MinigameScreen> createState() => _MinigameScreenState();
}

class _MinigameScreenState extends State<MinigameScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  late CatchGame _game = widget.game ?? CatchGame();
  _Phase _phase = _Phase.ready;
  Duration _last = Duration.zero;
  int _catchId = 0;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      if (_phase == _Phase.done) _game = CatchGame();
      _phase = _Phase.playing;
      _last = Duration.zero;
    });
    _ticker.start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    setState(() {
      if (_game.update(dt) > 0) _catchId++;
      if (_game.over) {
        _ticker.stop();
        _phase = _Phase.done;
        widget.controller.finishRound(_game.caught);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final title = textTheme.headlineMedium?.copyWith(
      color: Palette.ink,
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      backgroundColor: Palette.outside,
      body: GameFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: switch (_phase) {
              _Phase.ready => _menu(
                children: [
                  Text(l10n.minigameTitle, style: title),
                  const SizedBox(height: 16),
                  Text(
                    l10n.minigameHint,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  _button(Icons.play_arrow, l10n.startButton, _start),
                  const SizedBox(height: 12),
                  _backButton(l10n),
                ],
              ),
              _Phase.playing => _playArea(l10n, textTheme),
              _Phase.done => _menu(
                children: [
                  Text(l10n.roundDone, style: title),
                  const SizedBox(height: 16),
                  Text(
                    l10n.fruitsCaught(_game.caught),
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_game.caught > 0) ...[
                        const Coin(size: 28),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        l10n.coinsEarned(_game.caught * coinsPerFruit),
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _button(Icons.replay, l10n.playAgainButton, _start),
                  const SizedBox(height: 12),
                  _backButton(l10n),
                ],
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _menu({required List<Widget> children}) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    ),
  );

  Widget _button(IconData icon, String label, VoidCallback onPressed) =>
      FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: Palette.ink,
          foregroundColor: Palette.mint,
          minimumSize: const Size(180, 52),
        ),
      );

  Widget _backButton(AppLocalizations l10n) => TextButton(
    onPressed: () => Navigator.of(context).pop(),
    style: TextButton.styleFrom(
      foregroundColor: Palette.ink,
      minimumSize: const Size(120, 48),
    ),
    child: Text(l10n.backHomeButton),
  );

  Widget _playArea(AppLocalizations l10n, TextTheme textTheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        // Sized by the shorter side so wide screens don't get giant fruit.
        final side = math.min(w, h);
        final fruitSize = side * 0.12;
        // Chigüi must also fit below the catch line (its head sits on it).
        final chiguiSize = math.min(side * 0.32, h * (1 - catchLine) / 0.68);
        _game.reach = chiguiSize * 0.4 / w;
        void aim(Offset p) => _game.aimAt(p.dx / w);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (d) => aim(d.localPosition),
          onPanUpdate: (d) => aim(d.localPosition),
          child: Stack(
            children: [
              // Keys keep Chigüi's state (and its chomp animation) when
              // caught fruit leaves the list.
              for (final fruit in _game.fruits)
                Positioned(
                  key: ObjectKey(fruit),
                  left: fruit.x * w - fruitSize / 2,
                  top: fruit.y * h - fruitSize / 2,
                  child: ExcludeSemantics(
                    child: FruitSprite(kind: fruit.kind, size: fruitSize),
                  ),
                ),
              Positioned(
                key: const ValueKey('chigui'),
                left: _game.chiguiX * w - chiguiSize / 2,
                top: catchLine * h - chiguiSize * 0.35,
                child: IgnorePointer(
                  child: ChiguiView(
                    size: chiguiSize,
                    reaction: Reaction.chomp,
                    reactionId: _catchId,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      liveRegion: true,
                      label: l10n.fruitsCaught(_game.caught),
                      excludeSemantics: true,
                      child: Row(
                        children: [
                          const FruitSprite(
                            kind: FruitKind.watermelon,
                            size: 28,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_game.caught}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      l10n.secondsLeft(_game.timeLeft.ceil()),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
