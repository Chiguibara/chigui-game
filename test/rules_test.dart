import 'package:chigui_game/game/catalog.dart';
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

  group('night', () {
    test('Chigüi falls asleep alone at bedtime until morning', () {
      final s = pet0(at(20, 30));
      expect(asleep(s, at(20, 59)), isFalse);
      final o = play(s, at(21, 5));
      expect(asleep(o.state, at(21, 5)), isTrue);
      expect(o.state.level(Need.fun), greaterThan(0.7));
      expect(asleep(o.state, at(7, 59, 13)), isTrue);
      expect(asleep(o.state, at(8, 0, 13)), isFalse);
    });

    test('a new game at night starts with Chigüi asleep', () {
      final o = advance(pet0(at(1, 35, 13)), at(1, 35, 13));
      expect(asleep(o.state, at(1, 35, 13)), isTrue);
      expect(o.events, isEmpty);
    });

    test('after the routine paused, Chigüi is asleep at night too', () {
      // Last played on Sunday at 20:00: the routine paused on Monday at 20:00,
      // before Monday's bedtime.
      final o = advance(pet0(at(20, 0, 11)), at(1, 35, 13));
      expect(asleep(o.state, at(1, 35, 13)), isTrue);
    });

    test('sleeping never blocks anything, it wakes Chigüi up', () {
      final s = pet0(at(22), level: 0.5);
      expect(asleep(s, at(22)), isTrue);
      for (final o in [
        pet(s, at(22)),
        feed(s, at(22)),
        finishRound(s, at(22), caught: 4),
        wake(s, at(22)),
      ]) {
        expect(o.ok, isTrue);
        expect(asleep(o.state, at(22)), isFalse);
        expect(sleepy(o.state, at(22)), isTrue);
      }
      expect(finishRound(s, at(22), caught: 4).state.coins, 2);
    });

    test('an hour after the last thing done together, sleep again', () {
      final woken = pet(pet0(at(22)), at(22)).state;
      expect(asleep(woken, at(22, 59)), isFalse);
      final cuddled = pet(woken, at(22, 30)).state;
      expect(asleep(cuddled, at(23, 29)), isFalse);
      expect(asleep(cuddled, at(23, 30)), isTrue);
      expect(sleepy(cuddled, at(23, 30)), isFalse);
    });

    test('played with just before bedtime, Chigüi stays up a bit', () {
      final s = pet(pet0(at(20, 45)), at(20, 45)).state;
      expect(asleep(s, at(21, 10)), isFalse);
      expect(sleepy(s, at(21, 10)), isTrue);
      expect(asleep(s, at(21, 45)), isTrue);
    });

    test('waking an awake Chigüi does nothing', () {
      expect(wake(pet0(at(12)), at(12)).ok, isFalse);
      expect(sleepy(pet(pet0(at(12)), at(12)).state, at(12, 5)), isFalse);
    });

    test('bedtime is later before a free day', () {
      final friday = pet0(DateTime(2026, 10, 16, 21, 10));
      expect(asleep(friday, DateTime(2026, 10, 16, 21, 10)), isFalse);
      expect(asleep(friday, DateTime(2026, 10, 16, 21, 35)), isTrue);
      expect(asleep(friday, DateTime(2026, 10, 17, 8, 30)), isTrue);
      expect(asleep(friday, DateTime(2026, 10, 17, 9)), isFalse);
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
      expect(o.state.coins, 3, reason: 'one coin per two fruits');
      expect(types(o), [EventType.played]);
    });

    test('coins stop at the daily limit; playing stays fun', () {
      var s = pet0(at(12), level: 0.2);
      var total = 0;
      for (var i = 0; i < 4; i++) {
        s = finishRound(s, at(12, i), caught: 20).state; // 10 coins each
        total = s.coins;
      }
      expect(total, maxMinigameCoinsPerDay);
      expect(minigameCoinsLeft(s, at(13)), 0);
      expect(s.level(Need.fun), 1.0, reason: "fun keeps rising");
      // A new day fills the piggy bank again.
      expect(minigameCoinsLeft(s, at(12, 0, 13)), maxMinigameCoinsPerDay);
      expect(
        finishRound(s, at(12, 0, 13), caught: 20).state.coins,
        maxMinigameCoinsPerDay + 10,
      );
    });

    test('playing with no fruit caught is still fun', () {
      final o = finishRound(pet0(at(12), level: 0.4), at(12), caught: 0);
      expect(o.state.level(Need.fun), greaterThan(0.4));
      expect(o.state.coins, 0);
    });
  });

  group('walks', () {
    test('tapped feet count for at most three walks a day', () {
      final o = addSteps(pet0(at(12)), at(12), 5000, tapped: true);
      expect(o.state.stepsToday, maxTapStepsPerDay);
      expect(o.state.coins, maxTapWalksPerDay * coinsPerWalk);
      expect(tapStepsLeft(o.state, at(12)), 0);
      expect(addSteps(o.state, at(13), 50, tapped: true).ok, isFalse);

      // Real steps still count, and the taps come back tomorrow.
      final walked = addSteps(o.state, at(14), 1000);
      expect(walked.ok, isTrue);
      expect(tapStepsLeft(walked.state, at(9, 0, 13)), maxTapStepsPerDay);
    });

    test('every 1000 steps is a walk: more fun and coins', () {
      final o = addSteps(pet0(at(12), level: 0.4), at(12), 2500);
      expect(o.ok, isTrue);
      expect(o.state.stepsToday, 2500);
      expect(o.state.coins, 2 * coinsPerWalk);
      expect(o.state.level(Need.fun), closeTo(0.4 + 2 * walkFunGain, 1e-9));
      expect(types(o), [EventType.walked, EventType.walked]);
    });

    test('steps add up during the day', () {
      final first = addSteps(pet0(at(12)), at(12), 600).state;
      final o = addSteps(first, at(13), 600);
      expect(o.ok, isTrue);
      expect(stepsOn(o.state, at(13)), 1200);
      expect(o.state.coins, coinsPerWalk);
    });

    test('rewards stop at the daily cap; not walking costs nothing', () {
      final o = addSteps(pet0(at(12)), at(12), 50000);
      expect(o.state.coins, maxWalksPerDay * coinsPerWalk);
      expect(addSteps(o.state, at(12, 30), 1000).ok, isFalse);
    });

    test('a new day starts from zero', () {
      final yesterday = addSteps(pet0(at(12)), at(12), 900).state;
      final today = at(12, 0, 13);
      expect(stepsOn(yesterday, today), 0);
      final o = addSteps(yesterday, today, 200);
      expect(o.ok, isFalse);
      expect(o.state.stepsToday, 200);
    });
  });

  group('shop', () {
    final glasses = itemsById['geekGlasses']!;
    final beanie = itemsById['beanie']!;
    final headphones = itemsById['headphones']!;
    final ghost = itemsById['ghost']!; // Spooktober: in season on 12 Oct.
    final santaHat = itemsById['santaHat']!;
    final star = itemsById['stickerStar']!;
    PetState rich() => pet0(at(12), level: 0.4).copyWith(coins: 100);

    test('buying spends coins and puts the item on', () {
      final o = buy(rich(), at(12), glasses);
      expect(o.ok, isTrue);
      expect(o.state.coins, 100 - glasses.price);
      expect(o.state.owned, {'geekGlasses'});
      expect(o.state.equipped, {Slot.face: 'geekGlasses'});
      expect(types(o), [EventType.bought]);
    });

    test('cannot buy without enough coins, twice, or out of season', () {
      final poor = pet0(at(12)).copyWith(coins: 3);
      expect(canBuy(poor, glasses, at(12)), BuyResult.notEnoughCoins);
      final owned = buy(rich(), at(12), glasses).state;
      expect(canBuy(owned, glasses, at(12)), BuyResult.alreadyOwned);
      expect(canBuy(rich(), santaHat, at(12)), BuyResult.outOfSeason);
      expect(buy(rich(), at(12), santaHat).ok, isFalse);
    });

    test('seasonal items are a treat: they raise fun', () {
      final o = buy(rich(), at(12), ghost);
      expect(o.state.level(Need.fun), closeTo(0.4 + seasonalFunGain, 1e-9));
      expect(
        buy(rich(), at(12), glasses).state.level(Need.fun),
        closeTo(0.4, 1e-9),
      );
    });

    test('stickers are collected, not worn', () {
      final o = buy(rich(), at(12), star);
      expect(o.state.owned, {'stickerStar'});
      expect(o.state.equipped, isEmpty);
    });

    test('one accessory per slot; owned ones can be swapped and removed', () {
      var s = buy(rich(), at(12), beanie).state;
      s = buy(s, at(12), headphones).state;
      expect(s.equipped, {Slot.head: 'headphones'});
      s = toggleWorn(s, beanie);
      expect(s.equipped, {Slot.head: 'beanie'});
      s = toggleWorn(s, beanie);
      expect(s.equipped, isEmpty);
      expect(toggleWorn(s, glasses).equipped, isEmpty, reason: 'not owned');
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
