import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/pet_state.dart';
import '../l10n/app_localizations.dart';
import 'chigui_view.dart';
import 'need_meter.dart';
import 'palette.dart';
import 'phone_frame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final PetController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLifecycleListener _lifecycle;

  Reaction? _reaction;
  int _reactionId = 0;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: widget.controller.refresh);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _react(Reaction reaction) => setState(() {
    _reaction = reaction;
    _reactionId++;
  });

  void _pet() {
    widget.controller.pet();
    _react(Reaction.love);
  }

  void _feed() =>
      _react(widget.controller.feed() ? Reaction.eat : Reaction.refuse);

  String _status(AppLocalizations l10n, Need? wish) => switch (_reaction) {
    Reaction.love => l10n.lovedStatus,
    Reaction.eat => l10n.ateStatus,
    Reaction.refuse => l10n.fullStatus,
    null => switch (wish) {
      Need.food => l10n.wantsFood,
      Need.affection => l10n.wantsAffection,
      Need.fun => l10n.wantsFun,
      null => l10n.tapHint,
    },
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Palette.outside,
      body: PhoneFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final state = widget.controller.state;
                final wish = widget.controller.wish;
                return LayoutBuilder(
                  builder: (context, constraints) => Column(
                    children: [
                      const Spacer(),
                      Text(
                        l10n.chiguiName,
                        style: textTheme.headlineMedium?.copyWith(
                          color: Palette.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ChiguiView(
                        size: constraints.maxWidth * 0.75,
                        onTap: _pet,
                        wish: wish,
                        reaction: _reaction,
                        reactionId: _reactionId,
                        onReactionEnd: () => setState(() => _reaction = null),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height:
                            2 *
                            1.3 *
                            (textTheme.titleMedium?.fontSize ?? 16) *
                            MediaQuery.textScalerOf(context).scale(1),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Semantics(
                          liveRegion: true,
                          // Two lines reserved so the controls below never
                          // move under the player's finger.
                          child: Text(
                            _status(l10n, wish),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: Palette.ink,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final need in Need.values)
                            NeedMeter(need: need, level: state.level(need)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _feed,
                        icon: const Icon(Icons.eco),
                        label: Text(l10n.feedButton),
                        style: FilledButton.styleFrom(
                          backgroundColor: Palette.ink,
                          foregroundColor: Palette.mint,
                          minimumSize: const Size(160, 56),
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
