import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/game_repository.dart';
import 'game_event.dart';
import 'pet_state.dart';
import 'routine.dart';
import 'rules.dart' as rules;

/// Single source of truth for the pet. Every change is saved right away, with
/// its history events, so the player can leave at any moment.
class PetController extends ChangeNotifier {
  PetController._(
    this._repository,
    this._clock,
    PetState loaded, {
    Duration debugOffset = Duration.zero,
  }) : _debugOffset = debugOffset {
    _apply(rules.advance(loaded, now));
  }

  static Future<PetController> load(
    GameRepository repository, {
    DateTime Function()? clock,
  }) async {
    final now = (clock ?? DateTime.now)();
    final saved = await repository.loadState();
    // In development, a save from a skipped-ahead clock resumes at that time.
    final ahead = saved != null && kDebugMode && saved.updatedAt.isAfter(now)
        ? saved.updatedAt.difference(now)
        : Duration.zero;
    return PetController._(
      repository,
      clock ?? DateTime.now,
      saved ?? _freshPet(now),
      debugOffset: ahead,
    );
  }

  static PetState _freshPet(DateTime now) =>
      PetState.fresh(now, seed: Random().nextInt(1 << 31));

  final GameRepository _repository;
  final DateTime Function() _clock;
  late PetState _state;
  Duration _debugOffset = Duration.zero;

  DateTime get now => _clock().add(_debugOffset);
  PetState get state => _state;

  Need? get wish => rules.wish(_state);
  bool get asleep => _state.asleepAt(now);
  bool get wantsSleep => rules.wantsSleep(_state, now);
  TimeWindow? get pendingMeal => rules.pendingMeal(_state, now);

  // Each action returns false when it did not apply.
  bool pet() => _apply(rules.pet(_state, now));
  bool feed() => _apply(rules.feed(_state, now));
  bool takeToToilet() => _apply(rules.takeToToilet(_state, now));
  bool cleanUp() => _apply(rules.cleanUp(_state, now));
  bool visitVet() => _apply(rules.visitVet(_state, now));
  bool sendToBed() => _apply(rules.sendToBed(_state, now));

  /// Catches up with the clock: call periodically and when the app resumes.
  void refresh() => _apply(rules.advance(_state, now));

  // Development only, to try the daily routine without waiting.

  /// Moves the clock forward in small steps, as if the game stayed open the
  /// whole time (so absence limits do not apply).
  void debugSkip(Duration duration) {
    assert(kDebugMode);
    const step = Duration(minutes: 5);
    final target = now.add(duration);
    final events = <GameEvent>[];
    var state = _state;
    while (now.isBefore(target)) {
      final left = target.difference(now);
      _debugOffset += left < step ? left : step;
      final outcome = rules.advance(state, now);
      state = outcome.state;
      events.addAll(outcome.events);
    }
    _apply((state: state, events: events, ok: true));
  }

  /// Jumps just past the next mealtime, potty, or bedtime change.
  void debugSkipToNextEvent() => debugSkip(
    nextRoutineMoment(now, _state.seed).difference(now) +
        const Duration(seconds: 1),
  );

  /// Starts over with a new pet at the real time.
  void debugReset() {
    assert(kDebugMode);
    _debugOffset = Duration.zero;
    _apply((state: _freshPet(now), events: const [], ok: true));
  }

  bool _apply(rules.Outcome outcome) {
    _state = outcome.state;
    _repository.saveState(_state);
    _repository.addEvents(outcome.events);
    notifyListeners();
    return outcome.ok;
  }
}
