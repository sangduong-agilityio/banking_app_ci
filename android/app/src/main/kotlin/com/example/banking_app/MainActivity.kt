package com.example.banking_app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    // Define the channel name (must match the Dart side)
    private val CHANNEL = "system_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up the MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSystemVersion" -> {
                    val version = getSystemVersion()
                    result.success(version)
                }
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "processData" -> {
                    // Example of receiving arguments from Dart
                    val inputData = call.argument<String>("inputData")
                    val timestamp = call.argument<Long>("timestamp")
                    
                    val processedData = "Processed: $inputData at $timestamp"
                    result.success(processedData)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Get the Android system version
     * Returns a string like "Android 14"
     */
    private fun getSystemVersion(): String {
        val release = Build.VERSION.RELEASE
        val sdkInt = Build.VERSION.SDK_INT
        return "Android $release (API $sdkInt)"
    }

    /**
     * Get the current battery level
     * Returns battery percentage (0-100) or -1 if unavailable
     */
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        
        return batteryLevel
    }
}
