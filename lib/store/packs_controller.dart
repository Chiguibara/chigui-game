import 'dart:async';

import 'package:flutter/foundation.dart';

import '../game/catalog.dart';
import '../game/pet_controller.dart';
import 'pack_store.dart';

/// Connects the platform store to the game: prices for the shop, purchases
/// in progress, and owned packs kept in sync with the store (which restores
/// them on a new device and removes refunded ones).
class PacksController extends ChangeNotifier {
  PacksController(this._store, this._pet);

  final PackStore? _store;
  final PetController _pet;
  StreamSubscription<PackUpdate>? _subscription;

  /// Whether packs are sold here (never on the web release or Windows).
  bool available = false;

  /// Localized prices from the store, by pack id.
  Map<String, String> prices = const {};

  /// Packs waiting for a parent's approval.
  final waiting = <String>{};

  /// The latest purchase result, for the shop to react to.
  PackUpdate? lastUpdate;

  Future<void> start() async {
    final store = _store;
    if (store == null || !await store.isAvailable()) return;
    // Listen first: approvals that arrived while the game was closed are
    // delivered as soon as the store connects.
    _subscription = store.updates.listen(_onUpdate);
    try {
      prices = await store.prices({for (final p in packs) p.id});
      _pet.syncPacks(await store.ownedPacks());
    } catch (error) {
      // Offline or store trouble: keep the saved copy of owned packs.
      debugPrint('Could not reach the store: $error');
    }
    available = prices.isNotEmpty;
    notifyListeners();
  }

  bool owns(Pack pack) => _pet.state.ownedPacks.contains(pack.id);

  Future<void> buy(Pack pack) async => _store?.buy(pack.id);

  void _onUpdate(PackUpdate update) {
    final pack = packsById[update.packId];
    if (pack == null) return;
    switch (update.status) {
      case PackStatus.pending:
        waiting.add(pack.id);
      case PackStatus.purchased:
        waiting.remove(pack.id);
        _pet.grantPack(pack);
      case PackStatus.canceled || PackStatus.error:
        waiting.remove(pack.id);
    }
    lastUpdate = update;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _store?.dispose();
    super.dispose();
  }
}
