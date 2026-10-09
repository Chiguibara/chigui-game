import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final t0 = DateTime.utc(2026, 10, 9, 12);

  PetState withLevels(double food, double affection, double fun) => PetState(
    needs: {Need.food: food, Need.affection: affection, Need.fun: fun},
    updatedAt: t0,
  );

  group('elapse', () {
    test('needs decay gently over time', () {
      final after = elapse(
        withLevels(1, 1, 1),
        t0.add(const Duration(hours: 1)),
      );
      expect(
        after.level(Need.food),
        closeTo(1 - decayPerHour[Need.food]!, 1e-9),
      );
      expect(after.updatedAt, t0.add(const Duration(hours: 1)));
    });

    test('a long absence never drops needs below the floor', () {
      final after = elapse(
        withLevels(1, 1, 1),
        t0.add(const Duration(days: 30)),
      );
      for (final need in Need.values) {
        expect(after.level(need), needFloor);
      }
    });

    test('needs already below the floor are left alone', () {
      final after = elapse(
        withLevels(0.1, 1, 1),
        t0.add(const Duration(days: 1)),
      );
      expect(after.level(Need.food), 0.1);
    });

    test('a clock moved backwards counts as no time', () {
      final earlier = t0.subtract(const Duration(hours: 5));
      final after = elapse(withLevels(0.7, 0.7, 0.7), earlier);
      expect(after.level(Need.food), 0.7);
      expect(after.updatedAt, earlier);
    });
  });

  test('petting raises affection, capped at 1', () {
    expect(
      pet(withLevels(0.5, 0.5, 0.5), t0).level(Need.affection),
      closeTo(0.6, 1e-9),
    );
    expect(pet(withLevels(0.5, 0.98, 0.5), t0).level(Need.affection), 1);
  });

  group('feed', () {
    test('raises food', () {
      expect(
        feed(withLevels(0.4, 0.5, 0.5), t0).level(Need.food),
        closeTo(0.7, 1e-9),
      );
    });

    test('is refused when full', () {
      final full = withLevels(fullLevel, 0.5, 0.5);
      expect(isFull(full), isTrue);
      expect(feed(full, t0).level(Need.food), fullLevel);
    });
  });

  group('wish', () {
    test('is null when every need is fine', () {
      expect(wish(withLevels(0.6, 0.9, 0.5)), isNull);
    });

    test('picks the lowest need under the threshold', () {
      expect(wish(withLevels(0.4, 0.3, 0.45)), Need.affection);
    });
  });
}
