import 'dart:convert';

import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/save/save_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.utc(2026, 10, 9, 12);

  Future<SaveStore> storeWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SaveStore.open();
  }

  test('starts fresh when there is no save', () async {
    final state = (await storeWith({})).load(now);
    expect(state.level(Need.food), PetState.initialLevel);
    expect(state.updatedAt, now);
  });

  test('round-trips a saved state', () async {
    final store = await storeWith({});
    final saved = PetState(
      needs: {Need.food: 0.3, Need.affection: 0.6, Need.fun: 0.9},
      updatedAt: now,
    );
    await store.save(saved);

    final loaded = store.load(now.add(const Duration(days: 1)));
    expect(loaded.needs, saved.needs);
    expect(loaded.updatedAt, now);
  });

  test('fills missing or invalid fields with defaults', () async {
    final store = await storeWith({
      SaveStore.key: jsonEncode({
        'schemaVersion': 1,
        'needs': {'food': 'lots', 'affection': 7},
      }),
    });

    final state = store.load(now);
    expect(state.level(Need.food), PetState.initialLevel);
    expect(state.level(Need.affection), 1);
    expect(state.level(Need.fun), PetState.initialLevel);
    expect(state.updatedAt, now);
  });

  test('keeps an unreadable save aside and starts fresh', () async {
    final store = await storeWith({SaveStore.key: '{not json'});

    final state = store.load(now);
    expect(state.level(Need.food), PetState.initialLevel);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(SaveStore.corruptKey), '{not json');
  });
}
