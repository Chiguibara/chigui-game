import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../game/achievements.dart';
import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsForFruits, fruitMuncherFruits;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/game_frame.dart';
import '../ui/sprites.dart';
import 'catch_game.dart';
import 'game_parts.dart';
import '../ui/pet_name.dart';

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
  // Created up front: created lazily, leaving without playing would create it
  // in dispose(), when looking up the TickerMode is no longer allowed.
  late final Ticker _ticker;
  late CatchGame _game = widget.game ?? CatchGame();
  _Phase _phase = _Phase.ready;
  Duration _last = Duration.zero;
  int _reactionId = 0;
  Reaction _reaction = Reaction.chomp;

  RoundPay _pay = noPay;

  /// Arrow keys held down (on a computer), besides dragging.
  final _held = <LogicalKeyboardKey>{};

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _start() {
    sfx.play(Sfx.start);
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
      final step = _game.update(dt);
      if (step.bonks > 0) {
        _reaction = Reaction.ouch;
        _reactionId++;
        sfx.play(Sfx.bonk);
      } else if (step.caught > 0) {
        _reaction = Reaction.chomp;
        _reactionId++;
        sfx.play(Sfx.chomp);
      }
      if (_game.over) {
        _ticker.stop();
        _phase = _Phase.done;
        _pay = payRound(
          widget.controller,
          coinsForFruits(_game.caught),
          achievement: _game.bonks == 0 && _game.caught >= fruitMuncherFruits
              ? Achievement.fruitMuncher
              : null,
        );
        sfx.play(_game.caught > 0 ? Sfx.reward : Sfx.pop);
      }
    });
  }

  /// Holding an arrow key moves Chigüi that way; letting go stops them.
  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.arrowLeft &&
        key != LogicalKeyboardKey.arrowRight) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) _held.add(key);
    if (event is KeyUpEvent) _held.remove(key);
    final left = _held.contains(LogicalKeyboardKey.arrowLeft);
    final right = _held.contains(LogicalKeyboardKey.arrowRight);
    _game.aimAt(left == right ? _game.chiguiX : (left ? 0 : 1));
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MinigameScaffold(
      child: switch (_phase) {
        _Phase.ready => GameIntro(
          title: l10n.minigameTitle,
          hint: onComputerWeb
              ? '${l10n.minigameHint(l10n.petName(widget.controller.state))}\n${l10n.arrowKeysHint}'
              : l10n.minigameHint(l10n.petName(widget.controller.state)),
          start: [
            GameButton(
              icon: Icons.play_arrow,
              label: l10n.startButton,
              onPressed: _start,
            ),
          ],
        ),
        _Phase.playing => _playArea(l10n, Theme.of(context).textTheme),
        _Phase.done => RoundResult(
          name: l10n.petName(widget.controller.state),
          summary: l10n.fruitsCaught(_game.caught),
          pay: _pay,
          onPlayAgain: _start,
        ),
      },
    );
  }

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

        return Focus(
          autofocus: true,
          onKeyEvent: _onKey,
          child: GestureDetector(
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
                      reaction: _reaction,
                      reactionId: _reactionId,
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
          ),
        );
      },
    );
  }
}
