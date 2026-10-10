// Shop items. Provisional prices; adjust after playtests. A round of the
// minigame earns roughly 10–20 coins and a walk 5.

/// Where an item goes. One accessory per slot can be worn at a time;
/// stickers are collected, not worn.
enum Slot { head, face, neck, body, side, sticker }

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

class Item {
  const Item(this.id, this.slot, this.price, {this.season, this.pack});

  final String id;
  final Slot slot;

  /// In coins; unused for pack items, which are never sold for coins.
  final int price;

  /// When set, the item can only be bought during this season (it can be
  /// worn at any time once owned).
  final Season? season;

  /// When set, the item only comes in this real-money pack.
  final String? pack;
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
  Item('stickerStar', Slot.sticker, 5),
  Item('stickerHeart', Slot.sticker, 5),
  Item('stickerRocket', Slot.sticker, 8),
  Item('stickerGamepad', Slot.sticker, 8),
  Item('stickerMusic', Slot.sticker, 5),
  Item('stickerIceCream', Slot.sticker, 5),
];

final itemsById = {for (final item in catalog) item.id: item};

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
