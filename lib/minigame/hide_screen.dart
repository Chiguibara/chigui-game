import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsPerFind;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/sprites.dart';
import 'game_parts.dart';
import 'hide_game.dart';

enum _Phase { ready, playing, done }

/// Within a turn: Chigüi shows where they hide, the boxes come down, swap
/// places, the player picks one, and it is lifted.
enum _Step { show, cover, swap, pick, reveal }

/// "Hide and seek": find Chigüi under the boxes, five turns a round.
class HideScreen extends StatefulWidget {
  const HideScreen({super.key, required this.controller, this.random});

  final PetController controller;

  /// For tests: hides Chigüi and swaps the boxes in a fixed order.
  final math.Random? random;

  @override
  State<HideScreen> createState() => _HideScreenState();
}

class _HideScreenState extends State<HideScreen> with TickerProviderStateMixin {
  // Created up front: created lazily, leaving without playing would create it
  // in dispose(), when looking up the TickerMode is no longer allowed.
  late final AnimationController _anim;

  /// Chigüi's box trembling, the hint after [hideHintAfter] without a find.
  late final AnimationController _tremble;
  Timer? _hintTimer;
  bool _hint = false;
  _Phase _phase = _Phase.ready;
  _Step _step = _Step.show;
  late HideGame _game;
  (int, int)? _swap;

  /// Boxes lifted in the reveal, in order: the one picked, then Chigüi's if
  /// it was another.
  var _revealed = <int>[];
  bool _right = false;
  int _reactionId = 0;
  RoundPay _pay = (earned: 0, piggyBankFull: false);

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this);
    _tremble = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _tremble.dispose();
    _anim.dispose();
    super.dispose();
  }

  /// Runs [_anim] once; false if the screen went away meanwhile.
  Future<bool> _animate(Duration duration) async {
    _anim.duration = duration;
    try {
      await _anim.forward(from: 0).orCancel;
    } on TickerCanceled {
      return false;
    }
    return mounted;
  }

  Future<bool> _wait(Duration duration) async {
    await Future<void>.delayed(duration);
    return mounted;
  }

  void _start() {
    sfx.play(Sfx.start);
    setState(() {
      _game = HideGame(random: widget.random);
      _phase = _Phase.playing;
    });
    // The clock runs from the first round, across rounds, until a find.
    if (_hintTimer == null) _restartHintClock();
    _turn();
  }

  void _restartHintClock() {
    _hintTimer?.cancel();
    _hint = false;
    _hintTimer = Timer(hideHintAfter, () {
      if (!mounted) return;
      _hint = true;
      _updateTremble();
    });
  }

  /// Chigüi's box trembles only while the player picks, once the hint is due.
  void _updateTremble() {
    if (_hint && _phase == _Phase.playing && _step == _Step.pick) {
      if (!_tremble.isAnimating) _tremble.repeat();
    } else {
      _tremble.reset();
    }
  }

  Future<void> _turn() async {
    _game.startTurn();
    setState(() {
      _step = _Step.show;
      _revealed = [];
    });
    if (!await _animate(const Duration(milliseconds: 900))) return;
    sfx.play(Sfx.pop);
    setState(() => _step = _Step.cover);
    if (!await _animate(const Duration(milliseconds: 300))) return;
    for (final (i, swap) in _game.swaps.indexed) {
      sfx.play(i.isEven ? Sfx.stepLeft : Sfx.stepRight);
      setState(() {
        _step = _Step.swap;
        _swap = swap;
      });
      if (!await _animate(_game.swapTimes[i])) return;
      _game.swap(swap);
    }
    setState(() {
      _step = _Step.pick;
      _swap = null;
    });
    _updateTremble();
  }

  Future<void> _pick(int box) async {
    if (_step != _Step.pick) return;
    final right = _game.guess(box);
    sfx.play(Sfx.pop);
    setState(() {
      _step = _Step.reveal;
      _revealed = [box];
      _right = right;
    });
    _updateTremble();
    if (right) _restartHintClock();
    if (!await _animate(const Duration(milliseconds: 400))) return;
    if (right) {
      sfx.play(Sfx.sparkle);
      setState(() => _reactionId++);
    } else {
      // Not there: Chigüi pops out of the right box, giggling.
      setState(() => _revealed = [box, _game.chiguiBox]);
      if (!await _animate(const Duration(milliseconds: 400))) return;
      sfx.play(Sfx.pet);
    }
    if (!await _wait(const Duration(milliseconds: 1200))) return;
    if (!_game.over) {
      _turn();
      return;
    }
    sfx.play(Sfx.reward);
    setState(() {
      _pay = payRound(widget.controller, _game.found * coinsPerFind);
      _phase = _Phase.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MinigameScaffold(
      child: switch (_phase) {
        _Phase.ready => GameIntro(
          title: l10n.hideTitle,
          hint: l10n.hideHint,
          start: [
            GameButton(
              icon: Icons.play_arrow,
              label: l10n.startButton,
              onPressed: _start,
            ),
          ],
        ),
        _Phase.playing => AnimatedBuilder(
          animation: Listenable.merge([_anim, _tremble]),
          builder: (context, _) => _playArea(l10n),
        ),
        _Phase.done => RoundResult(
          summary: l10n.timesFound(_game.found),
          pay: _pay,
          onPlayAgain: _start,
        ),
      },
    );
  }

  String _status(AppLocalizations l10n) => switch (_step) {
    _Step.show || _Step.cover || _Step.swap => l10n.hideWatch,
    _Step.pick => l10n.hidePick,
    _Step.reveal => _right ? l10n.hideFound : l10n.hideMissed,
  };

  /// How far [box] is lifted, from 0 (down, hiding) to 1 (up).
  double _lift(int box) {
    final t = _anim.value;
    switch (_step) {
      case _Step.show:
        return 1;
      case _Step.cover:
        return 1 - Curves.easeIn.transform(t);
      case _Step.swap || _Step.pick:
        return 0;
      case _Step.reveal:
        final i = _revealed.indexOf(box);
        if (i < 0) return 0;
        return i == _revealed.length - 1 ? Curves.easeOut.transform(t) : 1;
    }
  }

  /// A short, tiny wobble now and then, as if Chigüi shifted inside.
  double _trembleAngle(int box) {
    if (box != _game.chiguiBox || !_tremble.isAnimating) return 0;
    const wobble = 0.3; // of each cycle; the rest is still
    final t = _tremble.value / wobble;
    if (t >= 1) return 0;
    return math.sin(t * math.pi * 4) * (1 - t) * 0.03;
  }

  Widget _playArea(AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '${math.min(_game.turn + 1, hideTurns)} / $hideTurns',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Semantics(
            liveRegion: true,
            child: Text(
              _status(l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: textTheme.titleLarge,
            ),
          ),
          Expanded(child: LayoutBuilder(builder: _boxes)),
        ],
      ),
    );
  }

  Widget _boxes(BuildContext context, BoxConstraints constraints) {
    final l10n = AppLocalizations.of(context);
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final boxSize = math.min(w / hideBoxes * 0.85, h * 0.4);
    final boxHeight = boxSize * HidingBox.aspect;
    final chiguiSize = boxSize * 0.8;
    final ground = h * 0.7;
    double slotX(int slot) => w * (slot + 0.5) / hideBoxes;

    // Where [box] is now, swapping along a little arc (one above, one below).
    Offset place(int box) {
      final swap = _swap;
      final from = slotX(_game.slotOf[box]);
      if (_step != _Step.swap || swap == null) return Offset(from, 0);
      final (a, b) = swap;
      if (box != a && box != b) return Offset(from, 0);
      final other = box == a ? b : a;
      final t = Curves.easeInOut.transform(_anim.value);
      final arc = math.sin(t * math.pi) * boxHeight * 0.25;
      return Offset(
        from + (slotX(_game.slotOf[other]) - from) * t,
        box == a ? -arc : arc * 0.5,
      );
    }

    final chigui = place(_game.chiguiBox);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Chigüi waits under their box, seen only while it is lifted.
        Positioned(
          left: chigui.dx - chiguiSize / 2,
          // A little above the ground, so the box hides even the shadow.
          top: ground + chigui.dy - chiguiSize * 1.05,
          child: IgnorePointer(
            child: ChiguiView(
              size: chiguiSize,
              face: _step == _Step.reveal && !_right ? Face.happy : Face.normal,
              reaction: Reaction.love,
              reactionId: _reactionId,
            ),
          ),
        ),
        for (var box = 0; box < hideBoxes; box++)
          () {
            final at = place(box);
            return Positioned(
              key: ValueKey('box-$box'),
              left: at.dx - boxSize / 2,
              top: ground + at.dy - boxHeight - _lift(box) * boxHeight * 0.9,
              child: Semantics(
                button: _step == _Step.pick,
                label: l10n.hideBox(_game.slotOf[box] + 1),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _pick(box),
                  child: Transform.rotate(
                    angle: _trembleAngle(box),
                    alignment: Alignment.bottomCenter,
                    child: HidingBox(size: boxSize),
                  ),
                ),
              ),
            );
          }(),
      ],
    );
  }
}
