import 'package:flutter/material.dart';

import '../game/catalog.dart';
import '../game/pet_controller.dart';
import '../game/rules.dart' show BuyResult;
import '../l10n/app_localizations.dart';
import '../ui/chigui_view.dart';
import '../ui/palette.dart';
import '../ui/phone_frame.dart';
import '../ui/sprites.dart';
import 'item_display.dart';

/// Buy accessories and stickers with coins, and try accessories on.
class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.controller});

  final PetController controller;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String? _message;
  Reaction? _reaction;
  int _reactionId = 0;

  PetController get _pet => widget.controller;

  void _say(String message, Reaction reaction) => setState(() {
    _message = message;
    _reaction = reaction;
    _reactionId++;
  });

  void _onTap(Item item, AppLocalizations l10n) {
    if (_pet.state.owned.contains(item.id)) {
      if (item.slot == Slot.sticker) return;
      _pet.toggleWorn(item);
      _say(l10n.shopHint, Reaction.love);
      return;
    }
    switch (_pet.canBuy(item)) {
      case BuyResult.outOfSeason:
        _say(l10n.tooEarly(item.season!), Reaction.refuse);
      case BuyResult.notEnoughCoins:
        _say(
          l10n.notEnoughCoins(item.price - _pet.state.coins),
          Reaction.refuse,
        );
      case BuyResult.bought:
        _pet.buy(item);
        _say(
          item.slot == Slot.sticker
              ? l10n.stickerBoughtStatus
              : l10n.boughtStatus,
          Reaction.love,
        );
      case BuyResult.alreadyOwned:
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
      body: PhoneFrame(
        child: ColoredBox(
          color: Palette.mint,
          child: SafeArea(
            child: ListenableBuilder(
              listenable: _pet,
              builder: (context, _) => LayoutBuilder(
                builder: (context, constraints) => CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _header(l10n, textTheme, constraints.maxWidth),
                    ),
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
                          if (item.season == null && item.slot != Slot.sticker)
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

  Widget _header(AppLocalizations l10n, TextTheme textTheme, double width) {
    final state = _pet.state;
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
          // The fitting room: Chigüi wearing the current outfit.
          ChiguiView(
            size: width * 0.42,
            wearing: state.equipped,
            reaction: _reaction,
            reactionId: _reactionId,
            onReactionEnd: () => setState(() => _reaction = null),
          ),
          Container(
            height: 2 * 1.3 * 16 * MediaQuery.textScalerOf(context).scale(1),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Semantics(
              liveRegion: true,
              child: Text(
                _message ?? l10n.shopHint,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge?.copyWith(
                  color: Palette.ink,
                  height: 1.3,
                ),
              ),
            ),
          ),
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
