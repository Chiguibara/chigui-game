import 'package:chigui_game/app.dart';
import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/ui/whats_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Monday 16:00: after school, before the routine starts at 17:00.
  final now = DateTime(2026, 10, 12, 16);
  const notes = WhatsNew(
    en: 'Bath time!\n• Soap and a towel.\n• Faster games.\n',
    es: '¡Hora del baño!\n• Jabón y toalla.\n• Juegos más rápidos.\n',
    ca: 'Hora del bany!\n• Sabó i tovallola.\n• Jocs més ràpids.\n',
  );

  group('notes', () {
    test('parse into a title and points', () {
      final parsed = notes.forLanguage('en');
      expect(parsed.title, 'Bath time!');
      expect(parsed.points, ['Soap and a towel.', 'Faster games.']);
    });

    test('Spanish and Catalan have their own; the rest read English', () {
      expect(notes.forLanguage('es').title, '¡Hora del baño!');
      expect(notes.forLanguage('ca').title, 'Hora del bany!');
      expect(notes.forLanguage('de').title, 'Bath time!');
      expect(notes.forLanguage('fr').title, 'Bath time!');
    });

    test('the fingerprint is a stable hash of the English notes', () {
      // 32-bit FNV-1a of "a".
      expect(const WhatsNew(en: 'a\n', es: '', ca: '').fingerprint, 'e40c292c');
      final retranslated = WhatsNew(en: notes.en, es: 'Otra cosa', ca: '');
      expect(retranslated.fingerprint, notes.fingerprint);
      expect(
        WhatsNew(en: '${notes.en}• More.', es: '', ca: '').fingerprint,
        isNot(notes.fingerprint),
      );
    });

    testWidgets('the bundled notes have the same points in every language', (
      tester,
    ) async {
      final bundled = (await tester.runAsync(WhatsNew.load))!;
      final points = bundled.forLanguage('en').points.length;
      expect(points, greaterThan(0));
      for (final language in ['es', 'ca']) {
        final parsed = bundled.forLanguage(language);
        expect(parsed.title, isNotEmpty, reason: language);
        expect(parsed.points, hasLength(points), reason: language);
      }
    });
  });

  group('dialog', () {
    Future<PetController> start(
      WidgetTester tester, {
      required bool saved,
      String? seenNotes,
      Locale? locale,
    }) async {
      tester.view.physicalSize = const Size(1080, 2340);
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});
      final repo = await JsonGameRepository.open();
      if (saved) {
        await repo.saveState(
          PetState(
            needs: {for (final n in Need.values) n: 0.8},
            updatedAt: now,
            seed: 42,
            seenNotes: seenNotes,
          ),
        );
      }
      final controller = await PetController.load(repo, clock: () => now);
      await tester.pumpWidget(
        ChiguiApp(controller: controller, whatsNew: notes, locale: locale),
      );
      // The first frame, then the dialog's entrance.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      return controller;
    }

    testWidgets('shows once after an update, then remembers it', (
      tester,
    ) async {
      final controller = await start(tester, saved: true);
      expect(find.text('Bath time!'), findsOneWidget);
      expect(find.text('Soap and a towel.'), findsOneWidget);
      expect(controller.state.seenNotes, isNull);

      await tester.tap(find.text('Cool!'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Bath time!'), findsNothing);
      expect(controller.state.seenNotes, notes.fingerprint);
      final repo = await JsonGameRepository.open();
      expect((await repo.loadState())!.seenNotes, notes.fingerprint);
    });

    testWidgets('does not show again for the same notes', (tester) async {
      final controller = await start(
        tester,
        saved: true,
        seenNotes: notes.fingerprint,
      );
      expect(find.text('Bath time!'), findsNothing);
      expect(controller.state.seenNotes, notes.fingerprint);
    });

    testWidgets('shows again when the notes change', (tester) async {
      await start(tester, saved: true, seenNotes: 'older');
      expect(find.text('Bath time!'), findsOneWidget);
    });

    testWidgets('a new player does not see it, but it counts as seen', (
      tester,
    ) async {
      final controller = await start(tester, saved: false);
      expect(find.text('Bath time!'), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(controller.state.seenNotes, notes.fingerprint);
    });

    for (final (language, title, ok) in [
      ('es', '¡Hora del baño!', '¡Guay!'),
      ('ca', 'Hora del bany!', 'Genial!'),
      ('de', 'Bath time!', 'Cool!'),
    ]) {
      testWidgets('in $language shows "$title"', (tester) async {
        await start(tester, saved: true, locale: Locale(language));
        expect(find.text(title), findsOneWidget);
        expect(find.text(ok), findsOneWidget);
      });
    }
  });
}
