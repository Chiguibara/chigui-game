import 'package:chigui_game/app.dart';
import 'package:chigui_game/ui/chigui_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Chigüi with the English prompt', (tester) async {
    await tester.pumpWidget(const ChiguiApp());

    expect(find.byType(ChiguiView), findsOneWidget);
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
  });

  testWidgets('petting makes Chigüi happy, then calm again', (tester) async {
    await tester.pumpWidget(const ChiguiApp());

    await tester.tap(find.byType(ChiguiView));
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('Tap Chigüi to say hi'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });

  testWidgets('uses Spanish when the device language is Spanish', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const ChiguiApp());

    expect(find.text('Toca a Chigüi para saludar'), findsOneWidget);
  });

  testWidgets('works with reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(const ChiguiApp());

    await tester.tap(find.byType(ChiguiView));
    await tester.pump();
    expect(find.text('Chigüi is happy!'), findsOneWidget);
  });
}
