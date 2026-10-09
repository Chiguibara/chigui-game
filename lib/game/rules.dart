import 'pet_state.dart';

// Provisional tuning; adjust after playtests.

/// Needs never drop below this while the player is away: Chigüi can get a
/// bit peckish or bored, but is never harmed or punished.
const needFloor = 0.25;

/// How much each need drops per hour.
const decayPerHour = {Need.food: 0.08, Need.affection: 0.06, Need.fun: 0.07};

const petGain = 0.1;
const feedGain = 0.3;

/// Feeding at or above this level is politely refused.
const fullLevel = 0.95;

/// Below this level Chigüi shows what they would like.
const wishLevel = 0.5;

/// Brings needs up to [now]. Time running backwards (e.g. a changed device
/// clock) counts as no time at all.
PetState elapse(PetState state, DateTime now) {
  final hours = now.difference(state.updatedAt).inMilliseconds / 3600000;
  if (hours <= 0) return state.copyWith(updatedAt: now);
  return state.copyWith(
    needs: {
      for (final need in Need.values)
        need: _decay(state.level(need), decayPerHour[need]! * hours),
    },
    updatedAt: now,
  );
}

double _decay(double level, double amount) {
  if (level <= needFloor) return level;
  return (level - amount).clamp(needFloor, 1.0);
}

PetState pet(PetState state, DateTime now) =>
    _raise(elapse(state, now), Need.affection, petGain);

bool isFull(PetState state) => state.level(Need.food) >= fullLevel;

/// Returns the state unchanged (apart from elapsed time) when Chigüi is full.
PetState feed(PetState state, DateTime now) {
  final current = elapse(state, now);
  return isFull(current) ? current : _raise(current, Need.food, feedGain);
}

PetState _raise(PetState state, Need need, double amount) => state.copyWith(
  needs: {...state.needs, need: (state.level(need) + amount).clamp(0.0, 1.0)},
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
