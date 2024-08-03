package com.harishkunchala.pchannels_sensor_stream

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.harishkunchala.barometer/method"
    private val PRESSURE_STREAM_NAME = "com.harishkunchala.barometer/pressure"

    lateinit var sensorManager: SensorManager
    lateinit var methodChannel: MethodChannel

    var pressureChannel: EventChannel? = null
    var pressureStreamHandler: PressureStreamHandler? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        tearDownChannels()
        super.onDestroy()
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {
        // Call the SENSOR_SERVICE from context.getSystemService()
        sensorManager = context.getSystemService(SENSOR_SERVICE) as SensorManager

        // Initialize the method channel
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)

        // Set the method call handler
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "isSensorAvailable") {
                result.success(sensorManager.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            } else {
                result.notImplemented()
            }
        }

        // Initialize the event channel
        pressureChannel = EventChannel(messenger, PRESSURE_STREAM_NAME)

        pressureStreamHandler = PressureStreamHandler(sensorManager, Sensor.TYPE_PRESSURE)

        pressureChannel!!.setStreamHandler(pressureStreamHandler)

    }

    private fun tearDownChannels() {
        methodChannel.setMethodCallHandler(null)
        pressureChannel!!.setStreamHandler(null)
    }
}