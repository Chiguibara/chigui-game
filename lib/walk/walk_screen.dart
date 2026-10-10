import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart'
    show coinsPerWalk, maxWalksPerDay, stepsPerFootTap, stepsPerWalk;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/game_frame.dart';
import '../ui/palette.dart';
import '../ui/sprites.dart';
import 'motion_source.dart';
import 'pedometer.dart';
import 'step_watcher.dart';

enum _Mode { intro, sensor, tapping }

enum _Foot { left, right }

/// A walk with Chigüi. Phones' browsers count real steps from the motion
/// sensor; without one (PCs), the player taps the feet in turn. Steps feed
/// the same daily walks as the Android pedometer will.
class WalkScreen extends StatefulWidget {
  const WalkScreen({
    super.key,
    required this.controller,
    this.watcher,
    this.pedometer,
    this.onPhone,
    this.startedWalking,
  });

  final PetController controller;

  /// The game's shared step listener; without one, the screen listens to
  /// the platform's sensor itself.
  final StepWatcher? watcher;

  /// The Android system step counter. It already adds every step to the
  /// game, so with it the scene only shows and celebrates them.
  final Pedometer? pedometer;

  /// Set when the game opened the walk on its own because the player was
  /// already walking: the scene starts counting right away, including
  /// these first steps.
  final int? startedWalking;

  /// Whether this is a phone or tablet, which may have a motion sensor.
  /// Defaults to the operating system (also detected in browsers): PCs go
  /// straight to tapping the feet.
  final bool? onPhone;

  /// How long to wait for motion samples before assuming there is no sensor.
  static const sensorTimeout = Duration(milliseconds: 1500);

  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  late final StepWatcher _watcher =
      widget.watcher ?? StepWatcher(createMotionSource());
  StreamSubscription<void>? _stepsSubscription;
  late final bool _onPhone =
      widget.onPhone ??
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  Timer? _sensorCheck;
  _Mode _mode = _Mode.intro;
  _Foot? _lastFoot;
  int _pendingSteps = 0;
  bool _leftStep = false;
  String? _message;
  Reaction? _reaction;
  int _reactionId = 0;

  /// How far the scenery has scrolled, in screen widths.
  double _scroll = 0;

  PetController get _pet => widget.controller;

  StreamSubscription<int>? _pedometerSubscription;
  int _walksBefore = 0;

  bool get _usesPedometer => widget.pedometer?.running ?? false;

  @override
  void initState() {
    super.initState();
    if (_usesPedometer) {
      _mode = _Mode.sensor;
      _walksBefore = _pet.walksToday;
      _pedometerSubscription = widget.pedometer!.liveSteps.listen(
        _onPedometerSteps,
      );
      return;
    }
    final already = widget.startedWalking;
    if (already != null) {
      _mode = _Mode.sensor;
      _listen();
      _pendingSteps = already;
      _scroll = already / stepsPerWalk;
    }
  }

  @override
  void dispose() {
    _sensorCheck?.cancel();
    _stepsSubscription?.cancel();
    _pedometerSubscription?.cancel();
    if (widget.watcher == null) _watcher.dispose();
    // Save the last steps right after this screen is gone: the widget tree
    // is locked while disposing, and saving notifies the home screen.
    final pending = _pendingSteps;
    _pendingSteps = 0;
    if (pending > 0) {
      final pet = _pet;
      scheduleMicrotask(() => pet.addSteps(pending));
    }
    super.dispose();
  }

  Future<void> _start() async {
    if (!_onPhone || !await _watcher.start()) {
      _useTapping();
      return;
    }
    _listen();
    if (_watcher.receiving) {
      setState(() => _mode = _Mode.sensor);
      return;
    }
    // A browser can accept but never send samples (no sensor).
    _sensorCheck = Timer(WalkScreen.sensorTimeout, () {
      if (_mode == _Mode.intro && !_watcher.receiving) _useTapping();
    });
  }

  void _listen() {
    _stepsSubscription ??= _watcher.steps.listen((_) => _onRealStep());
  }

  void _useTapping() {
    _stepsSubscription?.cancel();
    _stepsSubscription = null;
    if (mounted) setState(() => _mode = _Mode.tapping);
  }

  void _onRealStep() {
    if (!mounted || _mode == _Mode.tapping) return;
    if (_mode == _Mode.intro) {
      _sensorCheck?.cancel();
      setState(() => _mode = _Mode.sensor);
    }
    // Save in small batches rather than on every step.
    _pendingSteps++;
    _stepped(1, save: _pendingSteps >= 10);
  }

  /// Steps the pedometer has already added to the game: animate them and
  /// celebrate any walk they completed.
  void _onPedometerSteps(int steps) {
    if (!mounted) return;
    final walks = _pet.walksToday;
    final walked = walks > _walksBefore;
    _walksBefore = walks;
    _leftStep = !_leftStep;
    sfx.play(walked ? Sfx.reward : (_leftStep ? Sfx.stepLeft : Sfx.stepRight));
    setState(() {
      _scroll += steps / stepsPerWalk;
      _message = walked ? AppLocalizations.of(context).walkedStatus : null;
      _reaction = walked ? Reaction.love : Reaction.walk;
      _reactionId++;
    });
  }

  void _onFoot(_Foot foot, AppLocalizations l10n) {
    if (foot == _lastFoot) {
      sfx.play(Sfx.refuse);
      setState(() => _message = l10n.otherFoot);
      return;
    }
    // Tapped feet only count for a few walks a day.
    if (_pet.tapStepsLeft <= 0) {
      sfx.play(Sfx.refuse);
      setState(() => _message = l10n.tapsCapped);
      return;
    }
    _lastFoot = foot;
    _celebrate(
      stepsPerFootTap,
      walked: _pet.addSteps(stepsPerFootTap, tapped: true),
    );
    // Keep the pedometer's celebration from repeating a walk the feet did.
    _walksBefore = _pet.walksToday;
  }

  void _stepped(int steps, {required bool save}) =>
      _celebrate(steps, walked: save && _flush());

  /// Animates steps already counted, celebrating a completed walk.
  void _celebrate(int steps, {required bool walked}) {
    _leftStep = !_leftStep;
    sfx.play(walked ? Sfx.reward : (_leftStep ? Sfx.stepLeft : Sfx.stepRight));
    setState(() {
      _scroll += steps / stepsPerWalk;
      _message = walked ? AppLocalizations.of(context).walkedStatus : null;
      _reaction = walked ? Reaction.love : Reaction.walk;
      _reactionId++;
    });
  }

  /// Hands pending steps to the pet. Returns true if a walk was completed.
  bool _flush() {
    if (_pendingSteps == 0) return false;
    final steps = _pendingSteps;
    _pendingSteps = 0;
    return _pet.addSteps(steps);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Palette.outside,
      body: GameFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final chiguiSize = math.min(w * 0.55, h * 0.3);
                return Stack(
                  children: [
                    Positioned.fill(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: _scroll),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, scroll, _) =>
                            CustomPaint(painter: _ScenePainter(scroll: scroll)),
                      ),
                    ),
                    Positioned(
                      left: (w - chiguiSize) / 2,
                      top: h * 0.72 - chiguiSize,
                      child: IgnorePointer(
                        child: ChiguiView(
                          size: chiguiSize,
                          wearing: _pet.state.equipped,
                          reaction: _reaction,
                          reactionId: _reactionId,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: _header(l10n, textTheme),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: _controls(l10n, textTheme),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n, TextTheme textTheme) {
    final steps = _pet.stepsToday + _pendingSteps;
    final walks = math.min(steps ~/ stepsPerWalk, maxWalksPerDay);
    final capped = walks >= maxWalksPerDay;
    final style = textTheme.titleMedium?.copyWith(
      color: Palette.ink,
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                tooltip: l10n.backHomeButton,
                color: Palette.ink,
                iconSize: 28,
              ),
              Expanded(
                child: Text(
                  l10n.walkTitle,
                  style: textTheme.titleLarge?.copyWith(
                    color: Palette.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                label: l10n.stepsLabel(steps),
                excludeSemantics: true,
                child: Row(
                  children: [
                    const Footprints(size: 26),
                    const SizedBox(width: 6),
                    Text('$steps', style: style),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capped
                      ? l10n.walksCapped
                      : l10n.nextWalkProgress(
                          steps % stepsPerWalk,
                          stepsPerWalk,
                        ),
                  style: textTheme.bodyMedium?.copyWith(color: Palette.ink),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: capped ? 1 : (steps % stepsPerWalk) / stepsPerWalk,
                    minHeight: 10,
                    color: Palette.leaf,
                    backgroundColor: Palette.ink.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(l10n.walksToday(walks), style: textTheme.bodyMedium),
                    const Spacer(),
                    const Coin(size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '+$coinsPerWalk',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls(AppLocalizations l10n, TextTheme textTheme) {
    final hint = switch (_mode) {
      _Mode.intro => _onPhone ? l10n.walkIntro : l10n.walkIntroTapping,
      _Mode.sensor =>
        _message ??
            (_usesPedometer ? l10n.pedometerWalkHint : l10n.sensorWalkHint),
      _Mode.tapping => _message ?? l10n.tapFeetHint,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Palette.cloud.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Semantics(
            liveRegion: true,
            child: Text(
              hint,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(color: Palette.ink),
            ),
          ),
        ),
        const SizedBox(height: 16),
        switch (_mode) {
          _Mode.intro => FilledButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.directions_walk),
            label: Text(l10n.startWalkButton),
            style: FilledButton.styleFrom(
              backgroundColor: Palette.ink,
              foregroundColor: Palette.mint,
              minimumSize: const Size(180, 56),
            ),
          ),
          // With real steps too, the feet stay available so players who are
          // sitting still can keep walking with Chigüi.
          _Mode.sensor || _Mode.tapping => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footButton(_Foot.left, l10n.leftFoot, l10n),
              const SizedBox(width: 32),
              _footButton(_Foot.right, l10n.rightFoot, l10n),
            ],
          ),
        },
      ],
    );
  }

  Widget _footButton(_Foot foot, String label, AppLocalizations l10n) {
    final next = _lastFoot != foot;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: next ? Palette.cloud : Palette.cloud.withValues(alpha: 0.5),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onFoot(foot, l10n),
          child: SizedBox.square(
            dimension: 96,
            child: Center(
              child: Transform.flip(
                flipX: foot == _Foot.left,
                child: const Footprints(size: 56),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A path through a little park that scrolls as Chigüi walks.
class _ScenePainter extends CustomPainter {
  _ScenePainter({required this.scroll});

  final double scroll;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Decorations are sized by the shorter side so wide screens stay cute.
    final d = math.min(w, h);
    final groundTop = h * 0.62;
    canvas.drawRect(
      Rect.fromLTRB(0, groundTop, w, h),
      Paint()..color = Palette.grass,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, h * 0.68, w, h * 0.76),
      Paint()..color = Palette.path,
    );

    // Decorations repeat every screen width and slide left as steps add up.
    final offset = (scroll % 1) * w;
    for (var tile = 0; tile < 3; tile++) {
      final x0 = tile * w - offset;
      for (final (fx, kind) in [
        (0.1, 0),
        (0.3, 1),
        (0.55, 0),
        (0.75, 2),
        (0.9, 1),
      ]) {
        final x = x0 + fx * w;
        switch (kind) {
          case 0: // Bush.
            final bush = Paint()..color = Palette.tree;
            canvas.drawCircle(Offset(x, groundTop), d * 0.05, bush);
            canvas.drawCircle(Offset(x + d * 0.04, groundTop), d * 0.04, bush);
          case 1: // Flower.
            canvas.drawLine(
              Offset(x, h * 0.8),
              Offset(x, h * 0.85),
              Paint()
                ..color = Palette.leaf
                ..strokeWidth = 3,
            );
            canvas.drawCircle(
              Offset(x, h * 0.8),
              d * 0.015,
              Paint()..color = Palette.blush,
            );
          default: // Tree.
            canvas.drawRect(
              Rect.fromLTWH(
                x - d * 0.012,
                groundTop - d * 0.1,
                d * 0.024,
                d * 0.1,
              ),
              Paint()..color = Palette.furDark,
            );
            canvas.drawCircle(
              Offset(x, groundTop - d * 0.12),
              d * 0.06,
              Paint()..color = Palette.tree,
            );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.scroll != scroll;
}
