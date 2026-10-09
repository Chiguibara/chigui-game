import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/pet_state.dart';

/// Stores the game as one versioned JSON document. Loading never fails:
/// missing or invalid fields fall back to defaults, and an unreadable save is
/// kept under [corruptKey] before starting fresh.
class SaveStore {
  SaveStore(this._prefs);

  static Future<SaveStore> open() async =>
      SaveStore(await SharedPreferences.getInstance());

  static const key = 'save';
  static const corruptKey = 'save.corrupt';
  static const schemaVersion = 1;

  final SharedPreferences _prefs;

  PetState load(DateTime now) {
    final raw = _prefs.getString(key);
    if (raw == null) return PetState.fresh(now);
    try {
      return decode(jsonDecode(raw) as Map<String, dynamic>, now);
    } catch (error) {
      debugPrint('Unreadable save, starting fresh: $error');
      _prefs.setString(corruptKey, raw);
      return PetState.fresh(now);
    }
  }

  Future<void> save(PetState state) async {
    try {
      await _prefs.setString(key, jsonEncode(encode(state)));
    } catch (error) {
      // Keep playing; the next action will try again.
      debugPrint('Could not save: $error');
    }
  }

  @visibleForTesting
  static Map<String, dynamic> encode(PetState state) => {
    'schemaVersion': schemaVersion,
    'updatedAt': state.updatedAt.toUtc().toIso8601String(),
    'needs': {for (final e in state.needs.entries) e.key.name: e.value},
  };

  @visibleForTesting
  static PetState decode(Map<String, dynamic> json, DateTime now) {
    final updatedAt =
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? now;
    final needs = json['needs'] is Map ? json['needs'] as Map : const {};
    return PetState(
      needs: {
        for (final need in Need.values)
          need: _level(needs[need.name]) ?? PetState.initialLevel,
      },
      updatedAt: updatedAt,
    );
  }

  static double? _level(Object? value) {
    if (value is! num || value.isNaN) return null;
    return value.toDouble().clamp(0.0, 1.0);
  }
}
