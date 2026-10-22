package es.chiguibara.chigui_game

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the game and exposes the system step counter to Dart (see
 * lib/walk/pedometer.dart). The counter is a low-power hardware sensor that
 * keeps counting while the app is closed; it reports the total steps since
 * the phone was last restarted.
 *
 * It also runs Google Play's flexible in-app updates for Dart (see
 * lib/update/play_updater.dart): a newer version downloads in the
 * background, after the player agrees in Play's prompt, and installs when
 * Dart asks. This only works for installs from Google Play; testing it needs
 * a newer version on a Play track (e.g. two internal-testing beta tags).
 * Every failure (sideloaded, no Play services, offline) is silent.
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
    private val appUpdates by lazy { AppUpdateManagerFactory.create(this) }
    private var updatesChannel: MethodChannel? = null
    private var availableUpdate: AppUpdateInfo? = null
    private val installListener = InstallStateUpdatedListener { state ->
        if (state.installStatus() == InstallStatus.DOWNLOADED) {
            updatesChannel?.invokeMethod("downloaded", null)
        }
    }

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

        updatesChannel = MethodChannel(messenger, "chigui/updates").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "check" -> checkForUpdate(result)
                    "download" -> downloadUpdate(result)
                    "install" -> {
                        runCatching { appUpdates.completeUpdate() }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        runCatching { appUpdates.registerListener(installListener) }

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

    /**
     * Answers "downloaded" (waiting to install), "available" (a flexible
     * update can start), or "none" (anything else, failures included).
     */
    private fun checkForUpdate(result: MethodChannel.Result) {
        try {
            appUpdates.appUpdateInfo
                .addOnSuccessListener { info ->
                    availableUpdate = null
                    val status = when {
                        info.installStatus() == InstallStatus.DOWNLOADED -> "downloaded"
                        info.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                            info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE) -> {
                            availableUpdate = info
                            "available"
                        }
                        else -> "none"
                    }
                    result.success(status)
                }
                .addOnFailureListener { result.success("none") }
        } catch (e: Exception) {
            result.success("none")
        }
    }

    /**
     * Shows Play's prompt for the update found by the last check (flexible
     * only, never the blocking mode). Answers true if the player agreed and
     * the download started; false if they declined or anything failed.
     */
    private fun downloadUpdate(result: MethodChannel.Result) {
        val info = availableUpdate ?: return result.success(false)
        // Play allows each AppUpdateInfo to start a flow only once.
        availableUpdate = null
        try {
            appUpdates
                .startUpdateFlow(
                    info, this, AppUpdateOptions.defaultOptions(AppUpdateType.FLEXIBLE)
                )
                .addOnSuccessListener { code -> result.success(code == Activity.RESULT_OK) }
                .addOnFailureListener { result.success(false) }
        } catch (e: Exception) {
            result.success(false)
        }
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
        runCatching { appUpdates.unregisterListener(installListener) }
        updatesChannel = null
        super.onDestroy()
    }

    private companion object {
        const val REQUEST_STEPS = 4217
    }
}
