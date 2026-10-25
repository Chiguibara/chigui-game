// Shop items. Provisional prices; adjust after playtests. A round of the
// minigame earns roughly 1–7 coins (20 a day at most) and a walk 5.

/// Where an item goes. One accessory per slot can be worn at a time;
/// stickers are collected, not worn. A seat is something Chigüi sits on.
enum Slot { head, face, neck, body, side, seat, sticker }

/// Seasons recur every year, so a seasonal item always comes back.
enum Season {
  /// 1 October – 1 November.
  spooktober,

  /// 1 December – 6 January (Three Kings' Day).
  christmas,

  /// 20 March – 20 June.
  spring,

  /// 21 June – 22 September.
  summer,
}

/// The album's themed pages; every sticker has its spot on one.
enum AlbumPage {
  food,
  space,
  games,
  nature,
  music,
  school,
  cute,
}

class Item {
  const Item(
    this.id,
    this.slot,
    this.price, {
    this.season,
    this.pack,
    this.page,
  });

  final String id;
  final Slot slot;

  /// In coins; unused for pack items, which are never sold for coins.
  final int price;

  /// When set, the item can only be bought during this season (it can be
  /// worn at any time once owned).
  final Season? season;

  /// When set, the item only comes in this real-money pack.
  final String? pack;

  /// Stickers only: the album page with its spot.
  final AlbumPage? page;
}

/// A fixed-price pack of cosmetic items sold for real money through Google
/// Play (Android only). [id] is the Google Play product id; the price shown
/// always comes from the store, in the player's currency.
class Pack {
  const Pack(this.id, this.items);

  final String id;
  final List<String> items;
}

const packs = [
  Pack('pack_geek', ['pixelGlasses', 'wizardHat', 'laptop']),
  Pack('pack_sweet', ['bunnyEars', 'heartGlasses', 'cupcake']),
];

final packsById = {for (final pack in packs) pack.id: pack};

const catalog = [
  Item('geekGlasses', Slot.face, 25),
  Item('beanie', Slot.head, 20),
  Item('scarf', Slot.neck, 20),
  Item('headphones', Slot.head, 35),
  Item('cap', Slot.head, 30),
  Item('vikingHelmet', Slot.head, 70),
  Item('crown', Slot.head, 120),
  Item('mustache', Slot.face, 30),
  Item('glasses3d', Slot.face, 40),
  Item('bandana', Slot.neck, 25),
  Item('medal', Slot.neck, 60),
  Item('cape', Slot.body, 90),
  Item('balloon', Slot.side, 35),
  Item('skateboard', Slot.side, 75),
  Item('retroConsole', Slot.side, 100),
  Item('orange', Slot.head, 20),
  Item('seagull', Slot.seat, 80),
  Item('crocodile', Slot.seat, 110),
  Item('ghost', Slot.body, 40, season: Season.spooktober),
  Item('pumpkin', Slot.side, 30, season: Season.spooktober),
  Item('santaHat', Slot.head, 35, season: Season.christmas),
  Item('xmasTree', Slot.side, 45, season: Season.christmas),
  Item('flowerCrown', Slot.head, 30, season: Season.spring),
  Item('butterfly', Slot.side, 35, season: Season.spring),
  Item('surfboard', Slot.side, 45, season: Season.summer),
  Item('snorkel', Slot.face, 35, season: Season.summer),
  Item('pixelGlasses', Slot.face, 0, pack: 'pack_geek'),
  Item('wizardHat', Slot.head, 0, pack: 'pack_geek'),
  Item('laptop', Slot.side, 0, pack: 'pack_geek'),
  Item('bunnyEars', Slot.head, 0, pack: 'pack_sweet'),
  Item('heartGlasses', Slot.face, 0, pack: 'pack_sweet'),
  Item('cupcake', Slot.side, 0, pack: 'pack_sweet'),
  Item('stickerStar', Slot.sticker, 5, page: AlbumPage.space),
  Item('stickerHeart', Slot.sticker, 5, page: AlbumPage.cute),
  Item('stickerRocket', Slot.sticker, 8, page: AlbumPage.space),
  Item('stickerGamepad', Slot.sticker, 8, page: AlbumPage.games),
  Item('stickerMusic', Slot.sticker, 5, page: AlbumPage.music),
  Item('stickerIceCream', Slot.sticker, 5, page: AlbumPage.food),
  Item('stickerPizza', Slot.sticker, 6, page: AlbumPage.food),
  Item('stickerBurger', Slot.sticker, 6, page: AlbumPage.food),
  Item('stickerRamen', Slot.sticker, 7, page: AlbumPage.food),
  Item('stickerCroissant', Slot.sticker, 5, page: AlbumPage.food),
  Item('stickerCake', Slot.sticker, 6, page: AlbumPage.food),
  Item('stickerCookie', Slot.sticker, 5, page: AlbumPage.food),
  Item('stickerCocoa', Slot.sticker, 5, page: AlbumPage.food),
  Item('stickerMoon', Slot.sticker, 5, page: AlbumPage.space),
  Item('stickerSun', Slot.sticker, 5, page: AlbumPage.space),
  Item('stickerEarth', Slot.sticker, 6, page: AlbumPage.space),
  Item('stickerSatellite', Slot.sticker, 8, page: AlbumPage.space),
  Item('stickerGalaxy', Slot.sticker, 10, page: AlbumPage.space),
  Item('stickerSparkles', Slot.sticker, 5, page: AlbumPage.space),
  Item('stickerDpad', Slot.sticker, 6, page: AlbumPage.games),
  Item('stickerRobot', Slot.sticker, 8, page: AlbumPage.games),
  Item('stickerPuzzle', Slot.sticker, 5, page: AlbumPage.games),
  Item('stickerDice', Slot.sticker, 5, page: AlbumPage.games),
  Item('stickerChip', Slot.sticker, 8, page: AlbumPage.games),
  Item('stickerKeyboard', Slot.sticker, 6, page: AlbumPage.games),
  Item('stickerTrophy', Slot.sticker, 10, page: AlbumPage.games),
  Item('stickerLeaf', Slot.sticker, 5, page: AlbumPage.nature),
  Item('stickerFlower', Slot.sticker, 5, page: AlbumPage.nature),
  Item('stickerLotus', Slot.sticker, 6, page: AlbumPage.nature),
  Item('stickerDrop', Slot.sticker, 5, page: AlbumPage.nature),
  Item('stickerWaves', Slot.sticker, 6, page: AlbumPage.nature),
  Item('stickerForest', Slot.sticker, 6, page: AlbumPage.nature),
  Item('stickerPaw', Slot.sticker, 6, page: AlbumPage.nature),
  Item('stickerBee', Slot.sticker, 7, page: AlbumPage.nature),
  Item('stickerPiano', Slot.sticker, 8, page: AlbumPage.music),
  Item('stickerHeadphones', Slot.sticker, 6, page: AlbumPage.music),
  Item('stickerMic', Slot.sticker, 6, page: AlbumPage.music),
  Item('stickerVinyl', Slot.sticker, 7, page: AlbumPage.music),
  Item('stickerPalette', Slot.sticker, 6, page: AlbumPage.music),
  Item('stickerBrush', Slot.sticker, 5, page: AlbumPage.music),
  Item('stickerMasks', Slot.sticker, 8, page: AlbumPage.music),
  Item('stickerBook', Slot.sticker, 5, page: AlbumPage.school),
  Item('stickerPencil', Slot.sticker, 5, page: AlbumPage.school),
  Item('stickerCalculator', Slot.sticker, 6, page: AlbumPage.school),
  Item('stickerFlask', Slot.sticker, 7, page: AlbumPage.school),
  Item('stickerIdea', Slot.sticker, 6, page: AlbumPage.school),
  Item('stickerBackpack', Slot.sticker, 6, page: AlbumPage.school),
  Item('stickerGradCap', Slot.sticker, 10, page: AlbumPage.school),
  Item('stickerRuler', Slot.sticker, 5, page: AlbumPage.school),
  Item('stickerRainbow', Slot.sticker, 7, page: AlbumPage.cute),
  Item('stickerCloud', Slot.sticker, 5, page: AlbumPage.cute),
  Item('stickerSmiley', Slot.sticker, 5, page: AlbumPage.cute),
  Item('stickerGift', Slot.sticker, 6, page: AlbumPage.cute),
  Item('stickerParty', Slot.sticker, 7, page: AlbumPage.cute),
  Item('stickerUmbrella', Slot.sticker, 5, page: AlbumPage.cute),
  Item('stickerDiamond', Slot.sticker, 12, page: AlbumPage.cute),
];

final itemsById = {for (final item in catalog) item.id: item};

final stickers = [
  for (final item in catalog)
    if (item.slot == Slot.sticker) item,
];

bool inSeason(Season season, DateTime now) {
  final d = now.toLocal();
  bool from(int month, int day) =>
      (d.month, d.day).compareTo((month, day)) >= 0;
  bool until(int month, int day) =>
      (d.month, d.day).compareTo((month, day)) <= 0;
  return switch (season) {
    Season.spooktober => d.month == 10 || (d.month == 11 && d.day == 1),
    Season.christmas => d.month == 12 || until(1, 6),
    Season.spring => from(3, 20) && until(6, 20),
    Season.summer => from(6, 21) && until(9, 22),
  };
}

/// When the next season starts after [now], for the dev panel.
DateTime nextSeasonStart(DateTime now) {
  final local = now.toLocal();
  final starts = [
    for (final year in [local.year, local.year + 1]) ...[
      DateTime(year, 3, 20),
      DateTime(year, 6, 21),
      DateTime(year, 10, 1),
      DateTime(year, 12, 1),
    ],
  ];
  return starts.firstWhere((s) => s.isAfter(local));
}

extension on (int, int) {
  int compareTo((int, int) other) =>
      $1 != other.$1 ? $1.compareTo(other.$1) : $2.compareTo(other.$2);
}
