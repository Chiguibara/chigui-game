import 'dart:math';

import 'catalog.dart';
import 'game_event.dart';
import 'pet_state.dart';
import 'routine.dart';

// Provisional tuning; adjust after playtests.

/// Needs never drop below this on their own.
const needFloor = 0.25;

/// How much each need drops per hour.
const decayPerHour = {Need.food: 0.08, Need.affection: 0.06, Need.fun: 0.07};

const petGain = 0.1;
const feedGain = 0.3;
const playFunGain = 0.3;

/// Minigames pay a little, so the shop lasts: fruit catch one coin per
/// [fruitsPerCoin] fruits, memory one per [pairsPerCoin] pairs,
/// hide-and-seek [coinsPerFind] per find, and the bath one per
/// [spotsPerCoin] spots cleaned (rounded up).
const fruitsPerCoin = 5;
const pairsPerCoin = 2;
const coinsPerFind = 1;
const spotsPerCoin = 2;

int coinsForFruits(int caught) => caught ~/ fruitsPerCoin;

int coinsForPairs(int pairs) => pairs ~/ pairsPerCoin;

int coinsForSpots(int spots) => (spots + spotsPerCoin - 1) ~/ spotsPerCoin;

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

/// Per absence, at most this many accidents and missed meals count.
const maxAccidentsWhileAway = 1;
const maxMissedMealsWhileAway = 1;

/// After this long without playing, the routine pauses until the player is
/// back, so a holiday never ends with a sick Chigüi.
const routinePause = Duration(hours: 24);

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
  for (final step in _steps(state, state.updatedAt, routineEnd)) {
    step(replay);
  }
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
    isNight(now, state.seed) && !state.keptAwakeAt(now);

/// Awake at night after being woken up, until falling asleep again.
bool sleepy(PetState state, DateTime now) =>
    isNight(now, state.seed) && state.keptAwakeAt(now);

/// Doing something together keeps (or makes) Chigüi awake for a while.
PetState _together(PetState state, DateTime now) =>
    state.copyWith(awakeUntil: now.add(stayAwakeFor));

double _decay(double level, double amount) {
  if (level <= needFloor) return level;
  return max(needFloor, level - amount);
}

/// Routine moments in (from, to], in time order.
List<void Function(_Replay)> _steps(PetState s, DateTime from, DateTime to) {
  final moments = <(DateTime, void Function(_Replay))>[];
  void add(DateTime time, void Function(_Replay) step) {
    if (time.isAfter(from) && !time.isAfter(to)) moments.add((time, step));
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
      add(meal.end, (r) => r.mealEnded(meal));
    }
  }
  moments.sort((a, b) => a.$1.compareTo(b.$1));
  return [for (final m in moments) m.$2];
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
    if (asleep(state, at) || state.needsPotty) return;
    state = state.copyWith(pottyUrgeSince: at);
  }

  void pottyDeadline(DateTime urge) {
    final since = state.pottyUrgeSince;
    if (since == null || !since.isAtSameMomentAs(urge)) return;
    final at = urge.add(pottyWait);
    state = state.copyWith(pottyUrgeSince: null);
    // Beyond the cap for time away, Chigüi manages alone.
    if (_accidentsLeft <= 0) return;
    _accidentsLeft--;
    state = state.copyWith(
      messes: state.messes + 1,
      recentAccidents: [...state.recentAccidents, at],
    );
    events.add(GameEvent(EventType.accident, at));
    _checkSick(at);
  }

  void mealEnded(TimeWindow meal) {
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
  return (
    state: _together(s, now),
    events: current.events,
    ok: asleep(s, now),
  );
}

Outcome pet(PetState state, DateTime now) {
  final current = advance(state, now);
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
  return (
    state: s.copyWith(messes: s.messes - 1),
    events: [...current.events, GameEvent(EventType.cleaned, now)],
    ok: true,
  );
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
Outcome finishRound(PetState state, DateTime now, {required int coins}) {
  final current = advance(state, now);
  final s = _together(current.state, now);
  final left = max(0, minigameCoinsLeft(s, now));
  final earned = min(max(0, coins), left);
  final local = now.toLocal();
  return (
    state: _raise(s, Need.fun, playFunGain).copyWith(
      coins: s.coins + earned,
      minigameCoinsToday: maxMinigameCoinsPerDay - left + earned,
      minigameDay: DateTime(local.year, local.month, local.day),
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
  Need? lowest;
  for (final need in Need.values) {
    if (state.level(need) < wishLevel &&
        (lowest == null || state.level(need) < state.level(lowest))) {
      lowest = need;
    }
  }
  return lowest;
}
