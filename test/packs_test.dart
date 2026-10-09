import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/catalog.dart';
import 'package:chigui_game/game/game_event.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/rules.dart';
import 'package:chigui_game/store/debug_pack_store.dart';
import 'package:chigui_game/store/pack_store.dart';
import 'package:chigui_game/store/packs_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_pack_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 10, 12, 12);
  final geek = packsById['pack_geek']!;
  final sweet = packsById['pack_sweet']!;
  PetState fresh() => PetState.fresh(now, seed: 1);

  group('catalog', () {
    test('every pack item exists, is cosmetic, and points to its pack', () {
      for (final pack in packs) {
        for (final id in pack.items) {
          final item = itemsById[id]!;
          expect(item.pack, pack.id);
          expect(item.slot, isNot(Slot.sticker));
        }
      }
    });

    test('pack items cannot be bought with coins', () {
      final rich = fresh().copyWith(coins: 999);
      expect(canBuy(rich, itemsById['wizardHat']!, now), BuyResult.onlyInPack);
    });
  });

  group('rules', () {
    test('granting a pack gives its items once', () {
      final o = grantPack(fresh(), now, geek);
      expect(o.state.ownedPacks, {'pack_geek'});
      expect(o.state.owned, containsAll(geek.items));
      expect([for (final e in o.events) e.type], [EventType.packBought]);
      expect(grantPack(o.state, now, geek).ok, isFalse);
    });

    test('sync restores packs bought on another device', () {
      final o = syncPacks(fresh(), now, {'pack_sweet'});
      expect(o.state.ownedPacks, {'pack_sweet'});
      expect(o.state.owned, containsAll(sweet.items));
    });

    test('sync removes refunded packs and takes their items off', () {
      var s = grantPack(fresh(), now, geek).state;
      s = toggleWorn(s, itemsById['wizardHat']!);
      expect(s.equipped[Slot.head], 'wizardHat');

      final o = syncPacks(s, now, {});
      expect(o.state.ownedPacks, isEmpty);
      expect(o.state.owned.intersection(geek.items.toSet()), isEmpty);
      expect(o.state.equipped, isEmpty);
      expect([for (final e in o.events) e.type], [EventType.packRemoved]);
    });
  });

  test('owned packs are saved', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = await JsonGameRepository.open();
    await repo.saveState(grantPack(fresh(), now, geek).state);
    final loaded = (await repo.loadState())!;
    expect(loaded.ownedPacks, {'pack_geek'});
    expect(loaded.owned, containsAll(geek.items));
  });

  group('PacksController', () {
    Future<(PacksController, PetController)> setUpWith(
      FakePackStore store,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final pet = await PetController.load(
        await JsonGameRepository.open(),
        clock: () => now,
      );
      final packs = PacksController(store, pet);
      await packs.start();
      return (packs, pet);
    }

    test('nothing is sold where there is no store', () async {
      SharedPreferences.setMockInitialValues({});
      final pet = await PetController.load(
        await JsonGameRepository.open(),
        clock: () => now,
      );
      final packs = PacksController(null, pet);
      await packs.start();
      expect(packs.available, isFalse);
    });

    test('nothing is sold when the store is unavailable', () async {
      final (packs, _) = await setUpWith(FakePackStore(available: false));
      expect(packs.available, isFalse);
    });

    test('a new phone gets back what was bought', () async {
      final (packs, pet) = await setUpWith(FakePackStore(owned: {'pack_geek'}));
      expect(packs.available, isTrue);
      expect(packs.prices['pack_geek'], '0,99 €');
      expect(pet.state.owned, containsAll(geek.items));
    });

    test('a purchase waits for a parent, then unlocks the pack', () async {
      final store = FakePackStore();
      final (packs, pet) = await setUpWith(store);

      await packs.buy(sweet);
      expect(store.bought, ['pack_sweet']);

      store.report('pack_sweet', PackStatus.pending);
      await Future<void>.delayed(Duration.zero);
      expect(packs.waiting, {'pack_sweet'});
      expect(pet.state.ownedPacks, isEmpty);

      store.report('pack_sweet', PackStatus.purchased);
      await Future<void>.delayed(Duration.zero);
      expect(packs.waiting, isEmpty);
      expect(packs.owns(sweet), isTrue);
      expect(pet.state.owned, containsAll(sweet.items));
    });

    test('a failed purchase gives nothing', () async {
      final store = FakePackStore();
      final (packs, pet) = await setUpWith(store);
      store.report('pack_geek', PackStatus.error);
      await Future<void>.delayed(Duration.zero);
      expect(packs.lastUpdate?.status, PackStatus.error);
      expect(pet.state.ownedPacks, isEmpty);
    });
  });

  test('the development store pretends a parent approves', () async {
    SharedPreferences.setMockInitialValues({});
    final store = DebugPackStore(
      await SharedPreferences.getInstance(),
      approvalDelay: Duration.zero,
    );
    final statuses = <PackStatus>[];
    store.updates.listen((u) => statuses.add(u.status));

    await store.buy('pack_geek');
    await Future<void>.delayed(Duration.zero);
    expect(statuses, [PackStatus.pending, PackStatus.purchased]);
    expect(await store.ownedPacks(), {'pack_geek'});
    expect((await store.prices({'pack_geek'}))['pack_geek'], contains('dev'));
  });
}
