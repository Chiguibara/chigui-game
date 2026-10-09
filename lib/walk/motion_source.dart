import 'motion_source_stub.dart'
    if (dart.library.js_interop) 'motion_source_web.dart'
    as platform;

/// Receives samples of the device's acceleration magnitude (m/s², including
/// gravity) with a timestamp in seconds.
typedef MotionListener = void Function(double seconds, double magnitude);

/// The device's motion sensor, if this platform exposes one to the game.
abstract interface class MotionSource {
  /// Starts listening. On some browsers (iPhone) this asks the player for
  /// permission, so call it from a button press. Returns false if motion is
  /// unavailable or permission was denied. A device without a sensor (most
  /// PCs) may return true and simply never send samples.
  Future<bool> start(MotionListener onSample);

  void stop();
}

/// The motion sensor for this platform, or null if there is none (the
/// Android app will use the system pedometer instead).
MotionSource? createMotionSource() => platform.createMotionSource();
