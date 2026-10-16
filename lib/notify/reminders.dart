import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/pet_controller.dart';
import '../game/pet_state.dart';
import '../game/routine.dart';
import '../game/rules.dart' show routinePause;
import '../l10n/app_localizations.dart';

enum ReminderKind {
  meal,
  potty,
}

typedef Reminder = ({ReminderKind kind, DateTime at});

/// The reminders ahead of [now]: each mealtime and potty urge, but only
/// until the routine pauses (a day after the game was last open), and never
/// in class or at night, so they stop by themselves.
List<Reminder> upcomingReminders(PetState state, DateTime now) {
  final until = state.updatedAt.add(routinePause);
  final local = now.toLocal();
  final all = <Reminder>[
    for (var d = 0; d <= 1; d++)
      ...() {
        final s = scheduleFor(
          DateTime(local.year, local.month, local.day + d),
          state.seed,
        );
        return [
          for (final meal in s.meals) (kind: ReminderKind.meal, at: meal.start),
          for (final urge in s.pottyUrges) (kind: ReminderKind.potty, at: urge),
        ];
      }(),
  ];
  return [
    for (final r in all)
      if (r.at.isAfter(now) &&
          r.at.isBefore(until) &&
          !inSchool(r.at) &&
          !isNight(r.at, state.seed))
        r,
  ]..sort((a, b) => a.at.compareTo(b.at));
}

/// A notification to show at a moment, with its text.
typedef ScheduledNotice = ({DateTime at, String title, String body});

/// Where reminders are shown: the system's notifications in the Android app.
abstract interface class NoticeBoard {
  /// Asks the system to allow notifications; false if not allowed.
  Future<bool> requestPermission();

  /// Whether notifications are allowed now (they can be turned off in the
  /// phone's settings at any time).
  Future<bool> allowed();

  /// Opens the phone's notification settings for the game, for when the
  /// system no longer asks (after being told no twice).
  Future<void> openSettings();

  /// Replaces every scheduled notification with [notices].
  Future<void> replace(
    List<ScheduledNotice> notices, {
    required String channel,
  });
}

/// Gentle routine reminders (meals and potty), on from the start: the
/// system asks for permission on the first launch, and saying no (or
/// blocking them later in the phone's settings) turns them off. They are
/// only scheduled while the game is in the background: opening the game
/// clears them, leaving it schedules the next ones.
class Reminders extends ChangeNotifier {
  Reminders(this._board, this._prefs, this._pet, {this._locale});

  static const enabledKey = 'settings.reminders';

  /// Whether the system was already asked on its own, on the first launch.
  static const askedKey = 'settings.remindersAsked';

  final NoticeBoard _board;
  final SharedPreferences _prefs;
  final PetController _pet;
  final Locale? _locale;

  /// On unless turned off, from the bell or by saying no to the system.
  bool get enabled => _prefs.getBool(enabledKey) ?? true;

  /// False if the system did not allow notifications.
  Future<bool> turnOn() async {
    if (!await _board.requestPermission()) return false;
    await _prefs.setBool(enabledKey, true);
    notifyListeners();
    return true;
  }

  /// The game is open: the first time, the system asks for permission.
  /// If notifications are not allowed (a "no", or blocked later in the
  /// phone's settings), the reminders show as off, and turning them on
  /// again asks again.
  Future<void> refresh() async {
    if (!enabled || await _board.allowed()) return;
    if (!(_prefs.getBool(askedKey) ?? false)) {
      await _prefs.setBool(askedKey, true);
      if (await _board.requestPermission()) return;
    }
    await _prefs.setBool(enabledKey, false);
    notifyListeners();
  }

  Future<void> openSettings() => _board.openSettings();

  Future<void> turnOff() async {
    await _prefs.setBool(enabledKey, false);
    notifyListeners();
    await clear();
  }

  /// The game is open: no reminders needed.
  Future<void> clear() => _board.replace([], channel: _l10n.reminderChannel);

  /// The game went to the background: schedule what comes next.
  Future<void> scheduleAhead() {
    final l10n = _l10n;
    if (!enabled) return clear();
    return _board.replace(
      [
        for (final r in upcomingReminders(_pet.state, _pet.now))
          (
            at: r.at,
            title: l10n.appTitle,
            body: switch (r.kind) {
              ReminderKind.meal => l10n.reminderMeal,
              ReminderKind.potty => l10n.reminderPotty,
            },
          ),
      ],
      channel: l10n.reminderChannel,
    );
  }

  AppLocalizations get _l10n {
    final wanted = _locale ?? PlatformDispatcher.instance.locale;
    final locale = AppLocalizations.supportedLocales
        .where((l) => l.languageCode == wanted.languageCode)
        .firstOrNull;
    return lookupAppLocalizations(locale ?? const Locale('en'));
  }
}
