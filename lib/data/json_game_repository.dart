import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/catalog.dart';
import '../game/game_event.dart';
import '../game/pet_state.dart';
import 'game_repository.dart';

/// Stores the pet and the history log as two versioned JSON documents in
/// `shared_preferences` (localStorage on web, a file on Windows,
/// SharedPreferences on Android).
///
/// Missing or invalid fields fall back to defaults. A document that cannot be
/// read at all is kept under a `.corrupt` key before starting over.
class JsonGameRepository implements GameRepository {
  JsonGameRepository(this._prefs, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static Future<JsonGameRepository> open() async =>
      JsonGameRepository(await SharedPreferences.getInstance());

  static const stateKey = 'save';
  static const eventsKey = 'events';
  static const corruptSuffix = '.corrupt';
  static const schemaVersion = 2;

  final SharedPreferences _prefs;
  final DateTime Function() _clock;

  @override
  Future<PetState?> loadState() async {
    final json = _readJson(stateKey);
    return json is Map<String, dynamic> ? decodeState(json) : null;
  }

  @override
  Future<void> saveState(PetState state) =>
      _write(stateKey, encodeState(state));

  @override
  Future<void> addEvents(List<GameEvent> events) async {
    if (events.isEmpty) return;
    final cutoff = _clock().subtract(eventRetention);
    final all = [
      ..._readEvents().where((e) => !e.at.isBefore(cutoff)),
      ...events,
    ];
    await _write(eventsKey, {
      'schemaVersion': schemaVersion,
      'events': [for (final e in all) _encodeEvent(e)],
    });
  }

  @override
  Future<List<GameEvent>> eventsSince(DateTime since) async =>
      _readEvents().where((e) => !e.at.isBefore(since)).toList();

  List<GameEvent> _readEvents() {
    final json = _readJson(eventsKey);
    final list = json is Map && json['events'] is List
        ? json['events'] as List
        : const [];
    return [for (final item in list) ?_decodeEvent(item)];
  }

  Object? _readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } catch (error) {
      debugPrint('Unreadable "$key", starting over: $error');
      _prefs.setString('$key$corruptSuffix', raw);
      _prefs.remove(key);
      return null;
    }
  }

  Future<void> _write(String key, Object json) async {
    try {
      await _prefs.setString(key, jsonEncode(json));
    } catch (error) {
      // Keep playing; the next save will try again.
      debugPrint('Could not save "$key": $error');
    }
  }

  @visibleForTesting
  static Map<String, dynamic> encodeState(PetState s) => {
    'schemaVersion': schemaVersion,
    'updatedAt': _encodeTime(s.updatedAt),
    'seed': s.seed,
    'needs': {for (final e in s.needs.entries) e.key.name: e.value},
    'pottyUrgeSince': _encodeTime(s.pottyUrgeSince),
    'messes': s.messes,
    'recentAccidents': [for (final t in s.recentAccidents) _encodeTime(t)],
    'lastMealServed': _encodeTime(s.lastMealServed),
    'missedMealsInARow': s.missedMealsInARow,
    'sick': s.sick,
    'asleepUntil': _encodeTime(s.asleepUntil),
    'grumpy': s.grumpy,
    'coins': s.coins,
    'stepsToday': s.stepsToday,
    'tapStepsToday': s.tapStepsToday,
    'minigameCoinsToday': s.minigameCoinsToday,
    'minigameDay': _encodeTime(s.minigameDay),
    'stepsDay': _encodeTime(s.stepsDay),
    'owned': s.owned.toList(),
    'equipped': {for (final e in s.equipped.entries) e.key.name: e.value},
    'ownedPacks': s.ownedPacks.toList(),
  };

  /// Reads any schema version so far; version 1 only had needs and
  /// `updatedAt`, and the rest default.
  @visibleForTesting
  PetState decodeState(Map<String, dynamic> json) {
    final needs = json['needs'] is Map ? json['needs'] as Map : const {};
    // Items no longer in the catalog are dropped.
    final owned = {
      if (json['owned'] case final List list)
        for (final id in list)
          if (id is String && itemsById.containsKey(id)) id,
    };
    final equipped = json['equipped'] is Map
        ? json['equipped'] as Map
        : const {};
    final accidents = json['recentAccidents'] is List
        ? json['recentAccidents'] as List
        : const [];
    return PetState(
      needs: {
        for (final need in Need.values)
          need: _level(needs[need.name]) ?? PetState.initialLevel,
      },
      updatedAt: _decodeTime(json['updatedAt']) ?? _clock(),
      seed: json['seed'] is int ? json['seed'] as int : 0,
      pottyUrgeSince: _decodeTime(json['pottyUrgeSince']),
      messes: _count(json['messes']),
      recentAccidents: [for (final t in accidents) ?_decodeTime(t)],
      lastMealServed: _decodeTime(json['lastMealServed']),
      missedMealsInARow: _count(json['missedMealsInARow']),
      sick: json['sick'] == true,
      asleepUntil: _decodeTime(json['asleepUntil']),
      grumpy: json['grumpy'] == true,
      coins: _count(json['coins']),
      stepsToday: _count(json['stepsToday']),
      tapStepsToday: _count(json['tapStepsToday']),
      minigameCoinsToday: _count(json['minigameCoinsToday']),
      minigameDay: _decodeTime(json['minigameDay']),
      stepsDay: _decodeTime(json['stepsDay']),
      owned: owned,
      ownedPacks: {
        if (json['ownedPacks'] case final List list)
          for (final id in list)
            if (id is String && packsById.containsKey(id)) id,
      },
      equipped: {
        for (final MapEntry(:key, :value) in equipped.entries)
          if (Slot.values.asNameMap()[key] case final slot?)
            if (value is String && owned.contains(value)) slot: value,
      },
    );
  }

  static Map<String, dynamic> _encodeEvent(GameEvent e) => {
    'type': e.type.name,
    'at': _encodeTime(e.at),
  };

  static GameEvent? _decodeEvent(Object? json) {
    if (json is! Map) return null;
    final type = EventType.values.asNameMap()[json['type']];
    final at = _decodeTime(json['at']);
    return type == null || at == null ? null : GameEvent(type, at);
  }

  static String? _encodeTime(DateTime? t) => t?.toUtc().toIso8601String();

  static DateTime? _decodeTime(Object? json) =>
      json is String ? DateTime.tryParse(json) : null;

  static double? _level(Object? value) {
    if (value is! num || value.isNaN) return null;
    return value.toDouble().clamp(0.0, 1.0);
  }

  static int _count(Object? value) => value is int && value > 0 ? value : 0;
}
