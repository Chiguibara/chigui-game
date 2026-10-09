package es.chiguibara.chigui_game

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the game and exposes the system step counter to Dart (see
 * lib/walk/pedometer.dart). The counter is a low-power hardware sensor that
 * keeps counting while the app is closed; it reports the total steps since
 * the phone was last restarted.
 */
class MainActivity : FlutterActivity() {
    private val sensorManager by lazy {
        getSystemService(Context.SENSOR_SERVICE) as SensorManager
    }
    private val stepCounter: Sensor? by lazy {
        sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
    }
    private var listener: SensorEventListener? = null
    private var pendingPermission: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, "chigui/steps").setMethodCallHandler { call, result ->
            when (call.method) {
                "hasSensor" -> result.success(stepCounter != null)
                "requestPermission" -> requestActivityPermission(result)
                else -> result.notImplemented()
            }
        }

        EventChannel(messenger, "chigui/steps/total").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    val sensor = stepCounter ?: return events.endOfStream()
                    val sensorListener = object : SensorEventListener {
                        override fun onSensorChanged(event: SensorEvent) {
                            events.success(event.values[0].toLong())
                        }

                        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                    }
                    listener = sensorListener
                    sensorManager.registerListener(
                        sensorListener, sensor, SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    listener?.let { sensorManager.unregisterListener(it) }
                    listener = null
                }
            }
        )
    }

    /** Android 10+ asks the player for "physical activity"; older versions do not. */
    private fun requestActivityPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q ||
            checkSelfPermission(Manifest.permission.ACTIVITY_RECOGNITION) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            result.success(true)
            return
        }
        pendingPermission = result
        requestPermissions(arrayOf(Manifest.permission.ACTIVITY_RECOGNITION), REQUEST_STEPS)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REQUEST_STEPS) return
        val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        pendingPermission?.success(granted)
        pendingPermission = null
    }

    override fun onDestroy() {
        listener?.let { sensorManager.unregisterListener(it) }
        listener = null
        super.onDestroy()
    }

    private companion object {
        const val REQUEST_STEPS = 4217
    }
}
