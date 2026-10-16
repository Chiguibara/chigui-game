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
  FakeBoard({this.permitted = false, this.grant = true});

  /// Whether notifications are allowed now, and what the player answers
  /// when asked.
  bool permitted;
  bool grant;
  var notices = <ScheduledNotice>[];
  var asked = 0;
  var settingsOpened = 0;

  @override
  Future<bool> requestPermission() async {
    asked++;
    return permitted = permitted || grant;
  }

  @override
  Future<bool> allowed() async => permitted;

  @override
  Future<void> openSettings() async => settingsOpened++;

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

  Future<(Reminders, FakeBoard)> setUp({
    bool permitted = false,
    bool grant = true,
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final pet = await PetController.load(
      await JsonGameRepository.open(),
      clock: () => monday,
    );
    final board = FakeBoard(permitted: permitted, grant: grant);
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

  test('on from the start: the first launch asks, and leaving the game '
      'schedules them', () async {
    final (reminders, board) = await setUp();
    expect(reminders.enabled, isTrue);
    await reminders.refresh();
    expect(board.asked, 1);
    expect(reminders.enabled, isTrue);
    await reminders.refresh();
    expect(board.asked, 1, reason: 'asked only once');

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
  });

  test('saying no turns them off; turning them on asks again', () async {
    final (reminders, board) = await setUp(grant: false);
    await reminders.refresh();
    expect(reminders.enabled, isFalse);
    await reminders.refresh();
    expect(board.asked, 1, reason: 'no nagging on every launch');
    await reminders.scheduleAhead();
    expect(board.notices, isEmpty);

    board.grant = true;
    expect(await reminders.turnOn(), isTrue);
    expect(board.asked, 2);
    expect(reminders.enabled, isTrue);
  });

  test('blocked later in the phone settings, they show as off', () async {
    final (reminders, board) = await setUp(
      prefs: {Reminders.askedKey: true},
    );
    await reminders.refresh();
    expect(reminders.enabled, isFalse);
    expect(board.asked, 0);
  });

  Future<void> openDialog(WidgetTester tester, Reminders reminders) async {
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
  }

  testWidgets('the bell turns them off and on again', (tester) async {
    final (reminders, _) =
        await tester.runAsync(() => setUp(permitted: true)) ?? (throw 'setUp');
    await openDialog(tester, reminders);
    expect(find.text('Reminders'), findsOneWidget);
    await tester.tap(find.text('Turn off'));
    await tester.pumpAndSettle();
    expect(reminders.enabled, isFalse);
    await tester.tap(find.text('Turn on'));
    await tester.pumpAndSettle();
    expect(reminders.enabled, isTrue);
    expect(find.text('Turn off'), findsOneWidget);
  });

  testWidgets('when the phone says no, the dialog offers its settings', (
    tester,
  ) async {
    final (reminders, board) =
        await tester.runAsync(
          () => setUp(grant: false, prefs: {Reminders.enabledKey: false}),
        ) ??
        (throw 'setUp');
    await openDialog(tester, reminders);
    await tester.tap(find.text('Turn on'));
    await tester.pumpAndSettle();
    expect(reminders.enabled, isFalse);
    expect(find.textContaining('blocked'), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    await tester.pump();
    expect(board.settingsOpened, 1);
  });
}
