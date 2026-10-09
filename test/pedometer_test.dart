import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/walk/pedometer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 10, 12, 12);

  Future<(Pedometer, PetController, List<int>)> setUpWith(
    Map<String, Object> saved,
  ) async {
    SharedPreferences.setMockInitialValues(saved);
    final prefs = await SharedPreferences.getInstance();
    final pet = await PetController.load(
      await JsonGameRepository.open(),
      clock: () => now,
    );
    final pedometer = Pedometer(pet, prefs);
    final live = <int>[];
    pedometer.liveSteps.listen(live.add);
    return (pedometer, pet, live);
  }

  test(
    'the very first reading on a phone only sets the starting point',
    () async {
      final (pedometer, pet, live) = await setUpWith({});
      pedometer.onTotal(12345);
      await Future<void>.delayed(Duration.zero);
      expect(pet.stepsToday, 0);
      expect(live, isEmpty);
    },
  );

  test('steps taken while the app was closed are added, not "live"', () async {
    final (pedometer, pet, live) = await setUpWith({
      Pedometer.lastTotalKey: 1000,
    });
    pedometer.onTotal(2500);
    await Future<void>.delayed(Duration.zero);
    expect(pet.stepsToday, 1500);
    expect(live, isEmpty, reason: 'catching up must not open the walk');
  });

  test('steps while the app is open are added and reported live', () async {
    final (pedometer, pet, live) = await setUpWith({
      Pedometer.lastTotalKey: 1000,
    });
    pedometer.onTotal(1000);
    pedometer.onTotal(1012);
    pedometer.onTotal(1030);
    await Future<void>.delayed(Duration.zero);
    expect(pet.stepsToday, 30);
    expect(live, [12, 18]);
  });

  test('a phone restart (counter back to zero) still counts', () async {
    final (pedometer, pet, _) = await setUpWith({
      Pedometer.lastTotalKey: 90000,
    });
    pedometer.onTotal(40);
    await Future<void>.delayed(Duration.zero);
    expect(pet.stepsToday, 40);
  });
}
