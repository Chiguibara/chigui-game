import 'package:chigui_game/data/json_game_repository.dart';
import 'package:chigui_game/game/pet_controller.dart';
import 'package:chigui_game/game/pet_state.dart';
import 'package:chigui_game/game/routine.dart';
import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:chigui_game/notify/reminders.dart';
import 'package:chigui_game/ui/reminders_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeBoard implements NoticeBoard {
  FakeBoard({this.allowed = true});

  final bool allowed;
  var notices = <ScheduledNotice>[];
  var asked = 0;

  @override
  Future<bool> requestPermission() async {
    asked++;
    return allowed;
  }

  @override
  Future<void> replace(
    List<ScheduledNotice> notices, {
    required String channel,
  }) async => this.notices = notices;
}

void main() {
  // Monday afternoon, in term time.
  final monday = DateTime(2026, 10, 12, 16);

  test('meals and potty for the rest of the day, never in class or at '
      'night', () {
    final state = PetState.fresh(monday, seed: 1);
    final reminders = upcomingReminders(state, monday);
    final day = scheduleFor(monday, 1);
    expect(reminders.map((r) => r.at), [
      ...[
        for (final meal in day.meals) meal.start,
        ...day.pottyUrges,
      ]..sort(),
    ]);
    expect(reminders.where((r) => r.kind == ReminderKind.meal), hasLength(2));
    expect(reminders.where((r) => r.kind == ReminderKind.potty), hasLength(2));
    for (final r in reminders) {
      expect(inSchool(r.at), isFalse);
      expect(isNight(r.at, 1), isFalse);
    }
  });

  test('they stop a day after the game was last open', () {
    final state = PetState.fresh(monday, seed: 1);
    final reminders = upcomingReminders(state, monday);
    expect(
      reminders.every(
        (r) => r.at.isBefore(monday.add(const Duration(days: 1))),
      ),
      isTrue,
    );
    final later = monday.add(const Duration(days: 2));
    expect(upcomingReminders(state, later), isEmpty);
  });

  Future<(Reminders, FakeBoard)> setUp({bool allowed = true}) async {
    SharedPreferences.setMockInitialValues({});
    final pet = await PetController.load(
      await JsonGameRepository.open(),
      clock: () => monday,
    );
    final board = FakeBoard(allowed: allowed);
    return (
      Reminders(
        board,
        await SharedPreferences.getInstance(),
        pet,
        locale: const Locale('es'),
      ),
      board,
    );
  }

  test(
    'off by default; on, they are scheduled when the game is left',
    () async {
      final (reminders, board) = await setUp();
      expect(reminders.enabled, isFalse);
      await reminders.scheduleAhead();
      expect(board.notices, isEmpty);

      expect(await reminders.turnOn(), isTrue);
      await reminders.scheduleAhead();
      expect(board.notices, hasLength(4));
      expect(
        board.notices.first.body,
        '¡Es la hora de comer! A Chigüi le apetece algo rico.',
      );
      await reminders.clear();
      expect(board.notices, isEmpty, reason: 'none while the game is open');

      await reminders.scheduleAhead();
      await reminders.turnOff();
      expect(board.notices, isEmpty);
      expect(reminders.enabled, isFalse);
    },
  );

  test('if the phone does not allow notifications, they stay off', () async {
    final (reminders, board) = await setUp(allowed: false);
    expect(await reminders.turnOn(), isFalse);
    expect(reminders.enabled, isFalse);
    expect(board.asked, 1);
  });

  testWidgets('a grown-up turns them on with a long press', (tester) async {
    final (reminders, board) = await tester.runAsync(setUp) ?? (throw 'setUp');
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showRemindersDialog(context, reminders),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Reminders (for grown-ups)'), findsOneWidget);

    await tester.tap(find.text('Hold to turn on'));
    await tester.pump();
    expect(reminders.enabled, isFalse, reason: 'a tap is not enough');

    await tester.longPress(find.text('Hold to turn on'));
    await tester.pumpAndSettle();
    expect(reminders.enabled, isTrue);
    expect(find.text('Turn off'), findsOneWidget);

    await tester.tap(find.text('Turn off'));
    await tester.pump();
    expect(reminders.enabled, isFalse);
    expect(board.asked, 1);
  });
}
