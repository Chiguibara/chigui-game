import 'package:flutter/material.dart';

import '../game/catalog.dart';
import '../l10n/app_localizations.dart';
import '../ui/palette.dart';

/// Player-facing names and texts for catalog items and seasons.
extension ItemTexts on AppLocalizations {
  String itemName(Item item) => switch (item.id) {
    'geekGlasses' => itemGeekGlasses,
    'beanie' => itemBeanie,
    'scarf' => itemScarf,
    'headphones' => itemHeadphones,
    'ghost' => itemGhost,
    'pumpkin' => itemPumpkin,
    'santaHat' => itemSantaHat,
    'xmasTree' => itemXmasTree,
    'flowerCrown' => itemFlowerCrown,
    'butterfly' => itemButterfly,
    'surfboard' => itemSurfboard,
    'snorkel' => itemSnorkel,
    'cap' => itemCap,
    'vikingHelmet' => itemVikingHelmet,
    'crown' => itemCrown,
    'mustache' => itemMustache,
    'glasses3d' => itemGlasses3d,
    'bandana' => itemBandana,
    'medal' => itemMedal,
    'cape' => itemCape,
    'balloon' => itemBalloon,
    'skateboard' => itemSkateboard,
    'retroConsole' => itemRetroConsole,
    'pixelGlasses' => itemPixelGlasses,
    'wizardHat' => itemWizardHat,
    'laptop' => itemLaptop,
    'bunnyEars' => itemBunnyEars,
    'heartGlasses' => itemHeartGlasses,
    'cupcake' => itemCupcake,
    'stickerStar' => itemStickerStar,
    'stickerHeart' => itemStickerHeart,
    'stickerRocket' => itemStickerRocket,
    'stickerGamepad' => itemStickerGamepad,
    'stickerMusic' => itemStickerMusic,
    'stickerIceCream' => itemStickerIceCream,
    _ => item.id,
  };

  String packName(Pack pack) => switch (pack.id) {
    'pack_geek' => packGeekName,
    'pack_sweet' => packSweetName,
    _ => pack.id,
  };

  String seasonName(Season season) => switch (season) {
    Season.spooktober => seasonSpooktober,
    Season.christmas => seasonChristmas,
    Season.spring => seasonSpring,
    Season.summer => seasonSummer,
  };

  String seasonReturns(Season season) => switch (season) {
    Season.spooktober => backSpooktober,
    Season.christmas => backChristmas,
    Season.spring => backSpring,
    Season.summer => backSummer,
  };

  String tooEarly(Season season) => switch (season) {
    Season.spooktober => tooEarlySpooktober,
    Season.christmas => tooEarlyChristmas,
    Season.spring => tooEarlySpring,
    Season.summer => tooEarlySummer,
  };
}

(IconData, Color) stickerLook(Item item) => switch (item.id) {
  'stickerStar' => (Icons.star, Palette.sparkle),
  'stickerHeart' => (Icons.favorite, Palette.blush),
  'stickerRocket' => (Icons.rocket_launch, Palette.diving),
  'stickerGamepad' => (Icons.sports_esports, Palette.flower),
  'stickerMusic' => (Icons.music_note, Palette.beanie),
  'stickerIceCream' => (Icons.icecream, Palette.melon),
  _ => (Icons.circle, Palette.ink),
};
