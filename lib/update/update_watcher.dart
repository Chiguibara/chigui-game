import 'dart:async';

import 'package:flutter/foundation.dart';

import 'version_source.dart';

/// Notices when a newer version of the web game has been deployed while
/// its tab stays open (sometimes for days), so the home screen can offer
/// to reload. Checks at start, every [checkEvery], and on [check] (when
/// the tab is shown again). Failures are ignored.
class UpdateWatcher extends ChangeNotifier {
  UpdateWatcher(this._source);

  static const checkEvery = Duration(minutes: 20);

  final VersionSource _source;
  Timer? _timer;
  String? _running;
  bool _checking = false;
  bool _updateReady = false;
  bool _disposed = false;

  /// A version other than the running one has been deployed.
  bool get updateReady => _updateReady;

  /// Learns the running version and starts checking periodically.
  Future<void> start() async {
    _timer ??= Timer.periodic(checkEvery, (_) => check());
    await check();
  }

  Future<void> check() async {
    if (_updateReady || _checking) return;
    _checking = true;
    final version = await _source.latest();
    _checking = false;
    if (version == null || _disposed) return;
    // The first version read is the one running.
    final running = _running ??= version;
    if (version == running) return;
    _updateReady = true;
    _timer?.cancel();
    notifyListeners();
  }

  /// Reloads the page into the new version.
  void update() => _source.reload();

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
