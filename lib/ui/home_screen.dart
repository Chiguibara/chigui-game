import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/pet_state.dart';
import '../game/rules.dart' show happyLevel, wishLevel;
import '../l10n/app_localizations.dart';
import '../minigame/minigame_screen.dart';
import '../shop/shop_screen.dart';
import 'chigui_view.dart';
import 'dev_panel.dart';
import 'need_meter.dart';
import 'palette.dart';
import 'game_frame.dart';
import 'sprites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final PetController controller;

  /// How often the routine catches up while the game is open.
  static const refreshEvery = Duration(seconds: 30);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLifecycleListener _lifecycle;
  late final Timer _ticker;

  Reaction? _reaction;
  int _reactionId = 0;

  PetController get _pet => widget.controller;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _pet.refresh);
    _ticker = Timer.periodic(HomeScreen.refreshEvery, (_) => _pet.refresh());
  }

  @override
  void dispose() {
    _ticker.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  void _react(Reaction? reaction) {
    if (reaction == null) return;
    setState(() {
      _reaction = reaction;
      _reactionId++;
    });
  }

  void _onPet() => _react(_pet.pet() ? Reaction.love : null);

  void _onFeed() => _react(_pet.feed() ? Reaction.eat : Reaction.refuse);

  void _onToilet() => _react(_pet.takeToToilet() ? Reaction.relief : null);

  void _onClean() => _react(_pet.cleanUp() ? Reaction.cleaned : null);

  void _onVet() => _react(_pet.visitVet() ? Reaction.cured : null);

  void _onBed() => _pet.sendToBed();

  /// Real steps from the pedometer (Android, not wired yet) or the dev panel.
  void _onSteps(int steps) {
    _pet.addSteps(steps);
    _react(Reaction.walk);
  }

  void _onShop() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => ShopScreen(controller: _pet)));

  void _onPlay() => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => MinigameScreen(controller: _pet)),
  );

  Face get _face {
    final state = _pet.state;
    if (_pet.asleep) return Face.asleep;
    if (state.sick) return Face.sick;
    if (state.grumpy) return Face.grumpy;
    return Face.normal;
  }

  Bubble? get _bubble {
    final state = _pet.state;
    if (_pet.asleep) return null;
    if (state.sick) return Bubble.sick;
    if (state.needsPotty) return Bubble.potty;
    if (_pet.wantsSleep) return Bubble.sleepy;
    if (_pet.pendingMeal != null) return Bubble.food;
    return switch (_pet.wish) {
      Need.food => Bubble.food,
      Need.affection => Bubble.affection,
      Need.fun => Bubble.fun,
      null => null,
    };
  }

  String _status(AppLocalizations l10n) {
    final state = _pet.state;
    return switch (_reaction) {
      Reaction.love => switch (state.level(Need.affection)) {
        < wishLevel => l10n.pettedLowStatus,
        < happyLevel => l10n.pettedMidStatus,
        _ => l10n.lovedStatus,
      },
      Reaction.eat => l10n.ateStatus,
      Reaction.refuse => l10n.fullStatus,
      Reaction.relief => l10n.reliefStatus,
      Reaction.cured => l10n.curedStatus,
      Reaction.cleaned => l10n.cleanedStatus,
      Reaction.chomp => l10n.ateStatus,
      Reaction.walk => l10n.walkedStatus,
      null when _pet.asleep => l10n.asleepStatus,
      null when state.sick => l10n.sickStatus,
      null when state.needsPotty => l10n.pottyStatus,
      null when _pet.wantsSleep => l10n.sleepyStatus,
      null when _pet.pendingMeal != null => l10n.mealtimeStatus,
      null when state.messes > 0 => l10n.messStatus,
      null when state.grumpy => l10n.grumpyStatus,
      null => switch (_pet.wish) {
        Need.food => l10n.wantsFood,
        Need.affection => l10n.wantsAffection,
        Need.fun => l10n.wantsFun,
        null => l10n.tapHint,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Palette.outside,
      body: GameFrame(
        child: ListenableBuilder(
          listenable: _pet,
          builder: (context, _) {
            final state = _pet.state;
            final asleep = _pet.asleep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              color: asleep ? Palette.night : Palette.mint,
              child: SafeArea(
                child: Column(
                  children: [
                    if (kDebugMode)
                      DevPanel(controller: _pet, onSteps: _onSteps),
                    _counters(l10n, textTheme, state.coins),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => isWide(constraints)
                            ? _wideLayout(l10n, textTheme, constraints)
                            : _phoneLayout(l10n, textTheme, constraints),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _title(AppLocalizations l10n, TextTheme textTheme) => Text(
    l10n.chiguiName,
    style: textTheme.headlineMedium?.copyWith(
      color: Palette.ink,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _chigui(double size) {
    final state = _pet.state;
    return ChiguiView(
      size: size,
      face: _face,
      wearing: state.equipped,
      bubble: _bubble,
      messes: state.messes,
      onTap: _onPet,
      onCleanMess: _onClean,
      reaction: _reaction,
      reactionId: _reactionId,
      onReactionEnd: () => setState(() => _reaction = null),
    );
  }

  Widget _meters() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      for (final need in Need.values)
        NeedMeter(need: need, level: _pet.state.level(need)),
    ],
  );

  /// One column, as on a phone.
  Widget _phoneLayout(
    AppLocalizations l10n,
    TextTheme textTheme,
    BoxConstraints constraints,
  ) => Column(
    children: [
      const Spacer(),
      _title(l10n, textTheme),
      const SizedBox(height: 16),
      // Fit both narrow and short screens, leaving room for the controls.
      _chigui(
        math.min(constraints.maxWidth * 0.7, constraints.maxHeight * 0.34),
      ),
      const SizedBox(height: 16),
      _statusLine(l10n, textTheme),
      const SizedBox(height: 16),
      _meters(),
      const SizedBox(height: 20),
      _actions(l10n, asleep: _pet.asleep),
      const Spacer(flex: 2),
    ],
  );

  /// Chigüi large on the left, everything else on the right.
  Widget _wideLayout(
    AppLocalizations l10n,
    TextTheme textTheme,
    BoxConstraints constraints,
  ) => Row(
    children: [
      Expanded(
        flex: 5,
        child: Center(
          child: _chigui(
            math.min(constraints.maxWidth * 0.5, constraints.maxHeight * 0.8),
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _title(l10n, textTheme),
              const SizedBox(height: 16),
              _statusLine(l10n, textTheme),
              const SizedBox(height: 24),
              _meters(),
              const SizedBox(height: 32),
              _actions(l10n, asleep: _pet.asleep),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _statusLine(AppLocalizations l10n, TextTheme textTheme) {
    final style = textTheme.titleMedium?.copyWith(
      color: Palette.ink,
      height: 1.3,
    );
    // Two lines reserved so the controls below never move under the
    // player's finger.
    return Container(
      height:
          2 *
          1.3 *
          (style?.fontSize ?? 16) *
          MediaQuery.textScalerOf(context).scale(1),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Semantics(
        liveRegion: true,
        child: Text(
          _status(l10n),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }

  /// Coins, and today's steps once a step counter exists (for now only in
  /// debug builds, fed by the dev panel; Android's pedometer comes later).
  Widget _counters(AppLocalizations l10n, TextTheme textTheme, int coins) {
    final style = textTheme.titleMedium?.copyWith(
      color: Palette.ink,
      fontWeight: FontWeight.w700,
    );
    Widget counter(String label, Widget icon, int value) => Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text('$value', style: style),
        ],
      ),
    );
    final steps = _pet.stepsToday;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          if (kDebugMode)
            counter(l10n.stepsLabel(steps), const Footprints(size: 26), steps),
          const Spacer(),
          counter(l10n.coinsLabel(coins), const Coin(size: 26), coins),
        ],
      ),
    );
  }

  /// Feed, Play, and Shop are always first; the others appear only when they are needed.
  Widget _actions(AppLocalizations l10n, {required bool asleep}) {
    final state = _pet.state;
    Widget button(IconData icon, String label, VoidCallback? onPressed) =>
        FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: Palette.ink,
            foregroundColor: Palette.mint,
            minimumSize: const Size(120, 52),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          button(Icons.eco, l10n.feedButton, asleep ? null : _onFeed),
          button(
            Icons.sports_esports,
            l10n.playButton,
            asleep ? null : _onPlay,
          ),
          button(Icons.storefront, l10n.shopButton, _onShop),
          if (state.needsPotty) button(Icons.wc, l10n.toiletButton, _onToilet),
          if (_pet.wantsSleep) button(Icons.bedtime, l10n.bedButton, _onBed),
          if (state.sick) button(Icons.vaccines, l10n.vetButton, _onVet),
        ],
      ),
    );
  }
}
