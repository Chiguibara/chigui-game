import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/achievements.dart';
import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsForMath, mathCoinsPerRound;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import '../ui/sprites.dart';
import 'game_parts.dart';
import 'math_game.dart';
import '../ui/pet_name.dart';

enum _Phase { ready, playing, done }

/// How long a right answer shows before the next question.
const _nextAfter = Duration(milliseconds: 900);

/// "Maths class": made-up questions of the chosen level, answered by
/// tapping one of the bubbles while Chigüi studies along.
class MathScreen extends StatefulWidget {
  const MathScreen({super.key, required this.controller, this.random});

  final PetController controller;

  /// For tests: makes up the same questions every time.
  final math.Random? random;

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  _Phase _phase = _Phase.ready;
  late MathRound _round;
  Timer? _next;
  int _reactionId = 0;
  bool _missed = false;
  RoundPay _pay = noPay;

  @override
  void dispose() {
    _next?.cancel();
    super.dispose();
  }

  void _start(MathLevel level) {
    sfx.play(Sfx.start);
    _next?.cancel();
    setState(() {
      _round = MathRound(level, random: widget.random);
      _missed = false;
      _phase = _Phase.playing;
    });
  }

  void _pick(Value value) {
    switch (_round.pick(value)) {
      case Pick.right:
        sfx.play(Sfx.sparkle);
        setState(() {
          _missed = false;
          _reactionId++;
        });
        _next = Timer(_nextAfter, _round.over ? _finish : _nextQuestion);
      case Pick.wrong:
        sfx.play(Sfx.pop);
        setState(() => _missed = true);
      case Pick.ignored:
    }
  }

  void _nextQuestion() {
    if (mounted) setState(_round.next);
  }

  void _finish() {
    if (!mounted) return;
    sfx.play(Sfx.reward);
    setState(() {
      _pay = payRound(
        widget.controller,
        coinsForMath(
          _round.level.index,
          _round.rightFirstTime,
          mathQuestions,
        ),
        achievement: _round.rightFirstTime == mathQuestions
            ? Achievement.mathWhiz
            : null,
      );
      _phase = _Phase.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MinigameScaffold(
      child: switch (_phase) {
        _Phase.ready => GameIntro(
          title: l10n.mathTitle,
          hint: l10n.mathHint(l10n.petName(widget.controller.state)),
          start: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final level in MathLevel.values)
                  _LevelButton(
                    label: _levelName(l10n, level),
                    coins: mathCoinsPerRound[level.index],
                    onPressed: () => _start(level),
                  ),
              ],
            ),
          ],
        ),
        _Phase.playing => _question(l10n),
        _Phase.done => RoundResult(
          name: l10n.petName(widget.controller.state),
          summary: l10n.mathRightFirstTime(
            _round.rightFirstTime,
            mathQuestions,
          ),
          pay: _pay,
          onPlayAgain: () => _start(_round.level),
        ),
      },
    );
  }

  Widget _question(AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final problem = _round.problem;
    final big = textTheme.displaySmall?.copyWith(
      color: Palette.ink,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ChiguiView(
                size: 96,
                studying: true,
                reaction: Reaction.study,
                reactionId: _reactionId,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_round.question + 1} / $mathQuestions',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      liveRegion: true,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          problem.asksForX
                              ? mathText(problem, l10n)
                              : '${mathText(problem, l10n)} = ?',
                          style: big,
                        ),
                      ),
                    ),
                    if (problem.asksForX) Text('x = ?', style: big),
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final option in problem.options)
                          _AnswerBubble(
                            key: ValueKey('answer-$option'),
                            label: format(
                              option,
                              decimalPoint: l10n.mathDecimalPoint,
                            ),
                            tried: _round.tried.contains(option),
                            right: _round.solved && option == problem.answer,
                            onTap: () => _pick(option),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Keeps its height so the bubbles stay put.
                    Text(
                      _missed ? l10n.mathTryAgain : '',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _levelName(AppLocalizations l10n, MathLevel level) => switch (level) {
  MathLevel.sums => l10n.mathLevelSums,
  MathLevel.upTo20 => l10n.mathLevelUpTo20,
  MathLevel.upTo100 => l10n.mathLevelUpTo100,
  MathLevel.tables => l10n.mathLevelTables,
  MathLevel.multiplyDivide => l10n.mathLevelMultiplyDivide,
  MathLevel.fractions => l10n.mathLevelFractions,
  MathLevel.integers => l10n.mathLevelIntegers,
  MathLevel.equations => l10n.mathLevelEquations,
};

const _superscripts = '⁰¹²³⁴⁵⁶⁷⁸⁹';

/// [problem]'s question as written at school in the player's language, e.g.
/// "12 − (−3)", "3/4 de 20", "2x + 5 = 11".
String mathText(MathProblem problem, AppLocalizations l10n) {
  String number(Value value) =>
      format(value, decimalPoint: l10n.mathDecimalPoint);
  final out = StringBuffer();
  Term? previous;
  for (final term in problem.terms) {
    final tight =
        previous == null ||
        (previous is Sym && previous.op == Op.open) ||
        (term is Sym && term.op == Op.close);
    if (!tight) out.write(' ');
    // A negative number after an operation goes in brackets.
    final bracket =
        previous is Sym && previous.op != Op.equals && previous.op != Op.open;
    out.write(switch (term) {
      Num(:final value, :final power) =>
        (value.isNegative && bracket ? '(${number(value)})' : number(value)) +
            (power == null
                ? ''
                : [
                    for (final d in '$power'.split(''))
                      _superscripts[int.parse(d)],
                  ].join()),
      Root(:final radicand) => '√$radicand',
      Percent(:final percent) => l10n.mathPercent(percent),
      Unknown(:final coefficient) => switch (coefficient) {
        1 => 'x',
        -1 => '−x',
        _ => '${number(Value(coefficient))}x',
      },
      Sym(:final op) => switch (op) {
        Op.plus => '+',
        Op.minus => '−',
        Op.times => l10n.mathTimes,
        Op.divide => l10n.mathDivide,
        Op.equals => '=',
        Op.open => '(',
        Op.close => ')',
        Op.of => l10n.mathOf,
      },
    });
    previous = term;
  }
  return out.toString();
}

/// A level to start, with the coins a round all right gives.
class _LevelButton extends StatelessWidget {
  const _LevelButton({
    required this.label,
    required this.coins,
    required this.onPressed,
  });

  final String label;
  final int coins;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Palette.ink,
        foregroundColor: Palette.mint,
        minimumSize: const Size(180, 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 8),
          for (var i = 0; i < coins; i++)
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Coin(size: 18),
            ),
        ],
      ),
    ),
  );
}

/// One answer to pick: it fades once tried, and turns green when right.
class _AnswerBubble extends StatelessWidget {
  const _AnswerBubble({
    super.key,
    required this.label,
    required this.tried,
    required this.right,
    required this.onTap,
  });

  final String label;
  final bool tried;
  final bool right;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: const Duration(milliseconds: 200),
    opacity: tried ? 0.35 : 1,
    child: Material(
      color: right ? Palette.leaf : Palette.cloud,
      shape: const StadiumBorder(
        side: BorderSide(color: Palette.ink, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: tried ? null : onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 88, minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Palette.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
