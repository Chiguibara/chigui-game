import 'achievements.dart';
import 'catalog.dart';

/// The three needs. Each level goes from 0 to 1, where 1 means fully
/// satisfied.
enum Need { food, affection, fun }

/// What the player did for Chigüi on a day while Chigüi was gone: fruit
/// left, a game played, and a call.
enum Care { food, play, call }

const _keep = Object();

class PetState {
  PetState({
    required this.needs,
    required this.updatedAt,
    required this.seed,
    this.pottyUrgeSince,
    this.messes = 0,
    this.recentAccidents = const [],
    this.lastMealServed,
    this.missedMealsInARow = 0,
    this.sick = false,
    this.awakeUntil,
    this.coins = 0,
    this.stepsToday = 0,
    this.tapStepsToday = 0,
    this.minigameCoinsToday = 0,
    this.minigameDay,
    this.stepsDay,
    this.owned = const {},
    this.equipped = const {},
    this.stuckStickers = const {},
    Set<String>? seenStickers,
    this.ownedPacks = const {},
    this.seenNotes,
    this.achievements = const {},
    this.name,
    this.renamedAt,
    this.freeRename = false,
    this.messyAt,
    this.leftAt,
    this.inShelter = false,
    this.foodLeft = 0,
    this.care = const {},
    this.careDay,
    this.careDays = 0,
    this.cameBackAt,
    this.goodSince,
    this.bestFriends = false,
  }) : seenStickers = seenStickers ?? {for (final item in stickers) item.id};

  factory PetState.fresh(DateTime now, {required int seed}) => PetState(
    needs: {for (final need in Need.values) need: initialLevel},
    updatedAt: now,
    seed: seed,
    freeRename: true,
  );

  static const initialLevel = 0.8;

  final Map<Need, double> needs;

  /// Everything (needs and routine) has been brought up to this moment.
  final DateTime updatedAt;

  /// Makes each player's random routine (e.g. potty times) different but
  /// reproducible.
  final int seed;

  /// When the current potty urge started, if Chigüi needs to go.
  final DateTime? pottyUrgeSince;

  /// Accidents not cleaned up yet.
  final int messes;

  /// Accidents in roughly the last day, to decide if Chigüi gets sick.
  final List<DateTime> recentAccidents;

  /// Start of the last mealtime window in which Chigüi was fed.
  final DateTime? lastMealServed;

  final int missedMealsInARow;
  final bool sick;

  /// At night, Chigüi stays awake until then after being played with.
  final DateTime? awakeUntil;

  final int coins;

  /// Steps counted on [stepsDay] (a local calendar day).
  final int stepsToday;

  /// Of [stepsToday], how many came from tapping the feet.
  final int tapStepsToday;

  /// Coins the minigame gave on [minigameDay] (a local calendar day).
  final int minigameCoinsToday;
  final DateTime? minigameDay;
  final DateTime? stepsDay;

  /// Ids of bought items (see `catalog`).
  final Set<String> owned;

  /// The item worn in each slot.
  final Map<Slot, String> equipped;

  /// Owned stickers already stuck in the album; the rest are loose.
  final Set<String> stuckStickers;

  /// Stickers the player already knows about; any others in the catalog
  /// came with an update and are announced as new. Defaults to all of today's.
  final Set<String> seenStickers;

  /// Real-money packs owned, as last reported by the store (Google Play is
  /// the source of truth; this is the offline copy).
  final Set<String> ownedPacks;

  /// Fingerprint of the last "What's new" notes shown (see `whats_new.dart`);
  /// null in saves from before the game showed them.
  final String? seenNotes;

  /// Achievements earned, for good.
  final Set<Achievement> achievements;

  /// The name the player gave Chigüi; null keeps "Chigüi".
  final String? name;

  /// When the name was last changed with the monthly change.
  final DateTime? renamedAt;

  /// A new game may name Chigüi once without using the month's change.
  final bool freeRename;

  /// When the messes reached two huge poops; Chigüi leaves a while later
  /// if they are still there.
  final DateTime? messyAt;

  /// When Chigüi left a dirty home; null while Chigüi is here.
  final DateTime? leftAt;

  /// Gone so long that Chigüi went to the vet's shelter.
  final bool inShelter;

  /// Fruit the player left for Chigüi while gone, piling up in the spot.
  final int foodLeft;

  /// What the player did for Chigüi on [careDay] while Chigüi was gone.
  final Set<Care> care;

  /// The local day of [care].
  final DateTime? careDay;

  /// Days on which the player did every kind of [Care] since Chigüi left.
  final int careDays;

  /// When Chigüi last came back home.
  final DateTime? cameBackAt;

  /// The local day the current run of well-cared-for days started.
  final DateTime? goodSince;

  /// The best-friends sticker: earned with a run of well-cared-for days,
  /// lost if Chigüi goes to the shelter, and earned again the same way.
  final bool bestFriends;

  bool get gone => leftAt != null;

  double level(Need need) => needs[need] ?? initialLevel;

  bool keptAwakeAt(DateTime time) =>
      awakeUntil != null && time.isBefore(awakeUntil!);

  bool get needsPotty => pottyUrgeSince != null;

  PetState copyWith({
    Map<Need, double>? needs,
    DateTime? updatedAt,
    Object? pottyUrgeSince = _keep,
    int? messes,
    List<DateTime>? recentAccidents,
    Object? lastMealServed = _keep,
    int? missedMealsInARow,
    bool? sick,
    DateTime? awakeUntil,
    int? coins,
    int? stepsToday,
    int? tapStepsToday,
    int? minigameCoinsToday,
    DateTime? minigameDay,
    DateTime? stepsDay,
    Set<String>? owned,
    Map<Slot, String>? equipped,
    Set<String>? stuckStickers,
    Set<String>? seenStickers,
    Set<String>? ownedPacks,
    String? seenNotes,
    Set<Achievement>? achievements,
    String? name,
    DateTime? renamedAt,
    bool? freeRename,
    Object? messyAt = _keep,
    Object? leftAt = _keep,
    bool? inShelter,
    int? foodLeft,
    Set<Care>? care,
    DateTime? careDay,
    int? careDays,
    DateTime? cameBackAt,
    DateTime? goodSince,
    bool? bestFriends,
  }) => PetState(
    needs: needs ?? this.needs,
    updatedAt: updatedAt ?? this.updatedAt,
    seed: seed,
    pottyUrgeSince: identical(pottyUrgeSince, _keep)
        ? this.pottyUrgeSince
        : pottyUrgeSince as DateTime?,
    messes: messes ?? this.messes,
    recentAccidents: recentAccidents ?? this.recentAccidents,
    lastMealServed: identical(lastMealServed, _keep)
        ? this.lastMealServed
        : lastMealServed as DateTime?,
    missedMealsInARow: missedMealsInARow ?? this.missedMealsInARow,
    sick: sick ?? this.sick,
    awakeUntil: awakeUntil ?? this.awakeUntil,
    coins: coins ?? this.coins,
    stepsToday: stepsToday ?? this.stepsToday,
    tapStepsToday: tapStepsToday ?? this.tapStepsToday,
    minigameCoinsToday: minigameCoinsToday ?? this.minigameCoinsToday,
    minigameDay: minigameDay ?? this.minigameDay,
    stepsDay: stepsDay ?? this.stepsDay,
    owned: owned ?? this.owned,
    equipped: equipped ?? this.equipped,
    stuckStickers: stuckStickers ?? this.stuckStickers,
    seenStickers: seenStickers ?? this.seenStickers,
    ownedPacks: ownedPacks ?? this.ownedPacks,
    seenNotes: seenNotes ?? this.seenNotes,
    achievements: achievements ?? this.achievements,
    name: name ?? this.name,
    renamedAt: renamedAt ?? this.renamedAt,
    freeRename: freeRename ?? this.freeRename,
    messyAt: identical(messyAt, _keep) ? this.messyAt : messyAt as DateTime?,
    leftAt: identical(leftAt, _keep) ? this.leftAt : leftAt as DateTime?,
    inShelter: inShelter ?? this.inShelter,
    foodLeft: foodLeft ?? this.foodLeft,
    care: care ?? this.care,
    careDay: careDay ?? this.careDay,
    careDays: careDays ?? this.careDays,
    cameBackAt: cameBackAt ?? this.cameBackAt,
    goodSince: goodSince ?? this.goodSince,
    bestFriends: bestFriends ?? this.bestFriends,
  );
}
