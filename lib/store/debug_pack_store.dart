import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'pack_store.dart';

/// A pretend store for development builds where no real store exists (the
/// browser), so packs can be seen and tried. Nothing is charged. Purchases
/// first go "pending" (as when a parent must approve) and then complete.
class DebugPackStore implements PackStore {
  DebugPackStore(
    this._prefs, {
    this.approvalDelay = const Duration(seconds: 2),
  });

  static const ownedKey = 'debug.ownedPacks';

  /// How long the pretend parent takes to approve.
  final Duration approvalDelay;

  final SharedPreferences _prefs;
  final _updates = StreamController<PackUpdate>.broadcast();

  @override
  Stream<PackUpdate> get updates => _updates.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Map<String, String>> prices(Set<String> packIds) async => {
    for (final id in packIds) id: '${devPrices[id] ?? '0,99 €'} (dev)',
  };

  /// The intended prices; the real ones are set in the store's console.
  static const devPrices = {'pack_geek': '1,99 €', 'pack_sweet': '0,99 €'};

  @override
  Future<Set<String>> ownedPacks() async =>
      (_prefs.getStringList(ownedKey) ?? const []).toSet();

  @override
  Future<void> buy(String packId) async {
    _updates.add(PackUpdate(packId, PackStatus.pending));
    await Future<void>.delayed(approvalDelay);
    await _prefs.setStringList(ownedKey, [
      ...?_prefs.getStringList(ownedKey),
      packId,
    ]);
    _updates.add(PackUpdate(packId, PackStatus.purchased));
  }

  /// Forgets the pretend purchases (dev panel "Reset").
  Future<void> clear() => _prefs.remove(ownedKey);

  @override
  void dispose() => _updates.close();
}
