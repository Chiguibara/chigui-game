import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import 'package:web/web.dart' as web;

import 'motion_source.dart';

MotionSource? createMotionSource() => _WebMotionSource();

/// Browser `devicemotion` events. Works on phones' browsers; PCs usually
/// have no sensor and send nothing.
class _WebMotionSource implements MotionSource {
  JSFunction? _listener;

  @override
  Future<bool> start(MotionListener onSample) async {
    final api = globalContext['DeviceMotionEvent'];
    if (api == null) return false;
    try {
      // iPhone (iOS 13+) only sends motion after the player allows it.
      final apiObject = api as JSObject;
      if (apiObject.has('requestPermission')) {
        final answer = await apiObject
            .callMethod<JSPromise<JSString>>('requestPermission'.toJS)
            .toDart;
        if (answer.toDart != 'granted') return false;
      }
    } catch (_) {
      return false;
    }

    stop();
    final listener = ((web.DeviceMotionEvent event) {
      final a = event.accelerationIncludingGravity;
      final x = a?.x, y = a?.y, z = a?.z;
      if (x == null || y == null || z == null) return;
      onSample(event.timeStamp / 1000, sqrt(x * x + y * y + z * z));
    }).toJS;
    _listener = listener;
    web.window.addEventListener('devicemotion', listener);
    return true;
  }

  @override
  void stop() {
    final listener = _listener;
    if (listener != null) {
      web.window.removeEventListener('devicemotion', listener);
    }
    _listener = null;
  }
}
