import 'dart:async';

import 'package:chigui_game/store/pack_store.dart';

/// A store the tests control: they decide what it owns and when purchases
/// finish.
class FakePackStore implements PackStore {
  FakePackStore({this.available = true, Set<String>? owned})
    : owned = owned ?? {};

  bool available;
  Set<String> owned;
  final bought = <String>[];
  final _updates = StreamController<PackUpdate>.broadcast();

  @override
  Stream<PackUpdate> get updates => _updates.stream;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<Map<String, String>> prices(Set<String> packIds) async => {
    for (final id in packIds) id: '0,99 €',
  };

  @override
  Future<Set<String>> ownedPacks() async => owned;

  @override
  Future<void> buy(String packId) async => bought.add(packId);

  /// What the real store would report later.
  void report(String packId, PackStatus status) {
    if (status == PackStatus.purchased) owned.add(packId);
    _updates.add(PackUpdate(packId, status));
  }

  @override
  void dispose() => _updates.close();
}
