package com.example.banking_app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executor

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
                "sendHelloWorld" -> {
                    // Receive Hello World from Flutter
                    val message = call.argument<String>("message")
                    val fromFlutter = call.argument<Boolean>("fromFlutter") ?: false
                    
                    // Process and send response back to Flutter
                    val response = if (fromFlutter) {
                        "Android says: Received '$message' from Flutter!"
                    } else {
                        "Android says: Hello!"
                    }
                    
                    result.success(response)
                }
                "isBiometricAvailable" -> {
                    val isAvailable = isBiometricAvailable()
                    result.success(isAvailable)
                }
                "authenticateWithBiometric" -> {
                    val reason = call.argument<String>("reason") ?: "Authenticate to continue"
                    authenticateWithBiometric(reason, result)
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

    /**
     * Check if biometric authentication is available
     */
    private fun isBiometricAvailable(): Boolean {
        val biometricManager = BiometricManager.from(this)
        return when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_STRONG or BiometricManager.Authenticators.BIOMETRIC_WEAK)) {
            BiometricManager.BIOMETRIC_SUCCESS -> true
            else -> false
        }
    }

    /**
     * Authenticate using biometric
     */
    private fun authenticateWithBiometric(reason: String, result: MethodChannel.Result) {
        val executor: Executor = ContextCompat.getMainExecutor(this)
        val biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                    result.success(mapOf(
                        "success" to false,
                        "message" to "Authentication error: $errString"
                    ))
                }

                override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(authResult)
                    result.success(mapOf(
                        "success" to true,
                        "message" to "Authentication successful! 🎉"
                    ))
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    // Don't call result here - let user try again
                }
            })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Biometric Authentication")
            .setSubtitle(reason)
            .setNegativeButtonText("Cancel")
            .build()

        biometricPrompt.authenticate(promptInfo)
    }
}
