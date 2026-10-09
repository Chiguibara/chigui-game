import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/catalog.dart';
import '../game/pet_controller.dart';
import '../game/rules.dart' show BuyResult;
import '../l10n/app_localizations.dart';
import '../sound/sound_effects.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import '../ui/game_frame.dart';
import '../ui/sprites.dart';
import '../store/pack_store.dart';
import '../store/packs_controller.dart';
import 'item_display.dart';

/// Buy accessories and stickers with coins, and try accessories on.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.controller, this.packs});

  final PetController controller;

  /// Real-money packs; null (or unavailable) where they are not sold.
  final PacksController? packs;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String? _message;
  Reaction? _reaction;
  int _reactionId = 0;

  PetController get _pet => widget.controller;
  PacksController? get _packs => widget.packs;
  PackUpdate? _seenUpdate;

  @override
  void initState() {
    super.initState();
    _seenUpdate = _packs?.lastUpdate;
    _packs?.addListener(_onPacksChanged);
  }

  @override
  void dispose() {
    _packs?.removeListener(_onPacksChanged);
    super.dispose();
  }

  /// Reacts once to each finished purchase.
  void _onPacksChanged() {
    final update = _packs?.lastUpdate;
    if (update == null || identical(update, _seenUpdate) || !mounted) return;
    _seenUpdate = update;
    final l10n = AppLocalizations.of(context);
    switch (update.status) {
      case PackStatus.purchased:
        sfx.play(Sfx.buy);
        _say(l10n.packBoughtStatus, Reaction.love);
      case PackStatus.error:
        sfx.play(Sfx.bonk);
        _say(l10n.packErrorStatus, Reaction.refuse);
      case PackStatus.pending || PackStatus.canceled:
        setState(() {});
    }
  }

  /// A clear, calm confirmation before the store's own purchase screen.
  Future<void> _confirmPack(Pack pack, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.buyPackTitle),
        content: Text(l10n.buyPackBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: Palette.ink),
            child: Text(l10n.buyPackCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Palette.ink,
              foregroundColor: Palette.mint,
            ),
            child: Text(l10n.buyPackConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true) await _packs?.buy(pack);
  }

  void _say(String message, Reaction reaction) => setState(() {
    _message = message;
    _reaction = reaction;
    _reactionId++;
  });

  void _onTap(Item item, AppLocalizations l10n) {
    if (_pet.state.owned.contains(item.id)) {
      if (item.slot == Slot.sticker) return;
      _pet.toggleWorn(item);
      sfx.play(Sfx.pop);
      _say(l10n.shopHint, Reaction.love);
      return;
    }
    switch (_pet.canBuy(item)) {
      case BuyResult.outOfSeason:
        sfx.play(Sfx.bonk);
        _say(l10n.tooEarly(item.season!), Reaction.refuse);
      case BuyResult.notEnoughCoins:
        sfx.play(Sfx.bonk);
        _say(
          l10n.notEnoughCoins(item.price - _pet.state.coins),
          Reaction.refuse,
        );
      case BuyResult.bought:
        _pet.buy(item);
        sfx.play(Sfx.buy);
        _say(
          item.slot == Slot.sticker
              ? l10n.stickerBoughtStatus
              : l10n.boughtStatus,
          Reaction.love,
        );
      // Pack items are only offered in their pack, never for coins.
      case BuyResult.alreadyOwned || BuyResult.onlyInPack:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final now = _pet.now;
    // In-season items first, then the rest of the year's.
    final seasonal =
        [
          for (final item in catalog)
            if (item.season != null) item,
        ]..sort((a, b) {
          int rank(Item i) => inSeason(i.season!, now) ? 0 : 1;
          return rank(a).compareTo(rank(b));
        });

    return Scaffold(
      backgroundColor: Palette.outside,
      body: GameFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: ListenableBuilder(
              listenable: Listenable.merge([_pet, ?_packs]),
              builder: (context, _) => LayoutBuilder(
                builder: (context, constraints) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _header(l10n, textTheme, constraints),
                    ),
                    if (_packs?.available ?? false)
                      ..._packSection(l10n, textTheme),
                    ..._section(
                      l10n.seasonalSection,
                      seasonal,
                      l10n,
                      textTheme,
                    ),
                    ..._section(
                      l10n.accessoriesSection,
                      [
                        for (final item in catalog)
                          // Pack items show up here once their pack is owned.
                          if (item.season == null &&
                              item.slot != Slot.sticker &&
                              (item.pack == null ||
                                  _pet.state.owned.contains(item.id)))
                            item,
                      ],
                      l10n,
                      textTheme,
                    ),
                    ..._section(
                      l10n.stickersSection,
                      [
                        for (final item in catalog)
                          if (item.slot == Slot.sticker) item,
                      ],
                      l10n,
                      textTheme,
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _packSection(AppLocalizations l10n, TextTheme textTheme) => [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          l10n.packsSection,
          style: textTheme.titleMedium?.copyWith(
            color: Palette.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList.separated(
        itemCount: packs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) => _packCard(packs[i], l10n, textTheme),
      ),
    ),
  ];

  Widget _packCard(Pack pack, AppLocalizations l10n, TextTheme textTheme) {
    final packs = _packs!;
    final owned = packs.owns(pack);
    final waiting = packs.waiting.contains(pack.id);
    final price = packs.prices[pack.id];
    final items = [for (final id in pack.items) itemsById[id]!];
    final small = textTheme.bodySmall?.copyWith(color: Palette.ink);

    final Widget action;
    if (owned) {
      action = Text(
        l10n.packOwned,
        style: small?.copyWith(fontWeight: FontWeight.w700),
      );
    } else if (waiting) {
      action = Text(l10n.packWaiting, style: small, textAlign: TextAlign.end);
    } else {
      action = FilledButton(
        onPressed: price == null ? null : () => _confirmPack(pack, l10n),
        style: FilledButton.styleFrom(
          backgroundColor: Palette.ink,
          foregroundColor: Palette.mint,
          minimumSize: const Size(96, 48),
        ),
        child: Text(price ?? '…'),
      );
    }

    return Material(
      color: Palette.cloud.withValues(alpha: owned ? 1 : 0.7),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ChiguiPortrait(
              size: 84,
              wearing: {for (final item in items) item.slot: item.id},
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.packName(pack),
                    style: textTheme.titleSmall?.copyWith(
                      color: Palette.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(items.map(l10n.itemName).join(' · '), style: small),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: action,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(
    AppLocalizations l10n,
    TextTheme textTheme,
    BoxConstraints constraints,
  ) {
    final state = _pet.state;
    final wide = isWide(constraints);
    final fittingRoom = ChiguiView(
      size: wide
          ? math.min(constraints.maxWidth * 0.22, 260)
          : constraints.maxWidth * 0.42,
      wearing: state.equipped,
      reaction: _reaction,
      reactionId: _reactionId,
      onReactionEnd: () => setState(() => _reaction = null),
    );
    final message = Container(
      // Three lines: the seasonal jokes are long.
      height: 3 * 1.3 * 16 * MediaQuery.textScalerOf(context).scale(1),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Semantics(
        liveRegion: true,
        child: Text(
          _message ?? l10n.shopHint,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyLarge?.copyWith(color: Palette.ink, height: 1.3),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Column(
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
                  l10n.shopTitle,
                  style: textTheme.titleLarge?.copyWith(
                    color: Palette.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Semantics(
                label: l10n.coinsLabel(state.coins),
                excludeSemantics: true,
                child: Row(
                  children: [
                    const Coin(size: 26),
                    const SizedBox(width: 6),
                    Text(
                      '${state.coins}',
                      style: textTheme.titleMedium?.copyWith(
                        color: Palette.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // The fitting room: Chigüi wearing the current outfit, with the
          // shop's message beside it on wide screens.
          if (wide)
            Row(
              children: [
                const SizedBox(width: 24),
                fittingRoom,
                const SizedBox(width: 24),
                Expanded(child: message),
              ],
            )
          else ...[
            fittingRoom,
            message,
          ],
        ],
      ),
    );
  }

  List<Widget> _section(
    String title,
    List<Item> items,
    AppLocalizations l10n,
    TextTheme textTheme,
  ) => [
    SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            color: Palette.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
    SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 196,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _tile(items[i], l10n, textTheme),
      ),
    ),
  ];

  Widget _tile(Item item, AppLocalizations l10n, TextTheme textTheme) {
    final state = _pet.state;
    final owned = state.owned.contains(item.id);
    final worn = state.equipped[item.slot] == item.id;
    final season = item.season;
    final available = season == null || inSeason(season, _pet.now);
    final sticker = item.slot == Slot.sticker;
    final small = textTheme.bodySmall?.copyWith(color: Palette.ink);

    final Widget action;
    if (owned && sticker) {
      action = Text(l10n.inAlbum, style: small, textAlign: TextAlign.center);
    } else if (owned) {
      action = Text(
        worn ? l10n.takeOffButton : l10n.wearButton,
        style: small?.copyWith(fontWeight: FontWeight.w700),
      );
    } else if (!available) {
      action = Text(
        l10n.seasonReturns(season),
        style: small,
        textAlign: TextAlign.center,
      );
    } else {
      action = Semantics(
        label: l10n.coinsLabel(item.price),
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Coin(size: 20),
            const SizedBox(width: 4),
            Text(
              '${item.price}',
              style: small?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    final preview = sticker
        ? () {
            final (icon, color) = stickerLook(item);
            return StickerBadge(icon: icon, color: color, owned: owned);
          }()
        : ChiguiPortrait(size: 84, wearing: {item.slot: item.id});

    return Opacity(
      opacity: available || owned ? 1 : 0.6,
      child: Material(
        color: worn ? Palette.cloud : Palette.cloud.withValues(alpha: 0.55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: worn ? Palette.ink : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _onTap(item, l10n),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                  child: season != null && available
                      ? Text(
                          l10n.seasonName(season),
                          style: small?.copyWith(
                            color: Palette.santaRed,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: 84, child: Center(child: preview)),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    l10n.itemName(item),
                    style: small,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 36, child: Center(child: action)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
