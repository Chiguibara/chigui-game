import 'dart:math';

import 'achievements.dart';
import 'catalog.dart';
import 'game_event.dart';
import 'pet_state.dart';
import 'routine.dart';

// Provisional tuning; adjust after playtests.

/// How much each need drops per hour.
const decayPerHour = {Need.food: 0.08, Need.affection: 0.06, Need.fun: 0.07};

const petGain = 0.1;
const feedGain = 0.3;
const playFunGain = 0.3;

/// Minigames pay a little, so the shop lasts: fruit catch one coin per
/// [fruitsPerCoin] fruits, memory one per [pairsPerCoin] pairs,
/// hide-and-seek [coinsPerFind] per find, the bath one per
/// [spotsPerCoin] spots cleaned (rounded up), and maths up to
/// [mathCoinsPerRound] for a round all right the first time, by level: the
/// easier the level, the fewer coins.
const fruitsPerCoin = 5;
const pairsPerCoin = 2;
const coinsPerFind = 1;
const spotsPerCoin = 2;
const mathCoinsPerRound = [
  1,
  1,
  2,
  2,
  3,
  3,
  4,
  4,
];

int coinsForFruits(int caught) => caught ~/ fruitsPerCoin;

int coinsForPairs(int pairs) => pairs ~/ pairsPerCoin;

int coinsForSpots(int spots) => (spots + spotsPerCoin - 1) ~/ spotsPerCoin;

/// Coins for [right] of [questions] answered right the first time at
/// [level] (its index), in proportion and rounded.
int coinsForMath(int level, int right, int questions) =>
    (2 * right * mathCoinsPerRound[level] + questions) ~/ (2 * questions);

/// Zampafrutas: a fruit catch round with no stone bonks needs at least this
/// many fruits eaten, so standing still and dodging does not count.
const fruitMuncherFruits = 25;

/// The minigames stop giving coins after this many in a day (all games
/// together); playing stays fun (and still raises fun), the piggy bank is
/// just full until tomorrow.
const maxMinigameCoinsPerDay = 20;

bool _sameDay(DateTime? a, DateTime b) {
  final day = a?.toLocal();
  final today = b.toLocal();
  return day != null &&
      day.year == today.year &&
      day.month == today.month &&
      day.day == today.day;
}

/// Minigame coins still available today.
int minigameCoinsLeft(PetState state, DateTime now) =>
    maxMinigameCoinsPerDay -
    (_sameDay(state.minigameDay, now) ? state.minigameCoinsToday : 0);

/// Every [stepsPerWalk] steps in a day count as a walk with Chigüi, up to
/// [maxWalksPerDay]. Walks only reward; not walking costs nothing.
const stepsPerWalk = 1000;
const maxWalksPerDay = 20;

/// Tapped feet count for at most this many walks a day, so they are for
/// playing while sitting still, not for farming coins; after that Chigüi
/// is out of breath until tomorrow.
const maxTapWalksPerDay = 3;
const maxTapStepsPerDay = maxTapWalksPerDay * stepsPerWalk;

/// Fun from a walk's worth of steps, raised a little with every step: a
/// day's tapped walks fill fun up even from its lowest.
const walkFunGain = 0.35;
const coinsPerWalk = 4;

/// Without a step sensor (PCs), each tap on a foot in the walk scene counts
/// as this many steps: small, so a walk takes lots of happy, frantic taps
/// (in any order).
const stepsPerFootTap = 20;

/// Buying a seasonal item is a treat: a one-off boost of fun.
const seasonalFunGain = 0.3;

/// Snacks at or above this level are politely refused (meals never are).
const fullLevel = 0.95;

/// Below this level Chigüi shows what they would like.
const wishLevel = 0.5;

/// At or above this level a cuddle makes Chigüi fully happy.
const happyLevel = 0.8;

const accidentsToGetSick = 3;
const accidentMemory = Duration(hours: 24);
const missedMealsToGetSick = 2;

/// A gap longer than this between updates means the player was away.
const awayAfter = Duration(minutes: 10);

/// Per absence, at most this many accidents (towards getting sick) and
/// missed meals count.
const maxAccidentsWhileAway = 1;
const maxMissedMealsWhileAway = 1;

/// After this long without playing, mealtimes (and so sickness) pause until
/// the player is back. Potty accidents keep piling up, also while the game
/// is closed, so neglect has consequences: see [messesToLeave].
const routinePause = Duration(hours: 24);

/// Uncleaned accidents pile up: every this many make one huge poop.
const messesPerHugePoop = 3;

/// With this many messes (two huge poops), Chigüi has had enough of the
/// dirt: capybaras are very clean animals. If they are still there
/// [leaveAfter] later, Chigüi leaves a note and goes.
const messesToLeave = 6;
const leaveAfter = Duration(hours: 1);

/// Chigüi comes back the morning after the player, with the spot clean,
/// has left fruit, played a game, and called Chigüi on this many days...
const careDaysToComeBack = 1;

/// ...or on this many days once Chigüi is in the vet's shelter, where
/// Chigüi goes after [shelterAfter] gone without a single such day.
const careDaysFromShelter = 3;
const shelterAfter = Duration(days: 3);

/// Fruit left for Chigüi while gone piles up to this many.
const maxFoodLeft = 8;

/// The best-friends sticker takes this many days in a row with Chigüi at
/// home and no mess left at bedtime.
const bestFriendsDays = 7;

/// A new state plus what happened, for the history log. [ok] is false when an
/// action did not apply (e.g. feeding a full Chigüi).
typedef Outcome = ({PetState state, List<GameEvent> events, bool ok});

/// Brings the pet up to [now]: needs decay, and the routine (mealtimes,
/// potty) is replayed. A clock moved backwards counts as no time.
Outcome advance(PetState state, DateTime now) {
  if (!now.isAfter(state.updatedAt)) {
    return (state: state.copyWith(updatedAt: now), events: [], ok: true);
  }
  final away = now.difference(state.updatedAt) > awayAfter;
  final pauseAt = state.updatedAt.add(routinePause);
  final routineEnd = now.isBefore(pauseAt) ? now : pauseAt;

  final replay = _Replay(state, away: away);
  for (final (at, step) in _steps(
    state,
    state.updatedAt,
    now,
    mealsUntil: routineEnd,
  )) {
    replay.catchUp(at);
    step(replay);
  }
  replay.catchUp(now);
  final hours = now.difference(state.updatedAt).inMilliseconds / 3600000;
  return (
    state: replay.state.copyWith(
      needs: {
        for (final need in Need.values)
          need: _decay(state.level(need), decayPerHour[need]! * hours),
      },
      updatedAt: now,
    ),
    events: replay.events,
    ok: true,
  );
}

/// At night Chigüi sleeps, unless played with in the last [stayAwakeFor].
/// Sleeping never blocks anything: doing something together wakes them up.
bool asleep(PetState state, DateTime now) =>
    !state.gone && isNight(now, state.seed) && !state.keptAwakeAt(now);

/// Awake at night after being woken up, until falling asleep again.
bool sleepy(PetState state, DateTime now) =>
    !state.gone && isNight(now, state.seed) && state.keptAwakeAt(now);

/// Doing something together keeps (or makes) Chigüi awake for a while.
PetState _together(PetState state, DateTime now) =>
    state.copyWith(awakeUntil: now.add(stayAwakeFor));

/// Days of care still needed for Chigüi to come back.
int careDaysLeft(PetState state) => max(
  0,
  (state.inShelter ? careDaysFromShelter : careDaysToComeBack) - state.careDays,
);

/// Records [kind] of care for a gone Chigüi; a day with every kind counts.
PetState _cared(PetState state, DateTime now, Care kind) {
  if (!state.gone) return state;
  final local = now.toLocal();
  final today = DateTime(local.year, local.month, local.day);
  final sameDay = state.careDay?.isAtSameMomentAs(today) ?? false;
  final before = sameDay ? state.care : const <Care>{};
  final care = {...before, kind};
  final completed =
      care.length == Care.values.length && before.length < care.length;
  return state.copyWith(
    care: care,
    careDay: today,
    careDays: state.careDays + (completed ? 1 : 0),
  );
}

/// Brings Chigüi home once enough days of care are done and the spot is
/// clean: the morning after the last of those days (or right when the spot
/// is cleaned, if later). Chigüi eats the fruit left; back from the
/// shelter, Chigüi is a bit shy and needs cuddles again.
PetState _cameBack(PetState state, DateTime at, List<GameEvent> events) {
  final day = state.careDay;
  if (!state.gone || careDaysLeft(state) > 0 || state.messes > 0) {
    return state;
  }
  if (day == null) return state;
  final morning = scheduleFor(day.toLocal(), state.seed).wakeUp;
  if (morning.isAfter(at)) return state;
  // Clean since the last update (messes never grow while Chigüi is gone):
  // back in the morning; cleaned just now: back right away.
  final cameBack = morning.isAfter(state.updatedAt) ? morning : at;
  events.add(GameEvent(EventType.cameBack, cameBack));
  final fed = state.foodLeft > 0
      ? _raise(state, Need.food, feedGain * state.foodLeft)
      : state;
  return fed.copyWith(
    leftAt: null,
    inShelter: false,
    foodLeft: 0,
    care: {},
    careDays: 0,
    cameBackAt: cameBack,
    needs: state.inShelter ? {...fed.needs, Need.affection: 0.0} : fed.needs,
  );
}

double _decay(double level, double amount) {
  return max(0, level - amount);
}

/// Routine moments in (from, to], in time order; mealtimes only until
/// [mealsUntil].
List<(DateTime, void Function(_Replay))> _steps(
  PetState s,
  DateTime from,
  DateTime to, {
  required DateTime mealsUntil,
}) {
  final moments = <(DateTime, void Function(_Replay))>[];
  void add(DateTime time, void Function(_Replay) step, {DateTime? until}) {
    if (time.isAfter(from) && !time.isAfter(until ?? to)) {
      moments.add((time, step));
    }
  }

  final first = from.toLocal();
  for (
    var day = DateTime(first.year, first.month, first.day - 1);
    !day.isAfter(to);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    final schedule = scheduleFor(day, s.seed);
    for (final urge in schedule.pottyUrges) {
      add(urge, (r) => r.pottyUrge(urge));
      add(urge.add(pottyWait), (r) => r.pottyDeadline(urge));
    }
    for (final meal in schedule.meals) {
      add(meal.end, (r) => r.mealEnded(meal), until: mealsUntil);
    }
    add(schedule.bedtime, (r) => r.bedtime(day));
  }
  moments.sort((a, b) => a.$1.compareTo(b.$1));
  return moments;
}

class _Replay {
  _Replay(this.state, {required bool away})
    : _accidentsLeft = away ? maxAccidentsWhileAway : 1 << 30,
      _missesLeft = away ? maxMissedMealsWhileAway : 1 << 30;

  PetState state;
  final events = <GameEvent>[];
  int _accidentsLeft;
  int _missesLeft;

  void pottyUrge(DateTime at) {
    if (state.gone || asleep(state, at) || state.needsPotty) return;
    state = state.copyWith(pottyUrgeSince: at);
  }

  void pottyDeadline(DateTime urge) {
    final since = state.pottyUrgeSince;
    if (since == null || !since.isAtSameMomentAs(urge)) return;
    final at = urge.add(pottyWait);
    final messes = state.messes + 1;
    state = state.copyWith(
      pottyUrgeSince: null,
      messes: messes,
      messyAt: messes >= messesToLeave ? state.messyAt ?? at : null,
    );
    events.add(GameEvent(EventType.accident, at));
    // Beyond the cap for time away, accidents pile up but do not make
    // Chigüi sick.
    if (_accidentsLeft <= 0) return;
    _accidentsLeft--;
    state = state.copyWith(recentAccidents: [...state.recentAccidents, at]);
    _checkSick(at);
  }

  /// At bedtime, a day with Chigüi at home and no mess left adds to the run
  /// for the best-friends sticker; any other day starts it again tomorrow.
  void bedtime(DateTime day) {
    if (state.gone || state.messes > 0) {
      state = state.copyWith(
        goodSince: DateTime(day.year, day.month, day.day + 1),
      );
      return;
    }
    final since = state.goodSince ?? day;
    state = state.copyWith(goodSince: since);
    final days = DateTime(
      day.year,
      day.month,
      day.day,
    ).difference(since).inHours;
    // Hours, rounded, so a daylight saving change does not lose a day.
    if (!state.bestFriends && (days / 24).round() + 1 >= bestFriendsDays) {
      state = state.copyWith(bestFriends: true);
      events.add(GameEvent(EventType.bestFriends, schedule(day).bedtime));
    }
  }

  DaySchedule schedule(DateTime day) => scheduleFor(day, state.seed);

  /// Moments that depend on the state rather than the clock, up to [at]:
  /// coming back, leaving a dirty home, and going to the shelter.
  void catchUp(DateTime at) {
    state = _cameBack(state, at, events);
    final messyAt = state.messyAt;
    if (!state.gone && messyAt != null) {
      final leave = messyAt.add(leaveAfter);
      if (!leave.isAfter(at)) {
        state = state.copyWith(
          leftAt: leave,
          messyAt: null,
          pottyUrgeSince: null,
          sick: false,
          recentAccidents: [],
          missedMealsInARow: 0,
          foodLeft: 0,
          care: {},
          careDays: 0,
        );
        events.add(GameEvent(EventType.leftHome, leave));
      }
    }
    final leftAt = state.leftAt;
    if (leftAt != null && !state.inShelter && state.careDays == 0) {
      final shelter = leftAt.add(shelterAfter);
      if (!shelter.isAfter(at)) {
        state = state.copyWith(inShelter: true, bestFriends: false);
        events.add(GameEvent(EventType.wentToShelter, shelter));
      }
    }
  }

  void mealEnded(TimeWindow meal) {
    if (state.gone) return;
    final served = state.lastMealServed;
    if (served != null && served.isAtSameMomentAs(meal.start)) return;
    if (_missesLeft <= 0) return;
    _missesLeft--;
    state = state.copyWith(missedMealsInARow: state.missedMealsInARow + 1);
    events.add(GameEvent(EventType.mealMissed, meal.end));
    _checkSick(meal.end);
  }

  void _checkSick(DateTime at) {
    final recent = [
      for (final t in state.recentAccidents)
        if (at.difference(t) < accidentMemory) t,
    ];
    state = state.copyWith(recentAccidents: recent);
    if (state.sick) return;
    if (recent.length >= accidentsToGetSick ||
        state.missedMealsInARow >= missedMealsToGetSick) {
      state = state.copyWith(sick: true);
      events.add(GameEvent(EventType.gotSick, at));
    }
  }
}

// Player actions. Each one first brings the pet up to [now], and the ones
// done together with Chigüi wake them up.

/// Wakes Chigüi up, e.g. to play or walk; [ok] is false if already awake.
Outcome wake(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  if (s.gone) return (state: s, events: current.events, ok: false);
  return (
    state: _together(s, now),
    events: current.events,
    ok: asleep(s, now),
  );
}

/// A cuddle; with Chigüi gone, calling Chigüi back instead.
Outcome pet(PetState state, DateTime now) {
  final current = advance(state, now);
  if (current.state.gone) {
    return (
      state: _cared(current.state, now, Care.call),
      events: current.events,
      ok: true,
    );
  }
  return (
    state: _together(_raise(current.state, Need.affection, petGain), now),
    events: current.events,
    ok: true,
  );
}

/// The open mealtime at [now] that Chigüi has not eaten in yet, if any.
TimeWindow? pendingMeal(PetState state, DateTime now) {
  for (final meal in scheduleFor(now.toLocal(), state.seed).meals) {
    final served = state.lastMealServed;
    if (meal.contains(now) &&
        (served == null || !served.isAtSameMomentAs(meal.start))) {
      return meal;
    }
  }
  return null;
}

bool isFull(PetState state) => state.level(Need.food) >= fullLevel;

/// Feeding during a mealtime counts as on time and is never refused; outside
/// one it is a snack, refused when full.
Outcome feed(PetState state, DateTime now) {
  final current = advance(state, now);
  if (current.state.gone) {
    final s = current.state;
    return (
      state: _cared(
        s.copyWith(foodLeft: min(maxFoodLeft, s.foodLeft + 1)),
        now,
        Care.food,
      ),
      events: current.events,
      ok: true,
    );
  }
  final s = _together(current.state, now);
  final events = [...current.events];

  final meal = pendingMeal(s, now);
  if (meal != null) {
    events.add(GameEvent(EventType.mealOnTime, now));
    return (
      state: _raise(
        s,
        Need.food,
        feedGain,
      ).copyWith(lastMealServed: meal.start, missedMealsInARow: 0),
      events: events,
      ok: true,
    );
  }
  if (isFull(s)) return (state: s, events: events, ok: false);
  events.add(GameEvent(EventType.snack, now));
  return (state: _raise(s, Need.food, feedGain), events: events, ok: true);
}

Outcome takeToToilet(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = _together(current.state, now);
  if (!s.needsPotty) return (state: s, events: current.events, ok: false);
  return (
    state: s.copyWith(pottyUrgeSince: null),
    events: [...current.events, GameEvent(EventType.pottyInToilet, now)],
    ok: true,
  );
}

Outcome cleanUp(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = _together(current.state, now);
  if (s.messes == 0) return (state: s, events: current.events, ok: false);
  final messes = s.messes - 1;
  final events = [...current.events, GameEvent(EventType.cleaned, now)];
  final cleaned = s.copyWith(
    messes: messes,
    messyAt: messes >= messesToLeave ? s.messyAt : null,
  );
  return (state: _cameBack(cleaned, now, events), events: events, ok: true);
}

Outcome visitVet(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = _together(current.state, now);
  if (!s.sick) return (state: s, events: current.events, ok: false);
  return (
    state: s.copyWith(sick: false, recentAccidents: [], missedMealsInARow: 0),
    events: [...current.events, GameEvent(EventType.vetVisit, now)],
    ok: true,
  );
}

/// A finished minigame round: more fun, plus the [coins] it was worth, up to
/// what the daily limit allows.
/// Ends a minigame round worth [coins]; a flawless round also earns its
/// [achievement].
Outcome finishRound(
  PetState state,
  DateTime now, {
  required int coins,
  Achievement? achievement,
}) {
  final current = advance(state, now);
  final s = _cared(_together(current.state, now), now, Care.play);
  final left = max(0, minigameCoinsLeft(s, now));
  final earned = min(max(0, coins), left);
  final local = now.toLocal();
  return (
    state: _raise(s, Need.fun, playFunGain).copyWith(
      coins: s.coins + earned,
      minigameCoinsToday: maxMinigameCoinsPerDay - left + earned,
      minigameDay: DateTime(local.year, local.month, local.day),
      achievements: {...s.achievements, ?achievement},
    ),
    events: [...current.events, GameEvent(EventType.played, now)],
    ok: true,
  );
}

enum BuyResult { bought, alreadyOwned, outOfSeason, notEnoughCoins, onlyInPack }

BuyResult canBuy(PetState state, Item item, DateTime now) {
  if (state.owned.contains(item.id)) return BuyResult.alreadyOwned;
  if (item.pack != null) return BuyResult.onlyInPack;
  final season = item.season;
  if (season != null && !inSeason(season, now)) return BuyResult.outOfSeason;
  if (state.coins < item.price) return BuyResult.notEnoughCoins;
  return BuyResult.bought;
}

/// Buys [item] and puts it on (accessories only).
Outcome buy(PetState state, DateTime now, Item item) {
  final current = advance(state, now);
  final s = current.state;
  if (canBuy(s, item, now) != BuyResult.bought) {
    return (state: s, events: current.events, ok: false);
  }
  var next = s.copyWith(
    coins: s.coins - item.price,
    owned: {...s.owned, item.id},
    equipped: item.slot == Slot.sticker
        ? s.equipped
        : {...s.equipped, item.slot: item.id},
  );
  if (item.season != null) next = _raise(next, Need.fun, seasonalFunGain);
  if (stickers.every((s) => next.owned.contains(s.id))) {
    next = next.copyWith(
      achievements: {...next.achievements, Achievement.collector},
    );
  }
  return (
    state: next,
    events: [...current.events, GameEvent(EventType.bought, now)],
    ok: true,
  );
}

/// Puts on an owned accessory, or takes it off if already worn.
PetState toggleWorn(PetState state, Item item) {
  if (!state.owned.contains(item.id) || item.slot == Slot.sticker) {
    return state;
  }
  final worn = state.equipped[item.slot] == item.id;
  return state.copyWith(
    equipped: {
      for (final e in state.equipped.entries)
        if (e.key != item.slot) e.key: e.value,
      if (!worn) item.slot: item.id,
    },
  );
}

/// Owned stickers not stuck in the album yet, in catalog order.
List<Item> looseStickers(PetState state) => [
  for (final item in catalog)
    if (item.slot == Slot.sticker &&
        state.owned.contains(item.id) &&
        !state.stuckStickers.contains(item.id))
      item,
];

/// Sticks an owned sticker in its spot in the album.
PetState stickSticker(PetState state, Item item) {
  if (!looseStickers(state).contains(item)) return state;
  return state.copyWith(stuckStickers: {...state.stuckStickers, item.id});
}

/// Stickers added to the catalog since the player last looked.
List<Item> newStickers(PetState state) => [
  for (final item in stickers)
    if (!state.seenStickers.contains(item.id)) item,
];

/// The player has seen every sticker in the catalog.
PetState sawStickers(PetState state) => state.copyWith(
  seenStickers: {...state.seenStickers, for (final item in stickers) item.id},
);

/// Walks completed today (capped at [maxWalksPerDay]).
int walksToday(PetState state, DateTime now) => walksFor(stepsOn(state, now));

/// Gives the items of a pack the store says was just bought.
Outcome grantPack(PetState state, DateTime now, Pack pack) {
  if (state.ownedPacks.contains(pack.id)) {
    return (state: state, events: [], ok: false);
  }
  return (
    state: _withPack(state, pack),
    events: [GameEvent(EventType.packBought, now)],
    ok: true,
  );
}

/// Matches owned packs to what the store reports: restores packs bought
/// elsewhere (e.g. a new phone) and removes refunded ones, taking their
/// items off.
Outcome syncPacks(PetState state, DateTime now, Set<String> fromStore) {
  var s = state;
  final events = <GameEvent>[];
  for (final pack in packs) {
    final owned = s.ownedPacks.contains(pack.id);
    final reported = fromStore.contains(pack.id);
    if (reported && !owned) s = _withPack(s, pack);
    if (owned && !reported) {
      s = s.copyWith(
        ownedPacks: {...s.ownedPacks}..remove(pack.id),
        owned: {...s.owned}..removeAll(pack.items),
        equipped: {
          for (final e in s.equipped.entries)
            if (!pack.items.contains(e.value)) e.key: e.value,
        },
      );
      events.add(GameEvent(EventType.packRemoved, now));
    }
  }
  return (state: s, events: events, ok: true);
}

PetState _withPack(PetState state, Pack pack) => state.copyWith(
  ownedPacks: {...state.ownedPacks, pack.id},
  owned: {...state.owned, ...pack.items},
);

int walksFor(int steps) => min(steps ~/ stepsPerWalk, maxWalksPerDay);

bool _sameStepsDay(PetState state, DateTime now) =>
    _sameDay(state.stepsDay, now);

/// Steps counted today so far (real and tapped), from zero each new day.
int stepsOn(PetState state, DateTime now) =>
    _sameStepsDay(state, now) ? state.stepsToday : 0;

/// How many more tapped steps count today.
int tapStepsLeft(PetState state, DateTime now) =>
    maxTapStepsPerDay - (_sameStepsDay(state, now) ? state.tapStepsToday : 0);

/// Steps from the pedometer or motion sensor, or ([tapped]) from tapping the
/// feet, which only count up to [maxTapStepsPerDay]. Each new walk reached
/// today raises fun and earns coins. [ok] is true when at least one new walk
/// was completed.
Outcome addSteps(
  PetState state,
  DateTime now,
  int steps, {
  bool tapped = false,
}) {
  final current = advance(state, now);
  final s = current.state;
  var counted = steps > 0 ? steps : 0;
  if (tapped) counted = min(counted, max(0, tapStepsLeft(s, now)));
  final before = stepsOn(s, now);
  final after = before + counted;
  final walks = walksFor(after) - walksFor(before);
  final local = now.toLocal();
  final tappedBefore = _sameStepsDay(s, now) ? s.tapStepsToday : 0;
  final next = s.copyWith(
    stepsToday: after,
    tapStepsToday: tappedBefore + (tapped ? counted : 0),
    stepsDay: DateTime(local.year, local.month, local.day),
    coins: s.coins + walks * coinsPerWalk,
  );
  return (
    state: _raise(next, Need.fun, walkFunGain * counted / stepsPerWalk),
    events: [
      ...current.events,
      for (var i = 0; i < walks; i++) GameEvent(EventType.walked, now),
    ],
    ok: walks > 0,
  );
}

PetState _raise(PetState state, Need need, double amount) => state.copyWith(
  needs: {...state.needs, need: min(1.0, state.level(need) + amount)},
);

/// The need Chigüi would most like help with, if any is low enough to show.
Need? wish(PetState state) {
  if (state.gone) return null;
  Need? lowest;
  for (final need in Need.values) {
    if (state.level(need) < wishLevel &&
        (lowest == null || state.level(need) < state.level(lowest))) {
      lowest = need;
    }
  }
  return lowest;
}

/// Longest name Chigüi can be given, in characters (Unicode code points).
const maxPetNameLength = 12;

/// [name] tidied up (spaces trimmed and collapsed, cut to
/// [maxPetNameLength]), or null when nothing is left.
String? cleanPetName(String name) {
  final clean = name.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (clean.isEmpty) return null;
  final runes = clean.runes;
  return runes.length <= maxPetNameLength
      ? clean
      : String.fromCharCodes(runes.take(maxPetNameLength)).trimRight();
}

/// When the name can next be changed: now for a new game's free naming or
/// a month without a change, otherwise the first day of next month.
DateTime nextRename(PetState state, DateTime now) {
  final last = state.renamedAt?.toLocal();
  final local = now.toLocal();
  if (state.freeRename ||
      last == null ||
      (last.year, last.month) != (local.year, local.month)) {
    return now;
  }
  return DateTime(local.year, local.month + 1);
}

bool canRename(PetState state, DateTime now) =>
    !nextRename(state, now).isAfter(now);

/// Gives Chigüi a new name: a new game's free naming first, then once a
/// calendar month.
Outcome rename(PetState state, DateTime now, String name) {
  final clean = cleanPetName(name);
  if (clean == null || !canRename(state, now)) {
    return (state: state, events: const [], ok: false);
  }
  return (
    state: state.freeRename
        ? state.copyWith(name: clean, freeRename: false)
        : state.copyWith(name: clean, renamedAt: now),
    events: const [],
    ok: true,
  );
}
