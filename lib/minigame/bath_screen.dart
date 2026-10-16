import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart' show coinsForSpots;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/bath_art.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import 'bath_game.dart';
import 'game_parts.dart';

enum _Phase { ready, playing, done }

/// How Chigüi is moving: running in, hopping into or out of the tub, or
/// sitting still where [_BathScreenState._inTub] says.
enum _Move { run, hopIn, hopOut, none }

/// "Bath time": Chigüi runs in covered in tar and gravel, hops into the
/// hinoki tub, and the player picks tools to clean every sticky spot.
class BathScreen extends StatefulWidget {
  const BathScreen({super.key, required this.controller, this.random});

  final PetController controller;

  /// For tests: places the spots in a fixed order.
  final math.Random? random;

  @override
  State<BathScreen> createState() => _BathScreenState();
}

class _BathScreenState extends State<BathScreen> with TickerProviderStateMixin {
  // Created up front: created lazily, leaving without playing would create
  // them in dispose(), when looking up the TickerMode is no longer allowed.
  late final AnimationController _move;

  /// Loops for drips, steam, bobbing yuzus, and the hint hop.
  late final AnimationController _loop;
  _Phase _phase = _Phase.ready;
  late BathGame _game;

  /// Baths given in a row on this visit; each one is a bit dirtier.
  int _baths = 0;
  _Move _moving = _Move.none;
  bool _inTub = false;
  BathTool? _tool;

  /// Where the finger last used a tool, in the stage, for a moment.
  Offset? _touch;
  Timer? _touchTimer;
  double _rubbed = 0;
  bool _hintedThisRub = false;
  bool _hint = false;
  Timer? _hintTimer;
  Reaction? _reaction;
  int _reactionId = 0;
  RoundPay _pay = (earned: 0, piggyBankFull: false);

  /// Chigüi's square in the stage, from the last layout.
  Rect _chigui = Rect.zero;

  @override
  void initState() {
    super.initState();
    _move = AnimationController(vsync: this);
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLoop();
  }

  @override
  void dispose() {
    _touchTimer?.cancel();
    _hintTimer?.cancel();
    _move.dispose();
    _loop.dispose();
    super.dispose();
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  /// The loop runs only while playing, and not with reduced motion.
  void _updateLoop() {
    if (_phase != _Phase.playing || _reduceMotion) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  /// Runs [_move] once; false if the screen went away meanwhile.
  Future<bool> _animate(_Move move, Duration duration) async {
    setState(() => _moving = move);
    _move.duration = _reduceMotion ? Duration.zero : duration;
    try {
      await _move.forward(from: 0).orCancel;
    } on TickerCanceled {
      return false;
    }
    if (!mounted) return false;
    setState(() => _moving = _Move.none);
    return true;
  }

  Future<bool> _wait(Duration duration) async {
    await Future<void>.delayed(duration);
    return mounted;
  }

  void _react(Reaction reaction) {
    _reaction = reaction;
    _reactionId++;
  }

  Future<void> _start() async {
    sfx.play(Sfx.start);
    setState(() {
      _game = BathGame(bath: _baths, random: widget.random);
      _phase = _Phase.playing;
      _inTub = false;
      _tool = null;
      _hint = false;
    });
    _updateLoop();
    // Chigüi's view is new, so the run starts on the next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _react(Reaction.walk));
    });
    _restartHintClock();
    await _animate(_Move.run, const Duration(milliseconds: 1500));
  }

  /// Any progress puts the hint away and restarts its clock.
  void _restartHintClock() {
    _hintTimer?.cancel();
    _hint = false;
    _hintTimer = Timer(bathHintAfter, () {
      if (mounted) setState(() => _hint = true);
    });
  }

  Future<void> _hopIn() async {
    if (!await _animate(_Move.hopIn, const Duration(milliseconds: 700))) {
      return;
    }
    sfx.play(Sfx.splash);
    setState(() {
      _inTub = true;
      _game.hopIn();
    });
    _restartHintClock();
  }

  Future<void> _soak() async {
    setState(() => _react(Reaction.love));
    if (!await _wait(const Duration(milliseconds: 2200))) return;
    if (!await _animate(_Move.hopOut, const Duration(milliseconds: 700))) {
      return;
    }
    sfx.play(Sfx.splash);
    setState(() {
      _inTub = false;
      _game.hopOut();
      _tool = null;
    });
    _restartHintClock();
  }

  Future<void> _finish() async {
    sfx.play(Sfx.sparkle);
    _hintTimer?.cancel();
    setState(() => _react(Reaction.cleaned));
    if (!await _wait(const Duration(milliseconds: 1400))) return;
    sfx.play(Sfx.reward);
    setState(() {
      _pay = payRound(widget.controller, coinsForSpots(_game.spots.length));
      _baths++;
      _phase = _Phase.done;
    });
    _updateLoop();
  }

  void _pickTool(BathTool tool) {
    sfx.play(Sfx.pop);
    setState(() => _tool = tool);
  }

  /// A touch on the stage at [at]: a tap, or a rub of [rub] canvas widths.
  void _use(Offset at, {double rub = 0}) {
    if (_moving != _Move.none) return;
    if (_game.stage == BathStage.arrive) {
      if (rub == 0) _hopIn();
      return;
    }
    final tool = _tool;
    if (tool == null) {
      if (rub == 0 || !_hintedThisRub) setState(() => _hint = true);
      _hintedThisRub = true;
      return;
    }
    final x = (at.dx - _chigui.left) / _chigui.width;
    final y = (at.dy - _chigui.top) / _chigui.height;
    final before = [for (final s in _game.spots) s.state];
    final result = _game.use(tool, x, y, rub: rub);
    _showTouch(at);
    switch (result) {
      case BathUse.wrong:
        // Nothing happens; the tool that is needed hops, as a hint.
        if (rub == 0 || !_hintedThisRub) setState(() => _hint = true);
        _hintedThisRub = true;
      case BathUse.missed:
        if (tool == BathTool.ladle && rub == 0) sfx.play(Sfx.pour);
      case BathUse.rubbing:
        _rubbed += rub > 0 ? rub : bathTapRub;
        if (_rubbed >= 0.15) {
          _rubbed = 0;
          sfx.play(Sfx.scrub);
        }
        _restartHintClock();
      case BathUse.step || BathUse.washed:
        final cleaned = [
          for (final (i, s) in _game.spots.indexed)
            if (s.state == SpotState.clean && before[i] != SpotState.clean) s,
        ];
        sfx.play(switch (tool) {
          BathTool.soap => Sfx.lather,
          BathTool.ladle => Sfx.pour,
          _ => Sfx.scrub,
        });
        if (result == BathUse.washed) {
          sfx.play(Sfx.sparkle);
          _tool = null;
          _react(Reaction.cleaned);
        } else if (cleaned.isNotEmpty) {
          _react(Reaction.cleaned);
        }
        _restartHintClock();
      case BathUse.yuzu:
        sfx.play(Sfx.plop);
        _restartHintClock();
        if (_game.stage == BathStage.soak) {
          _hintTimer?.cancel();
          _tool = null;
          _soak();
        }
      case BathUse.dried:
        _tool = null;
        _finish();
    }
    setState(() {});
  }

  /// Shows the tool where it was used, for a moment.
  void _showTouch(Offset at) {
    _touchTimer?.cancel();
    _touch = at;
    _touchTimer = Timer(const Duration(milliseconds: 450), () {
      if (mounted) setState(() => _touch = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MinigameScaffold(
      child: switch (_phase) {
        _Phase.ready => GameIntro(
          title: l10n.bathTitle,
          hint: l10n.bathHint,
          start: [
            GameButton(
              icon: Icons.play_arrow,
              label: l10n.startButton,
              onPressed: _start,
            ),
          ],
        ),
        _Phase.playing => AnimatedBuilder(
          animation: Listenable.merge([_move, _loop]),
          builder: (context, _) => _playArea(l10n),
        ),
        _Phase.done => RoundResult(
          summary: l10n.bathSpots(_game.spots.length),
          pay: _pay,
          onPlayAgain: _start,
        ),
      },
    );
  }

  String _status(AppLocalizations l10n) => switch (_game.stage) {
    BathStage.arrive when _moving == _Move.run => l10n.bathArrive,
    BathStage.arrive => l10n.bathHopIn,
    BathStage.wash => l10n.bathWash,
    BathStage.yuzu => l10n.bathYuzu,
    BathStage.soak => l10n.bathSoak,
    BathStage.dry => l10n.bathDry,
    BathStage.done => l10n.bathDone,
  };

  Widget _playArea(AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Semantics(
            liveRegion: true,
            child: SizedBox(
              height: 64,
              child: Center(
                child: Text(
                  _status(l10n),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge,
                ),
              ),
            ),
          ),
          Expanded(child: LayoutBuilder(builder: _stage)),
          const SizedBox(height: 12),
          _tray(l10n),
        ],
      ),
    );
  }

  Widget _tray(AppLocalizations l10n) {
    final needed = _hint ? _game.needed : null;
    final hop = needed == null
        ? 0.0
        : math.sin(_loop.value * 2 * math.pi).abs() * 8;
    const spacing = 6.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final button = ((constraints.maxWidth - 4 * spacing) / 5).clamp(
          48.0,
          64.0,
        );
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacing,
          children: [
            for (final tool in BathTool.values)
              Transform.translate(
                offset: Offset(0, tool == needed ? -hop : 0),
                child: Semantics(
                  button: true,
                  selected: tool == _tool,
                  label: switch (tool) {
                    BathTool.soap => l10n.bathToolSoap,
                    BathTool.brush => l10n.bathToolBrush,
                    BathTool.ladle => l10n.bathToolLadle,
                    BathTool.yuzu => l10n.bathToolYuzu,
                    BathTool.towel => l10n.bathToolTowel,
                  },
                  child: Material(
                    key: ValueKey('tool-${tool.name}'),
                    color: tool == _tool ? Palette.ink : Palette.cloud,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: tool == needed ? Palette.sparkle : Palette.ink,
                        width: 3,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => _pickTool(tool),
                      child: SizedBox.square(
                        dimension: button,
                        child: Center(
                          child: BathToolIcon(tool: tool, size: button * 0.68),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _stage(BuildContext context, BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final size = math.min(w * 0.7, h * 0.5);
    final tubWidth = math.min(size * 1.35, w * 0.95);
    final tubHeight = tubWidth * HinokiTub.aspect;
    final tubLeft =
        (w * 0.62).clamp(tubWidth / 2, w - tubWidth / 2) - tubWidth / 2;
    // The floor, low enough to leave room to hop, but not far from the
    // middle on tall screens.
    final floor = math.min(h - 4, h * 0.5 + size * 0.6);
    final tubTop = floor - tubHeight;
    final waterY = tubTop + tubHeight * HinokiTub.waterLine;

    // Outside, Chigüi waits beside the tub, or in front of it if there is
    // no room.
    final ground = Offset(
      math.max(0, tubLeft - size * 0.85),
      floor - size * 0.97,
    );
    final tub = Offset(
      tubLeft + tubWidth / 2 - size * 0.46,
      waterY - size * 0.74,
    );
    final t = Curves.easeInOut.transform(_move.value);
    final arc = math.sin(t * math.pi) * size * 0.45;
    final at = switch (_moving) {
      _Move.run => Offset.lerp(Offset(-size, ground.dy), ground, t)!,
      _Move.hopIn => Offset.lerp(ground, tub, t)! - Offset(0, arc),
      _Move.hopOut => Offset.lerp(tub, ground, t)! - Offset(0, arc),
      _Move.none => _inTub ? tub : ground,
    };
    _chigui = at & Size.square(size);
    // Over the tub's front while outside or high in the air, behind it once
    // sitting in the water.
    final behindFront = switch (_moving) {
      _Move.hopIn => t > 0.6,
      _Move.hopOut => t < 0.4,
      _ => _inTub,
    };

    final stage = _game.stage;
    final murk = stage == BathStage.arrive && !_inTub
        ? 0.0
        : 0.25 +
              0.3 *
                  _game.spots.where((s) => s.state == SpotState.clean).length /
                  math.max(1, _game.spots.length);
    final chigui = Positioned(
      key: const ValueKey('bath-chigui'),
      left: at.dx,
      top: at.dy,
      child: IgnorePointer(
        child: ChiguiView(
          size: size,
          face: switch (stage) {
            BathStage.arrive || BathStage.soak || BathStage.done => Face.happy,
            _ => Face.normal,
          },
          reaction: _reaction,
          reactionId: _reactionId,
          coat: GrimePainter(
            spots: _game.spots,
            dirt: _game.dirt,
            muddy: stage == BathStage.arrive,
            wet: stage == BathStage.dry ? _game.wet : 0,
            drip: _reduceMotion ? null : _loop.value,
            dripTo: behindFront ? 0.74 : 0.97,
          ),
        ),
      ),
    );
    final tool = _tool;
    final touch = _touch;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) => _use(d.localPosition),
      onPanStart: (_) => _hintedThisRub = false,
      onPanUpdate: (d) => _use(d.localPosition, rub: d.delta.distance / size),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: tubLeft,
            top: tubTop,
            child: HinokiTub(
              part: TubPart.back,
              width: tubWidth,
              murk: murk,
            ),
          ),
          if (behindFront) chigui,
          Positioned(
            left: tubLeft,
            top: tubTop,
            child: IgnorePointer(
              child: HinokiTub(
                part: TubPart.front,
                width: tubWidth,
                murk: murk,
                yuzus: _game.yuzus,
                time: _loop.value,
              ),
            ),
          ),
          if (!behindFront) chigui,
          if (touch != null && tool != null)
            Positioned(
              left: touch.dx - 28,
              top: touch.dy - 28,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: tool == BathTool.ladle ? -0.7 : 0,
                  child: BathToolIcon(tool: tool, size: 56),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
