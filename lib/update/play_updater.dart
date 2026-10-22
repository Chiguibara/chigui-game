import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'update_notice.dart';

/// What Google Play says about a newer version of the app.
enum PlayUpdateStatus {
  /// No update, one already downloading, or the check failed.
  none,

  /// A newer version can be downloaded in the background.
  available,

  /// A newer version has been downloaded and waits to be installed.
  downloaded,
}

/// Google Play's flexible in-app updates (see MainActivity.kt).
abstract interface class PlayUpdateApi {
  Future<PlayUpdateStatus> check();

  /// Shows Play's prompt to download the update found by [check]; true if
  /// the player agreed, false if they declined or anything failed.
  Future<bool> download();

  /// Restarts the app into the downloaded version.
  Future<void> install();

  /// Calls [onDownloaded] when a download finishes while the app runs.
  void listen(VoidCallback onDownloaded);
}

/// Keeps the Android app up to date from Google Play without ever blocking
/// play: when Play has a newer version it asks (at most once a day if the
/// player says no) to download it in the background, and once downloaded
/// the home screen offers to restart into it. Only works for installs from
/// Google Play; elsewhere every check quietly finds nothing.
class PlayUpdater extends ChangeNotifier implements UpdateNotice {
  PlayUpdater(this._api, this._prefs, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  /// After the player declines Play's prompt, wait this long to ask again.
  static const askEvery = Duration(days: 1);

  /// When the player last declined Play's prompt (milliseconds since epoch).
  static const declinedAtKey = 'playUpdate.declinedAt';

  final PlayUpdateApi _api;
  final SharedPreferences _prefs;
  final DateTime Function() _clock;
  bool _checking = false;
  bool _updateReady = false;
  bool _disposed = false;

  @override
  bool get updateReady => _updateReady;

  /// Listens for finished downloads and checks for the first time.
  Future<void> start() async {
    _api.listen(_ready);
    await check();
  }

  /// Asks Play again, e.g. when the game is shown after being away.
  Future<void> check() async {
    if (_updateReady || _checking || _disposed) return;
    _checking = true;
    try {
      switch (await _api.check()) {
        case PlayUpdateStatus.downloaded:
          _ready();
        case PlayUpdateStatus.available when !_declinedRecently:
          if (!await _api.download()) {
            await _prefs.setInt(
              declinedAtKey,
              _clock().millisecondsSinceEpoch,
            );
          }
        case _:
      }
    } finally {
      _checking = false;
    }
  }

  bool get _declinedRecently {
    final at = _prefs.getInt(declinedAtKey);
    if (at == null) return false;
    final since = _clock().difference(
      DateTime.fromMillisecondsSinceEpoch(at),
    );
    // A clock set back also counts as "a while ago".
    return !since.isNegative && since < askEvery;
  }

  void _ready() {
    if (_updateReady || _disposed) return;
    _updateReady = true;
    notifyListeners();
  }

  /// Restarts the game into the downloaded version.
  @override
  void update() => unawaited(_api.install());

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// [PlayUpdateApi] through MainActivity.kt; any failure means "nothing".
class PlayUpdateChannel implements PlayUpdateApi {
  static const _channel = MethodChannel('chigui/updates');

  @override
  Future<PlayUpdateStatus> check() async {
    try {
      final status = await _channel.invokeMethod<String>('check');
      return PlayUpdateStatus.values.asNameMap()[status] ??
          PlayUpdateStatus.none;
    } on Exception catch (error) {
      debugPrint('No Play update check: $error');
      return PlayUpdateStatus.none;
    }
  }

  @override
  Future<bool> download() async {
    try {
      return await _channel.invokeMethod<bool>('download') ?? false;
    } on Exception {
      return false;
    }
  }

  @override
  Future<void> install() async {
    try {
      await _channel.invokeMethod<void>('install');
    } on Exception catch (error) {
      debugPrint('No Play update install: $error');
    }
  }

  @override
  void listen(VoidCallback onDownloaded) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'downloaded') onDownloaded();
    });
  }
}
