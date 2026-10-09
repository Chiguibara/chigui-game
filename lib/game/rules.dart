import 'dart:math';

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
const bedFunGain = 0.3;
const playFunGain = 0.3;

/// Coins per fruit caught in the minigame.
const coinsPerFruit = 1;

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
/// action did not apply (e.g. feeding a full or sleeping Chigüi).
typedef Outcome = ({PetState state, List<GameEvent> events, bool ok});

/// Brings the pet up to [now]: needs decay, and the routine (mealtimes,
/// potty, bedtime) is replayed. A clock moved backwards counts as no time.
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
    final bedtimeEnd = schedule.bedtime.end;
    add(bedtimeEnd, (r) => r.bedtimeEnded(bedtimeEnd, schedule.wakeUp));
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
    if (state.asleepAt(at) || state.needsPotty) return;
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

  void bedtimeEnded(DateTime at, DateTime wakeUp) {
    final until = state.asleepUntil;
    if (until != null && until.isAtSameMomentAs(wakeUp)) return;
    state = state.copyWith(asleepUntil: wakeUp, grumpy: true);
    events.add(GameEvent(EventType.wentToBedAlone, at));
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

// Player actions. Each one first brings the pet up to [now].

Outcome pet(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  if (s.asleepAt(now)) return (state: s, events: current.events, ok: false);
  return (
    state: _raise(s, Need.affection, petGain).copyWith(grumpy: false),
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
/// one it is a snack, refused when full. Sleeping Chigüi cannot eat.
Outcome feed(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  final events = [...current.events];
  if (s.asleepAt(now)) return (state: s, events: events, ok: false);

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
  final s = current.state;
  if (!s.needsPotty) return (state: s, events: current.events, ok: false);
  return (
    state: s.copyWith(pottyUrgeSince: null),
    events: [...current.events, GameEvent(EventType.pottyInToilet, now)],
    ok: true,
  );
}

Outcome cleanUp(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  if (s.messes == 0) return (state: s, events: current.events, ok: false);
  return (
    state: s.copyWith(messes: s.messes - 1),
    events: [...current.events, GameEvent(EventType.cleaned, now)],
    ok: true,
  );
}

Outcome visitVet(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  if (!s.sick) return (state: s, events: current.events, ok: false);
  return (
    state: s.copyWith(sick: false, recentAccidents: [], missedMealsInARow: 0),
    events: [...current.events, GameEvent(EventType.vetVisit, now)],
    ok: true,
  );
}

/// Whether Chigüi is sleepy and waiting to be sent to bed.
bool wantsSleep(PetState state, DateTime now) =>
    !state.asleepAt(now) &&
    scheduleFor(now.toLocal(), state.seed).bedtime.contains(now);

Outcome sendToBed(PetState state, DateTime now) {
  final current = advance(state, now);
  final s = current.state;
  if (!wantsSleep(s, now)) return (state: s, events: current.events, ok: false);
  return (
    state: _raise(
      s,
      Need.fun,
      bedFunGain,
    ).copyWith(asleepUntil: scheduleFor(now.toLocal(), s.seed).wakeUp),
    events: [...current.events, GameEvent(EventType.sentToBed, now)],
    ok: true,
  );
}

/// A finished minigame round: more fun, plus coins for each fruit caught.
/// Chigüi cannot play while asleep.
Outcome finishRound(PetState state, DateTime now, {required int caught}) {
  final current = advance(state, now);
  final s = current.state;
  if (s.asleepAt(now)) return (state: s, events: current.events, ok: false);
  return (
    state: _raise(
      s,
      Need.fun,
      playFunGain,
    ).copyWith(coins: s.coins + caught * coinsPerFruit),
    events: [...current.events, GameEvent(EventType.played, now)],
    ok: true,
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
