import 'package:chigui_game/game/routine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const seed = 42;
  final monday = DateTime(2026, 10, 12);
  final friday = DateTime(2026, 10, 16);
  final saturday = DateTime(2026, 10, 17);
  final sunday = DateTime(2026, 10, 18);

  test('weekdays have an afternoon snack and dinner after school', () {
    final s = scheduleFor(monday, seed);
    expect(
      [for (final m in s.meals) m.start],
      [DateTime(2026, 10, 12, 17), DateTime(2026, 10, 12, 19, 30)],
    );
    expect(s.meals.first.end, DateTime(2026, 10, 12, 18, 30));
  });

  test('weekends add lunch', () {
    expect(scheduleFor(saturday, seed).meals, hasLength(3));
  });

  test('bedtime is earlier before a school day', () {
    expect(scheduleFor(monday, seed).bedtime.start, DateTime(2026, 10, 12, 21));
    expect(scheduleFor(monday, seed).wakeUp, DateTime(2026, 10, 13, 8));
    expect(
      scheduleFor(friday, seed).bedtime.start,
      DateTime(2026, 10, 16, 21, 30),
    );
    expect(scheduleFor(friday, seed).wakeUp, DateTime(2026, 10, 17, 9));
    expect(scheduleFor(sunday, seed).bedtime.start, DateTime(2026, 10, 18, 21));
  });

  test('potty urges fall outside school hours and before bedtime', () {
    for (var d = 0; d < 14; d++) {
      final day = DateTime(2026, 10, 12 + d);
      final s = scheduleFor(day, seed);
      final weekend = day.weekday >= DateTime.saturday;
      final (from, _) = weekend ? weekendPottyHours : weekdayPottyHours;
      expect(s.pottyUrges, hasLength(pottyUrgesPerDay));
      for (final urge in s.pottyUrges) {
        expect(urge.hour, greaterThanOrEqualTo(from));
        expect(
          urge.add(pottyWait).isAfter(s.bedtime.start),
          isFalse,
          reason: '$urge',
        );
      }
    }
  });

  test('the routine is reproducible for a seed and varies between seeds', () {
    expect(
      scheduleFor(monday, seed).pottyUrges,
      scheduleFor(monday, seed).pottyUrges,
    );
    final variety = {
      for (var s = 0; s < 20; s++) scheduleFor(monday, s).pottyUrges.first,
    };
    expect(variety.length, greaterThan(1));
  });

  test('finds the next routine moment', () {
    expect(
      nextRoutineMoment(DateTime(2026, 10, 12, 21, 40), seed),
      DateTime(2026, 10, 13, 8),
    );
  });
}
