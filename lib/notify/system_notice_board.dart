import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'reminders.dart';

/// Android's notifications, scheduled ahead so they show while the game is
/// closed (and again after a restart). Inexact timing: a few minutes late is
/// fine, and it needs no exact-alarm permission.
class SystemNoticeBoard implements NoticeBoard {
  final _plugin = FlutterLocalNotificationsPlugin();
  late final Future<void> _ready = _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
    ),
  );

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<bool> requestPermission() async {
    await _ready;
    return await _android?.requestNotificationsPermission() ?? false;
  }

  @override
  Future<bool> allowed() async {
    await _ready;
    return await _android?.areNotificationsEnabled() ?? false;
  }

  @override
  Future<void> openSettings() async {
    await _ready;
    await _android?.openAppNotificationSettings();
  }

  @override
  Future<void> replace(
    List<ScheduledNotice> notices, {
    required String channel,
  }) async {
    await _ready;
    await _plugin.cancelAll();
    for (final (i, notice) in notices.indexed) {
      await _plugin.zonedSchedule(
        id: i,
        // Moments are absolute, so UTC needs no time-zone database.
        scheduledDate: tz.TZDateTime.from(notice.at.toUtc(), tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails('routine', channel),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: notice.title,
        body: notice.body,
      );
    }
  }
}
