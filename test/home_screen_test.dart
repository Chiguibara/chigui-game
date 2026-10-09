import 'dart:convert';

import 'package:chigui_game/app.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/save/save_store.dart';
import 'package:chigui_game/ui/chigui_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final now = DateTime.utc(2026, 10, 9, 12);

  Future<PetController> controllerWith(Map<Need, double> needs) async {
    SharedPreferences.setMockInitialValues({
      SaveStore.key: jsonEncode(
        SaveStore.encode(PetState(needs: needs, updatedAt: now)),
      ),
    });
    return PetController(await SaveStore.open(), clock: () => now);
  }

  const fine = {Need.food: 0.8, Need.affection: 0.8, Need.fun: 0.8};

  testWidgets('shows Chigüi with the English prompt', (tester) async {
    final controller = await controllerWith(fine);
    await tester.pumpWidget(ChiguiApp(controller: controller));

    expect(find.byType(ChiguiView), findsOneWidget);
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('petting makes Chigüi happy and raises affection', (
    tester,
  ) async {
    final controller = await controllerWith(fine);
    await tester.pumpWidget(ChiguiApp(controller: controller));

    await tester.tap(find.byType(ChiguiView));
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
    expect(controller.state.level(Need.affection), closeTo(0.9, 1e-9));

    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('a hungry Chigüi says so, and feeding helps', (tester) async {
    final controller = await controllerWith({...fine, Need.food: 0.3});
    await tester.pumpWidget(ChiguiApp(controller: controller));
    expect(find.text('Chigüi could go for a snack'), findsOneWidget);

    await tester.tap(find.text('Feed'));
    await tester.pump();
    expect(find.text('Yum! Thank you!'), findsOneWidget);
    expect(controller.state.level(Need.food), closeTo(0.6, 1e-9));

    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('a full Chigüi politely refuses food', (tester) async {
    final controller = await controllerWith({...fine, Need.food: 1});
    await tester.pumpWidget(ChiguiApp(controller: controller));

    await tester.tap(find.text('Feed'));
    await tester.pump();
    expect(find.text('Chigüi has had enough for now'), findsOneWidget);
    expect(controller.state.level(Need.food), 1);
    await tester.pump(const Duration(milliseconds: 1300));
  });

  testWidgets('actions are saved right away', (tester) async {
    final controller = await controllerWith({...fine, Need.food: 0.3});
    await tester.pumpWidget(ChiguiApp(controller: controller));

    await tester.tap(find.text('Feed'));
    await tester.pump(const Duration(milliseconds: 1300));

    final reloaded = (await SaveStore.open()).load(now);
    expect(reloaded.level(Need.food), closeTo(0.6, 1e-9));
  });

  testWidgets('uses Spanish when the device language is Spanish', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final controller = await controllerWith(fine);

    await tester.pumpWidget(ChiguiApp(controller: controller));

    expect(find.text('Toca a Chigüi para saludar'), findsOneWidget);
    expect(find.text('Dar de comer'), findsOneWidget);
  });

  testWidgets('works with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final controller = await controllerWith(fine);

    await tester.pumpWidget(ChiguiApp(controller: controller));

    await tester.tap(find.byType(ChiguiView));
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1300));
  });
}
