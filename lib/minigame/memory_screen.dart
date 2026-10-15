import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsPerPair;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import '../ui/sprites.dart';
import 'catch_game.dart' show FruitKind;
import 'game_parts.dart';
import 'memory_game.dart';

enum _Phase { ready, playing, done }

/// "Memory": find the pairs of fruit cards, on a board of the chosen size.
class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key, required this.controller, this.random});

  final PetController controller;

  /// For tests: deals the cards in a fixed order.
  final math.Random? random;

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  _Phase _phase = _Phase.ready;
  late MemoryGame _game;
  int _pairs = memoryBoards.first;
  Timer? _hideMiss;
  int _reactionId = 0;
  RoundPay _pay = (earned: 0, piggyBankFull: false);

  @override
  void dispose() {
    _hideMiss?.cancel();
    super.dispose();
  }

  void _start(int pairs) {
    sfx.play(Sfx.start);
    _hideMiss?.cancel();
    setState(() {
      _pairs = pairs;
      _game = MemoryGame(pairs: pairs, random: widget.random);
      _phase = _Phase.playing;
    });
  }

  void _flip(int card) {
    final result = _game.flip(card);
    if (result == Flip.ignored) return;
    setState(() {});
    switch (result) {
      case Flip.first:
        sfx.play(Sfx.pop);
      case Flip.match:
        sfx.play(Sfx.sparkle);
        setState(() => _reactionId++);
        if (_game.over) _finish();
      case Flip.miss:
        sfx.play(Sfx.pop);
        _hideMiss = Timer(memoryMissShown, () {
          if (mounted) setState(_game.hideMiss);
        });
      case Flip.ignored:
    }
  }

  Future<void> _finish() async {
    // A moment to enjoy the last pair before the results.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    sfx.play(Sfx.reward);
    setState(() {
      _pay = payRound(widget.controller, _game.pairsFound * coinsPerPair);
      _phase = _Phase.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MinigameScaffold(
      child: switch (_phase) {
        _Phase.ready => GameIntro(
          title: l10n.memoryTitle,
          hint: l10n.memoryHint,
          start: [
            for (final pairs in memoryBoards) ...[
              GameButton(
                icon: Icons.grid_view_rounded,
                label: l10n.cardsCount(pairs * 2),
                onPressed: () => _start(pairs),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
        _Phase.playing => _board(l10n),
        _Phase.done => RoundResult(
          summary: l10n.pairsFound(_game.pairsFound),
          pay: _pay,
          onPlayAgain: () => _start(_pairs),
        ),
      },
    );
  }

  Widget _board(AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ChiguiView(
                size: 72,
                reaction: Reaction.love,
                reactionId: _reactionId,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    '${_game.pairsFound} / ${_game.pairs}',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final (columns, side) = _grid(
                  _game.cards.length,
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                // Exactly as wide as the columns, so rows break there.
                return Center(
                  child: SizedBox(
                    width: columns * side + 0.5,
                    child: Wrap(
                      children: [
                        for (var i = 0; i < _game.cards.length; i++)
                          SizedBox.square(
                            dimension: side,
                            child: Padding(
                              padding: EdgeInsets.all(side * 0.06),
                              child: _Card(
                                key: ValueKey('card-$i'),
                                kind: _game.cards[i],
                                faceUp: _game.isFaceUp(i),
                                matched: _game.isMatched(i),
                                label: l10n.memoryCard,
                                onTap: () => _flip(i),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// The number of columns that gives the largest square cards in [w]×[h],
  /// keeping the board roughly square (4×4, not 2×8).
  static (int, double) _grid(int cards, double w, double h) {
    var best = (cards, 0.0);
    for (var columns = 1; columns <= cards; columns++) {
      if (cards % columns != 0) continue;
      final rows = cards ~/ columns;
      if (math.max(rows, columns) > 2 * math.min(rows, columns)) continue;
      final side = math.min(w / columns, h / rows);
      if (side > best.$2) best = (columns, side);
    }
    return best;
  }
}

/// A card that turns over: a mint back with a "?" or a fruit face.
class _Card extends StatelessWidget {
  const _Card({
    super.key,
    required this.kind,
    required this.faceUp,
    required this.matched,
    required this.label,
    required this.onTap,
  });

  final FruitKind kind;
  final bool faceUp;
  final bool matched;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: !faceUp,
    label: label,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: faceUp ? 1 : 0),
        duration: const Duration(milliseconds: 250),
        builder: (context, turn, _) {
          final front = turn >= 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY((front ? turn - 1 : turn) * math.pi),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final side = constraints.biggest.shortestSide;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: front ? Palette.cloud : Palette.ink,
                    borderRadius: BorderRadius.circular(side * 0.18),
                    border: Border.all(
                      color: matched ? Palette.leaf : Palette.ink,
                      width: side * 0.05,
                    ),
                  ),
                  child: Center(
                    child: front
                        ? ExcludeSemantics(
                            child: FruitSprite(kind: kind, size: side * 0.62),
                          )
                        : Icon(
                            Icons.question_mark_rounded,
                            color: Palette.mint,
                            size: side * 0.45,
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
