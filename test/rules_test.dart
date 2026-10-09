import 'package:chigui_game/game/game_event.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/routine.dart';
import 'package:chigui_game/game/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const seed = 42;
  // Monday 12 October 2026: meals 17:00 and 19:30, bedtime 21:00.
  final monday = DateTime(2026, 10, 12);
  DateTime at(int hour, [int minute = 0, int day = 12]) =>
      DateTime(2026, 10, day, hour, minute);
  final urges = scheduleFor(monday, seed).pottyUrges;

  PetState pet0(DateTime now, {double level = 0.8}) => PetState(
    needs: {for (final n in Need.values) n: level},
    updatedAt: now,
    seed: seed,
  );

  /// Advances in small steps, as if the game stayed open the whole time.
  Outcome play(PetState state, DateTime to) {
    final events = <GameEvent>[];
    var s = state;
    while (s.updatedAt.isBefore(to)) {
      final next = s.updatedAt.add(const Duration(minutes: 5));
      final o = advance(s, next.isBefore(to) ? next : to);
      s = o.state;
      events.addAll(o.events);
    }
    return (state: s, events: events, ok: true);
  }

  List<EventType> types(Outcome o) => [for (final e in o.events) e.type];

  group('needs', () {
    test('decay gently over time', () {
      final o = advance(pet0(at(9), level: 1), at(10));
      expect(
        o.state.level(Need.food),
        closeTo(1 - decayPerHour[Need.food]!, 1e-9),
      );
    });

    test('never drop below the floor', () {
      final o = advance(pet0(at(9), level: 1), at(9, 0, 20));
      for (final need in Need.values) {
        expect(o.state.level(need), needFloor);
      }
    });

    test('a clock moved backwards counts as no time', () {
      final o = advance(pet0(at(12), level: 0.7), at(7));
      expect(o.state.level(Need.food), 0.7);
      expect(o.events, isEmpty);
    });
  });

  group('potty', () {
    test('Chigüi needs the toilet at the urge time', () {
      final o = play(pet0(at(16)), urges.first.add(const Duration(minutes: 1)));
      expect(o.state.needsPotty, isTrue);
    });

    test('the toilet in time avoids an accident', () {
      final waiting = play(
        pet0(at(16)),
        urges.first.add(const Duration(minutes: 10)),
      ).state;
      final o = takeToToilet(waiting, waiting.updatedAt);
      expect(o.ok, isTrue);
      expect(types(o), [EventType.pottyInToilet]);
      final later = play(o.state, urges.first.add(const Duration(hours: 2)));
      expect(types(later), isNot(contains(EventType.accident)));
    });

    test('waiting too long causes an accident and a mess', () {
      final o = play(
        pet0(at(16)),
        urges.first.add(const Duration(minutes: 61)),
      );
      expect(types(o), contains(EventType.accident));
      expect(o.state.messes, 1);
      expect(o.state.needsPotty, isFalse);
    });

    test('cleaning removes a mess', () {
      final messy = pet0(at(12)).copyWith(messes: 2);
      final o = cleanUp(messy, at(12));
      expect(o.state.messes, 1);
      expect(types(o), [EventType.cleaned]);
    });
  });

  group('sickness', () {
    test('three accidents within a day make Chigüi sick', () {
      final u = urges.first;
      final s = pet0(u).copyWith(
        pottyUrgeSince: u,
        recentAccidents: [
          u.subtract(const Duration(hours: 3)),
          u.subtract(const Duration(hours: 2)),
        ],
      );
      final o = play(s, u.add(const Duration(minutes: 61)));
      expect(o.state.sick, isTrue);
      expect(types(o), contains(EventType.gotSick));
    });

    test('old accidents are forgotten', () {
      final u = urges.first;
      final s = pet0(u).copyWith(
        pottyUrgeSince: u,
        recentAccidents: [
          u.subtract(const Duration(hours: 30)),
          u.subtract(const Duration(hours: 25)),
        ],
      );
      expect(play(s, u.add(const Duration(minutes: 61))).state.sick, isFalse);
    });

    test('two missed meals in a row make Chigüi sick', () {
      final o = play(pet0(at(16, 50)), at(21, 5));
      expect(types(o).where((t) => t == EventType.mealMissed), hasLength(2));
      expect(o.state.sick, isTrue);
    });

    test('the vet cures Chigüi and resets the counters', () {
      final sick = pet0(
        at(12),
      ).copyWith(sick: true, missedMealsInARow: 2, recentAccidents: [at(11)]);
      final o = visitVet(sick, at(12));
      expect(o.state.sick, isFalse);
      expect(o.state.missedMealsInARow, 0);
      expect(o.state.recentAccidents, isEmpty);
      expect(types(o), [EventType.vetVisit]);
    });

    test('the vet does nothing for a healthy Chigüi', () {
      expect(visitVet(pet0(at(12)), at(12)).ok, isFalse);
    });
  });

  group('meals', () {
    test('feeding at mealtime is on time and avoids a missed meal', () {
      final o = feed(pet0(at(17, 10)), at(17, 10));
      expect(types(o), [EventType.mealOnTime]);
      expect(o.state.lastMealServed, at(17));
      final later = play(o.state, at(18, 40));
      expect(types(later), isNot(contains(EventType.mealMissed)));
    });

    test('a meal is never refused, even when full', () {
      final o = feed(pet0(at(17, 10), level: 1), at(17, 10));
      expect(o.ok, isTrue);
      expect(types(o), [EventType.mealOnTime]);
    });

    test('outside mealtime it is a snack, refused when full', () {
      expect(types(feed(pet0(at(12), level: 0.5), at(12))), [EventType.snack]);
      expect(feed(pet0(at(12), level: fullLevel), at(12)).ok, isFalse);
    });

    test('an on-time meal resets the missed-meals streak', () {
      final s = pet0(at(17, 10)).copyWith(missedMealsInARow: 1);
      expect(feed(s, at(17, 10)).state.missedMealsInARow, 0);
    });
  });

  group('bedtime', () {
    test('sent to bed: Chigüi sleeps until morning and has more fun', () {
      final s = pet0(at(21, 5), level: 0.5);
      expect(wantsSleep(s, at(21, 5)), isTrue);
      final o = sendToBed(s, at(21, 5));
      expect(o.ok, isTrue);
      expect(o.state.asleepAt(at(23)), isTrue);
      expect(o.state.asleepUntil, at(8, 0, 13));
      expect(o.state.level(Need.fun), closeTo(0.8, 1e-9));
      expect(types(o), [EventType.sentToBed]);

      final later = play(o.state, at(22));
      expect(later.state.grumpy, isFalse);
    });

    test('not sent: Chigüi goes to bed alone and grumpy', () {
      final o = play(pet0(at(21, 5), level: 0.5), at(21, 31));
      expect(o.state.asleepAt(at(23)), isTrue);
      expect(o.state.grumpy, isTrue);
      expect(o.state.level(Need.fun), lessThan(0.5));
      expect(types(o), contains(EventType.wentToBedAlone));
    });

    test('a sleeping Chigüi cannot be petted or fed', () {
      final asleep = pet0(at(22)).copyWith(asleepUntil: at(8, 0, 13));
      expect(pet(asleep, at(22)).ok, isFalse);
      expect(feed(asleep, at(22)).ok, isFalse);
    });

    test('a cuddle makes up for going to bed alone', () {
      final grumpy = pet0(at(9, 0, 13)).copyWith(grumpy: true);
      expect(pet(grumpy, at(9, 0, 13)).state.grumpy, isFalse);
    });

    test('bedtime is later before a free day', () {
      final friday = pet0(DateTime(2026, 10, 16, 21, 10));
      expect(wantsSleep(friday, DateTime(2026, 10, 16, 21, 10)), isFalse);
      expect(wantsSleep(friday, DateTime(2026, 10, 16, 21, 35)), isTrue);
    });
  });

  group('time away', () {
    test('counts at most one accident and one missed meal', () {
      final o = advance(pet0(at(16)), at(20, 59));
      expect(
        types(o).where((t) => t == EventType.accident).length,
        lessThanOrEqualTo(1),
      );
      expect(types(o).where((t) => t == EventType.mealMissed), hasLength(1));
      expect(o.state.sick, isFalse);
    });

    test('the routine pauses after a day without playing', () {
      final start = at(16);
      final o = advance(pet0(start), at(23, 0, 18));
      final pauseAt = start.add(routinePause);
      expect(o.events.every((e) => !e.at.isAfter(pauseAt)), isTrue);
      expect(o.state.sick, isFalse);
      expect(o.state.updatedAt, at(23, 0, 18));
    });
  });

  group('minigame', () {
    test('a round raises fun and earns a coin per fruit', () {
      final o = finishRound(pet0(at(12), level: 0.4), at(12), caught: 7);
      expect(o.ok, isTrue);
      expect(o.state.level(Need.fun), closeTo(0.4 + playFunGain, 1e-9));
      expect(o.state.coins, 7 * coinsPerFruit);
      expect(types(o), [EventType.played]);
    });

    test('playing with no fruit caught is still fun', () {
      final o = finishRound(pet0(at(12), level: 0.4), at(12), caught: 0);
      expect(o.state.level(Need.fun), greaterThan(0.4));
      expect(o.state.coins, 0);
    });

    test('a sleeping Chigüi cannot play', () {
      final asleep = pet0(at(22)).copyWith(asleepUntil: at(8, 0, 13));
      expect(finishRound(asleep, at(22), caught: 3).ok, isFalse);
    });
  });

  group('wish', () {
    test('is null when every need is fine', () {
      expect(wish(pet0(at(12), level: 0.6)), isNull);
    });

    test('picks the lowest need under the threshold', () {
      final s = pet0(
        at(12),
      ).copyWith(needs: {Need.food: 0.4, Need.affection: 0.3, Need.fun: 0.45});
      expect(wish(s), Need.affection);
    });
  });
}
