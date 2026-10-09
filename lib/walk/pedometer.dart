import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/pet_controller.dart';

// Provisional tuning: about 100 metres at a child's ~60 cm per step. The
// system counter reports in batches, so pauses between readings can be long.
const pedometerWalkStartSteps = 160;
const pedometerWalkStartMaxGap = Duration(seconds: 20);

/// The Android system step counter (see MainActivity.kt). It counts while
/// the app is closed, so every step reaches the game: steps taken while
/// closed are added when the app opens, and steps taken while it is open
/// are added as they come and also reported on [liveSteps].
class Pedometer {
  Pedometer(this._pet, this._prefs);

  static const _method = MethodChannel('chigui/steps');
  static const _totals = EventChannel('chigui/steps/total');

  /// The last system total seen, to know how many steps are new.
  static const lastTotalKey = 'pedometer.lastTotal';

  final PetController _pet;
  final SharedPreferences _prefs;
  final _live = StreamController<int>.broadcast();
  StreamSubscription<dynamic>? _subscription;
  bool _caughtUp = false;

  /// New steps while the app is open, in batches.
  Stream<int> get liveSteps => _live.stream;

  /// True once counting started (or a reading arrived).
  bool get running => _subscription != null || _caughtUp;

  /// Asks for the "physical activity" permission (Android 10+) and starts
  /// counting. Returns false without a step sensor or permission.
  Future<bool> start() async {
    if (running) return true;
    try {
      if (await _method.invokeMethod<bool>('hasSensor') != true) return false;
      if (await _method.invokeMethod<bool>('requestPermission') != true) {
        return false;
      }
    } on PlatformException catch (error) {
      debugPrint('No step counter: $error');
      return false;
    }
    _subscription = _totals.receiveBroadcastStream().listen(
      (total) => onTotal((total as num).toInt()),
    );
    return true;
  }

  /// Handles a system total. The first reading after starting catches up on
  /// steps taken while the app was closed; later ones are live.
  @visibleForTesting
  void onTotal(int total) {
    final last = _prefs.getInt(lastTotalKey);
    _prefs.setInt(lastTotalKey, total);
    final catchingUp = !_caughtUp;
    _caughtUp = true;
    // The very first reading on this phone only sets the starting point.
    if (last == null) return;
    // The counter restarts at zero when the phone restarts.
    final steps = total >= last ? total - last : total;
    if (steps <= 0) return;
    _pet.addSteps(steps);
    if (!catchingUp) _live.add(steps);
  }

  void dispose() {
    _subscription?.cancel();
    _live.close();
  }
}
