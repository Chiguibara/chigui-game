import 'package:chigui_game/game/catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTime d(int month, int day, [int year = 2026]) =>
      DateTime(year, month, day, 12);

  test('every item id is unique', () {
    expect(itemsById.length, catalog.length);
  });

  test('every season has items', () {
    for (final season in Season.values) {
      expect(catalog.where((i) => i.season == season), isNotEmpty);
    }
  });

  final cases = {
    Season.spooktober: (
      inside: [d(10, 1), d(10, 31), d(11, 1)],
      outside: [d(9, 30), d(11, 2)],
    ),
    Season.christmas: (
      inside: [d(12, 1), d(12, 31), d(1, 1), d(1, 6)],
      outside: [d(11, 30), d(1, 7)],
    ),
    Season.spring: (
      inside: [d(3, 20), d(5, 1), d(6, 20)],
      outside: [d(3, 19), d(6, 21)],
    ),
    Season.summer: (
      inside: [d(6, 21), d(8, 15), d(9, 22)],
      outside: [d(6, 20), d(9, 23)],
    ),
  };
  for (final MapEntry(key: season, value: c) in cases.entries) {
    test('${season.name} dates', () {
      for (final day in c.inside) {
        expect(inSeason(season, day), isTrue, reason: '$day');
      }
      for (final day in c.outside) {
        expect(inSeason(season, day), isFalse, reason: '$day');
      }
    });
  }

  test('finds the next season start', () {
    expect(nextSeasonStart(d(10, 12)), DateTime(2026, 12, 1));
    expect(nextSeasonStart(d(12, 20)), DateTime(2027, 3, 20));
  });
}
