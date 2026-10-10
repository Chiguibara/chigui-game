import 'catalog.dart';

/// The three needs. Each level goes from 0 to 1, where 1 means fully
/// satisfied.
enum Need { food, affection, fun }

const _keep = Object();

class PetState {
  const PetState({
    required this.needs,
    required this.updatedAt,
    required this.seed,
    this.pottyUrgeSince,
    this.messes = 0,
    this.recentAccidents = const [],
    this.lastMealServed,
    this.missedMealsInARow = 0,
    this.sick = false,
    this.asleepUntil,
    this.grumpy = false,
    this.coins = 0,
    this.stepsToday = 0,
    this.tapStepsToday = 0,
    this.stepsDay,
    this.owned = const {},
    this.equipped = const {},
    this.ownedPacks = const {},
  });

  factory PetState.fresh(DateTime now, {required int seed}) => PetState(
    needs: {for (final need in Need.values) need: initialLevel},
    updatedAt: now,
    seed: seed,
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
  final DateTime? asleepUntil;

  /// Went to bed alone; a cuddle makes up for it.
  final bool grumpy;

  final int coins;

  /// Steps counted on [stepsDay] (a local calendar day).
  final int stepsToday;

  /// Of [stepsToday], how many came from tapping the feet.
  final int tapStepsToday;
  final DateTime? stepsDay;

  /// Ids of bought items (see `catalog`).
  final Set<String> owned;

  /// The item worn in each slot.
  final Map<Slot, String> equipped;

  /// Real-money packs owned, as last reported by the store (Google Play is
  /// the source of truth; this is the offline copy).
  final Set<String> ownedPacks;

  double level(Need need) => needs[need] ?? initialLevel;

  bool asleepAt(DateTime time) =>
      asleepUntil != null && time.isBefore(asleepUntil!);

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
    Object? asleepUntil = _keep,
    bool? grumpy,
    int? coins,
    int? stepsToday,
    int? tapStepsToday,
    DateTime? stepsDay,
    Set<String>? owned,
    Map<Slot, String>? equipped,
    Set<String>? ownedPacks,
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
    asleepUntil: identical(asleepUntil, _keep)
        ? this.asleepUntil
        : asleepUntil as DateTime?,
    grumpy: grumpy ?? this.grumpy,
    coins: coins ?? this.coins,
    stepsToday: stepsToday ?? this.stepsToday,
    tapStepsToday: tapStepsToday ?? this.tapStepsToday,
    stepsDay: stepsDay ?? this.stepsDay,
    owned: owned ?? this.owned,
    equipped: equipped ?? this.equipped,
    ownedPacks: ownedPacks ?? this.ownedPacks,
  );
}
