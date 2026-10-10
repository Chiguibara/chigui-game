import 'dart:math';

// Provisional tuning; adjust after playtests. Everything happens outside
// school hours, in local time.

/// Mealtimes as (hour, minute) starts; each window lasts [mealWindow].
const weekdayMeals = [(17, 0), (19, 30)];
const weekendMeals = [(13, 30), (17, 30), (20, 0)];
const mealWindow = Duration(minutes: 90);

/// Potty urges start at random times within these hours.
const weekdayPottyHours = (17, 20);
const weekendPottyHours = (10, 20);
const pottyUrgesPerDay = 2;

/// How long Chigüi can wait for the toilet before an accident.
const pottyWait = Duration(minutes: 60);

/// Chigüi gets sleepy at bedtime and goes to bed alone after [bedtimeWait].
const schoolNightBedtime = (21, 0);
const lateBedtime = (21, 30);
const bedtimeWait = Duration(minutes: 30);
const schoolDayWakeUp = (8, 0);
const freeDayWakeUp = (9, 0);

/// Class time, when playing the minigame waits until after school: weekdays
/// in these hours (end excluded), outside the school holidays. The core
/// hours shared by continuous and split school days in Spain.
const schoolHours = ((9, 0), (14, 0));

/// School holidays as inclusive (month, day) ranges; a range may wrap past
/// New Year. Easter and local holidays vary and are not included.
const schoolHolidays = [
  ((6, 23), (9, 7)), // Summer.
  ((12, 23), (1, 7)), // Christmas, until the day after Three Kings.
];

class TimeWindow {
  const TimeWindow(this.start, this.end);

  final DateTime start;
  final DateTime end;

  bool contains(DateTime time) => !time.isBefore(start) && time.isBefore(end);
}

class DaySchedule {
  const DaySchedule({
    required this.meals,
    required this.pottyUrges,
    required this.bedtime,
    required this.wakeUp,
  });

  final List<TimeWindow> meals;
  final List<DateTime> pottyUrges;

  /// From sleepy to going to bed alone.
  final TimeWindow bedtime;

  /// The next morning.
  final DateTime wakeUp;
}

bool _isWeekend(DateTime day) =>
    day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

/// The routine for the local calendar day containing [day]. Pure and
/// deterministic, so time spent away can be replayed exactly.
DaySchedule scheduleFor(DateTime day, int seed) {
  final date = DateTime(day.year, day.month, day.day);
  DateTime at((int, int) time) =>
      DateTime(date.year, date.month, date.day, time.$1, time.$2);

  final weekend = _isWeekend(date);
  final tomorrow = DateTime(date.year, date.month, date.day + 1);
  final schoolTomorrow = !_isWeekend(tomorrow);

  final bedStart = at(schoolTomorrow ? schoolNightBedtime : lateBedtime);
  final wake = schoolTomorrow ? schoolDayWakeUp : freeDayWakeUp;

  return DaySchedule(
    meals: [
      for (final start in weekend ? weekendMeals : weekdayMeals)
        TimeWindow(at(start), at(start).add(mealWindow)),
    ],
    pottyUrges: _pottyUrges(
      date,
      seed,
      weekend ? weekendPottyHours : weekdayPottyHours,
    ),
    bedtime: TimeWindow(bedStart, bedStart.add(bedtimeWait)),
    wakeUp: DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      wake.$1,
      wake.$2,
    ),
  );
}

/// One random time in each equal slice of the potty hours, so urges are
/// spread out and each one can run its full [pottyWait] before bedtime.
List<DateTime> _pottyUrges(DateTime date, int seed, (int, int) hours) {
  final random = Random(
    seed ^ (date.year * 10000 + date.month * 100 + date.day),
  );
  final start = DateTime(date.year, date.month, date.day, hours.$1);
  final slice = (hours.$2 - hours.$1) * 60 ~/ pottyUrgesPerDay;
  return [
    for (var i = 0; i < pottyUrgesPerDay; i++)
      start.add(Duration(minutes: i * slice + random.nextInt(slice))),
  ];
}

/// The next moment after [now] when the routine changes something.
/// Whether children are probably in class at [now] (local time).
bool inSchool(DateTime now) {
  final t = now.toLocal();
  if (_isWeekend(t)) return false;
  int key((int, int) monthDay) => monthDay.$1 * 100 + monthDay.$2;
  final today = t.month * 100 + t.day;
  for (final (from, to) in schoolHolidays) {
    final wraps = key(from) > key(to);
    final inside = wraps
        ? today >= key(from) || today <= key(to)
        : today >= key(from) && today <= key(to);
    if (inside) return false;
  }
  final minutes = t.hour * 60 + t.minute;
  final ((startH, startM), (endH, endM)) = schoolHours;
  return minutes >= startH * 60 + startM && minutes < endH * 60 + endM;
}

DateTime nextRoutineMoment(DateTime now, int seed) {
  final local = now.toLocal();
  final moments = [
    for (var d = -1; d <= 1; d++)
      ...() {
        final s = scheduleFor(
          DateTime(local.year, local.month, local.day + d),
          seed,
        );
        return [
          ...s.pottyUrges,
          for (final urge in s.pottyUrges) urge.add(pottyWait),
          for (final meal in s.meals) ...[meal.start, meal.end],
          s.bedtime.start,
          s.bedtime.end,
          s.wakeUp,
        ];
      }(),
  ];
  return moments
      .where((m) => m.isAfter(now))
      .reduce((a, b) => a.isBefore(b) ? a : b);
}
