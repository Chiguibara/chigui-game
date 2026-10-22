import 'package:flutter/foundation.dart';

/// Tells the home screen that a newer version of the game is ready, so it
/// can offer a gentle button to switch to it.
abstract interface class UpdateNotice implements Listenable {
  /// A newer version is ready to switch to.
  bool get updateReady;

  /// Switches to the newer version (reloads or restarts the game).
  void update();
}
