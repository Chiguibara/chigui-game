import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/catalog.dart';
import '../game/pet_controller.dart';
import '../l10n/app_localizations.dart';
import '../shop/item_display.dart';
import '../sound/sound_effects.dart';
import 'game_frame.dart';
import 'palette.dart';
import 'sprites.dart';

/// The sticker album: one spot per sticker in the catalog, and the bought
/// ones lying loose below until the player drags each onto its spot.
class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.controller});

  final PetController controller;

  static const stickerSize = 64.0;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  /// The last thing that happened, shown instead of the default message.
  String? _message;

  /// A loose sticker that was tapped: its spot lights up.
  Item? _hinted;

  PetController get _pet => widget.controller;

  void _stick(Item item, AppLocalizations l10n) {
    _pet.stickSticker(item);
    sfx.play(Sfx.sparkle);
    final complete = stickers.every(
      (s) => _pet.state.stuckStickers.contains(s.id),
    );
    setState(() {
      _hinted = null;
      _message = complete
          ? l10n.albumComplete
          : _pet.looseStickers.isEmpty
          ? l10n.albumAllStuck
          : l10n.albumStuck;
    });
  }

  void _hint(Item item) {
    sfx.play(Sfx.pop);
    setState(() => _hinted = item);
  }

  String _status(AppLocalizations l10n) {
    if (_message case final message?) return message;
    final state = _pet.state;
    if (_pet.looseStickers.isNotEmpty) return l10n.albumHint;
    if (state.stuckStickers.isEmpty) return l10n.albumEmpty;
    return state.stuckStickers.length == stickers.length
        ? l10n.albumComplete
        : l10n.albumAllStuck;
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
            child: ListenableBuilder(
              listenable: _pet,
              builder: (context, _) => Column(
                children: [
                  _header(l10n, textTheme),
                  _statusLine(l10n, textTheme),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => isWide(constraints)
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _page(l10n, textTheme),
                                ),
                                Expanded(flex: 2, child: _loose(l10n)),
                              ],
                            )
                          : Column(
                              children: [
                                _page(l10n, textTheme),
                                Expanded(child: _loose(l10n)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n, TextTheme textTheme) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
    child: Row(
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
            l10n.albumTitle,
            style: textTheme.titleLarge?.copyWith(
              color: Palette.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _statusLine(AppLocalizations l10n, TextTheme textTheme) {
    final style = textTheme.titleMedium?.copyWith(
      color: Palette.ink,
      height: 1.3,
    );
    // Two lines reserved so the album never moves under the player's finger.
    return Container(
      height:
          2 *
          1.3 *
          (style?.fontSize ?? 16) *
          MediaQuery.textScalerOf(context).scale(1),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  /// The album page, with a spot for every sticker. Shrinks to fit short
  /// screens rather than scrolling, so dragging never fights a scroll.
  Widget _page(AppLocalizations l10n, TextTheme textTheme) => Padding(
    padding: const EdgeInsets.all(16),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        // Three spots a row, plus padding and border.
        width: 3 * 96 + 2 * 8 + 2 * 16 + 2 * 2,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Palette.cloud,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Palette.ink.withValues(alpha: 0.15),
            width: 2,
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 12,
          children: [
            for (final item in stickers) _spot(item, l10n, textTheme),
          ],
        ),
      ),
    ),
  );

  Widget _spot(Item item, AppLocalizations l10n, TextTheme textTheme) {
    final (icon, color) = stickerLook(item);
    final stuck = _pet.state.stuckStickers.contains(item.id);
    return SizedBox(
      width: 96,
      child: Column(
        children: [
          DragTarget<Item>(
            onWillAcceptWithDetails: (details) => details.data == item,
            onAcceptWithDetails: (details) => _stick(details.data, l10n),
            builder: (context, candidates, _) {
              final lit = candidates.isNotEmpty || _hinted == item;
              return AnimatedScale(
                scale: lit ? 1.15 : 1,
                duration: const Duration(milliseconds: 150),
                child: stuck
                    ? Transform.rotate(
                        angle: _tilt(item),
                        child: StickerBadge(
                          icon: icon,
                          color: color,
                          size: AlbumScreen.stickerSize,
                        ),
                      )
                    : Container(
                        width: AlbumScreen.stickerSize,
                        height: AlbumScreen.stickerSize,
                        decoration: BoxDecoration(
                          color: Palette.ink.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: lit
                                ? Palette.ink
                                : Palette.ink.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                        // A faint outline shows which sticker goes here.
                        child: Icon(
                          icon,
                          size: AlbumScreen.stickerSize * 0.6,
                          color: Palette.ink.withValues(alpha: 0.15),
                        ),
                      ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            l10n.itemName(item),
            style: textTheme.bodySmall?.copyWith(
              color: Palette.ink.withValues(alpha: stuck ? 1 : 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// The bought stickers not stuck yet, scattered as if just dropped there.
  Widget _loose(AppLocalizations l10n) => Center(
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 12,
      children: [
        for (final item in _pet.looseStickers) _looseSticker(item, l10n),
      ],
    ),
  );

  Widget _looseSticker(Item item, AppLocalizations l10n) {
    final (icon, color) = stickerLook(item);
    final sticker = StickerBadge(
      icon: icon,
      color: color,
      size: AlbumScreen.stickerSize,
    );
    return Padding(
      // Uneven heights and tilts, so they look scattered.
      padding: EdgeInsets.only(top: 4 + 20 * _jitter(item)),
      child: Transform.rotate(
        angle: _tilt(item) * 3,
        child: Semantics(
          label: l10n.itemName(item),
          button: true,
          child: Draggable<Item>(
            data: item,
            onDragStarted: () => _hint(item),
            feedback: Transform.scale(scale: 1.2, child: sticker),
            childWhenDragging: Opacity(opacity: 0.25, child: sticker),
            child: GestureDetector(onTap: () => _hint(item), child: sticker),
          ),
        ),
      ),
    );
  }

  /// A stable number in [0, 1) per sticker, for its scattered look.
  static double _jitter(Item item) =>
      item.id.codeUnits.fold(7, (a, c) => (a * 31 + c) % 1000) / 1000;

  /// A small, stable tilt per sticker.
  static double _tilt(Item item) => (_jitter(item) - 0.5) * math.pi / 15;
}
