import 'dart:convert';

import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/game_event.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.utc(2026, 10, 12, 12);

  Future<JsonGameRepository> repoWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return JsonGameRepository(
      await SharedPreferences.getInstance(),
      clock: () => now,
    );
  }

  test('has no state on first launch', () async {
    expect(await (await repoWith({})).loadState(), isNull);
  });

  test('round-trips the full state', () async {
    final repo = await repoWith({});
    final saved = PetState(
      needs: {Need.food: 0.3, Need.affection: 0.6, Need.fun: 0.9},
      updatedAt: now,
      seed: 7,
      pottyUrgeSince: now.subtract(const Duration(minutes: 5)),
      messes: 2,
      recentAccidents: [now.subtract(const Duration(hours: 1))],
      lastMealServed: now.subtract(const Duration(hours: 2)),
      missedMealsInARow: 1,
      sick: true,
      asleepUntil: now.add(const Duration(hours: 8)),
      grumpy: true,
      coins: 12,
      stepsToday: 3400,
      stepsDay: now,
    );
    await repo.saveState(saved);

    final loaded = (await repo.loadState())!;
    expect(
      JsonGameRepository.encodeState(loaded),
      JsonGameRepository.encodeState(saved),
    );
  });

  test('reads a version 1 save, defaulting the new fields', () async {
    final repo = await repoWith({
      JsonGameRepository.stateKey: jsonEncode({
        'schemaVersion': 1,
        'updatedAt': now.toIso8601String(),
        'needs': {'food': 0.4, 'affection': 0.5, 'fun': 0.6},
      }),
    });

    final state = (await repo.loadState())!;
    expect(state.level(Need.food), 0.4);
    expect(state.messes, 0);
    expect(state.sick, isFalse);
    expect(state.asleepUntil, isNull);
  });

  test('fills missing or invalid fields with defaults', () async {
    final repo = await repoWith({
      JsonGameRepository.stateKey: jsonEncode({
        'needs': {'food': 'lots', 'affection': 7},
        'messes': -3,
        'recentAccidents': ['nope', now.toIso8601String()],
      }),
    });

    final state = (await repo.loadState())!;
    expect(state.level(Need.food), PetState.initialLevel);
    expect(state.level(Need.affection), 1);
    expect(state.messes, 0);
    expect(state.recentAccidents, hasLength(1));
    expect(state.updatedAt, now);
  });

  test('keeps an unreadable save aside and reports no state', () async {
    final repo = await repoWith({JsonGameRepository.stateKey: '{not json'});

    expect(await repo.loadState(), isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString(
        '${JsonGameRepository.stateKey}${JsonGameRepository.corruptSuffix}',
      ),
      '{not json',
    );
  });

  group('event log', () {
    test('appends and filters by time', () async {
      final repo = await repoWith({});
      final early = GameEvent(
        EventType.snack,
        now.subtract(const Duration(hours: 2)),
      );
      final late = GameEvent(EventType.accident, now);
      await repo.addEvents([early]);
      await repo.addEvents([late]);

      expect(await repo.eventsSince(now.subtract(const Duration(days: 1))), [
        early,
        late,
      ]);
      expect(await repo.eventsSince(now.subtract(const Duration(hours: 1))), [
        late,
      ]);
    });

    test('drops entries older than 90 days', () async {
      final repo = await repoWith({});
      final old = GameEvent(
        EventType.snack,
        now.subtract(const Duration(days: 91)),
      );
      await repo.addEvents([old]);
      await repo.addEvents([GameEvent(EventType.vetVisit, now)]);

      final all = await repo.eventsSince(DateTime.utc(2000));
      expect(all, [GameEvent(EventType.vetVisit, now)]);
    });

    test('skips unreadable entries and recovers from a corrupt log', () async {
      final repo = await repoWith({
        JsonGameRepository.eventsKey: jsonEncode({
          'events': [
            {'type': 'unknown', 'at': now.toIso8601String()},
            {'type': 'snack', 'at': now.toIso8601String()},
          ],
        }),
      });
      expect(await repo.eventsSince(DateTime.utc(2000)), [
        GameEvent(EventType.snack, now),
      ]);

      final corrupt = await repoWith({JsonGameRepository.eventsKey: '['});
      expect(await corrupt.eventsSince(DateTime.utc(2000)), isEmpty);
      await corrupt.addEvents([GameEvent(EventType.snack, now)]);
      expect(await corrupt.eventsSince(DateTime.utc(2000)), hasLength(1));
    });
  });
}
