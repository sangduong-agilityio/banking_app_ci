package com.example.banking_app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
<<<<<<< HEAD
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.BatteryManager
import android.os.Build
import android.util.Log
=======
import android.os.BatteryManager
import android.os.Build
>>>>>>> b809db52c8320cb0078995620a649233a6517937
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executor

class MainActivity : FlutterFragmentActivity() {
<<<<<<< HEAD
    companion object {
        private const val TAG = "PlatformChannel"
    }
    
    // Define the channel name (must match the Dart side)
    private val CHANNEL = "system_info"
    private var shortcutAction: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d(TAG, "Configuring Flutter engine and setting up MethodChannel")

        // Set up the MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val startTime = System.currentTimeMillis()
            Log.i(TAG, "Method called: ${call.method}")
            
            when (call.method) {
                "getSystemVersion" -> {
                    Log.d(TAG, "Getting system version...")
                    val version = getSystemVersion()
                    Log.d(TAG, "System version: $version")
                    result.success(version)
                }
                "getBatteryLevel" -> {
                    Log.d(TAG, "Getting battery level...")
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        Log.d(TAG, "Battery level: $batteryLevel%")
                        result.success(batteryLevel)
                    } else {
                        Log.e(TAG, "Battery level unavailable")
=======
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
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "processData" -> {
<<<<<<< HEAD
                    val inputData = call.argument<String>("inputData")
                    val timestamp = call.argument<Long>("timestamp")
                    Log.d(TAG, "Processing data: $inputData at $timestamp")
=======
                    // Example of receiving arguments from Dart
                    val inputData = call.argument<String>("inputData")
                    val timestamp = call.argument<Long>("timestamp")
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                    
                    val processedData = "Processed: $inputData at $timestamp"
                    result.success(processedData)
                }
                "sendHelloWorld" -> {
<<<<<<< HEAD
                    val message = call.argument<String>("message")
                    val fromFlutter = call.argument<Boolean>("fromFlutter") ?: false
                    Log.d(TAG, "Received Hello World: message='$message', fromFlutter=$fromFlutter")
                    
=======
                    // Receive Hello World from Flutter
                    val message = call.argument<String>("message")
                    val fromFlutter = call.argument<Boolean>("fromFlutter") ?: false
                    
                    // Process and send response back to Flutter
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                    val response = if (fromFlutter) {
                        "Android says: Received '$message' from Flutter!"
                    } else {
                        "Android says: Hello!"
                    }
<<<<<<< HEAD
                    Log.d(TAG, "Sending response: $response")
                    result.success(response)
                }
                "isBiometricAvailable" -> {
                    Log.d(TAG, "Checking biometric availability...")
                    val isAvailable = isBiometricAvailable()
                    Log.i(TAG, "Biometric available: $isAvailable")
=======
                    
                    result.success(response)
                }
                "isBiometricAvailable" -> {
                    val isAvailable = isBiometricAvailable()
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                    result.success(isAvailable)
                }
                "authenticateWithBiometric" -> {
                    val reason = call.argument<String>("reason") ?: "Authenticate to continue"
<<<<<<< HEAD
                    Log.i(TAG, "Starting biometric authentication with reason: $reason")
                    authenticateWithBiometric(reason, result)
                }
                "addAppShortcuts" -> {
                    val shortcuts = call.argument<List<Map<String, String>>>("shortcuts")
                    Log.d(TAG, "Adding ${shortcuts?.size ?: 0} app shortcuts")
                    if (shortcuts != null) {
                        addAppShortcuts(shortcuts)
                        Log.i(TAG, "App shortcuts added successfully")
                        result.success(null)
                    } else {
                        Log.e(TAG, "Shortcuts list is null")
                        result.error("INVALID_ARGUMENT", "Shortcuts list is null", null)
                    }
                }
                "getShortcutAction" -> {
                    Log.d(TAG, "Getting shortcut action: $shortcutAction")
                    result.success(shortcutAction)
                    shortcutAction = null
                }
                else -> {
                    Log.w(TAG, "Method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
            
            val duration = System.currentTimeMillis() - startTime
            Log.i(TAG, "Method '${call.method}' completed in ${duration}ms")
        }
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i(TAG, "MainActivity onCreate")
        handleShortcutIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.i(TAG, "MainActivity onNewIntent")
        handleShortcutIntent(intent)
    }

    private fun handleShortcutIntent(intent: Intent) {
        val action = intent.getStringExtra("shortcut_action")
        if (action != null) {
            Log.i(TAG, "Shortcut action detected: $action")
            shortcutAction = action
=======
                    authenticateWithBiometric(reason, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
>>>>>>> b809db52c8320cb0078995620a649233a6517937
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
<<<<<<< HEAD
        Log.d(TAG, "Setting up biometric prompt...")
=======
>>>>>>> b809db52c8320cb0078995620a649233a6517937
        val executor: Executor = ContextCompat.getMainExecutor(this)
        val biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
<<<<<<< HEAD
                    Log.e(TAG, "Biometric authentication error: $errString (code: $errorCode)")
=======
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                    result.success(mapOf(
                        "success" to false,
                        "message" to "Authentication error: $errString"
                    ))
                }

                override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(authResult)
<<<<<<< HEAD
                    Log.i(TAG, "Biometric authentication succeeded!")
                    result.success(mapOf(
                        "success" to true,
                        "message" to "Authentication successful!"
=======
                    result.success(mapOf(
                        "success" to true,
                        "message" to "Authentication successful! 🎉"
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                    ))
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
<<<<<<< HEAD
                    Log.w(TAG, "Biometric authentication failed (user can retry)")
=======
                    // Don't call result here - let user try again
>>>>>>> b809db52c8320cb0078995620a649233a6517937
                }
            })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Biometric Authentication")
            .setSubtitle(reason)
            .setNegativeButtonText("Cancel")
            .build()

<<<<<<< HEAD
        Log.d(TAG, "Showing biometric prompt to user...")
        biometricPrompt.authenticate(promptInfo)
    }

    /**
     * Add dynamic app shortcuts
     */
    private fun addAppShortcuts(shortcuts: List<Map<String, String>>) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N_MR1) {
            Log.d(TAG, "Creating ${shortcuts.size} dynamic shortcuts...")
            val shortcutManager = getSystemService(ShortcutManager::class.java)
            val shortcutInfoList = shortcuts.mapIndexed { index, shortcut ->
                val id = shortcut["id"] ?: "shortcut_$index"
                val label = shortcut["label"] ?: "Shortcut"
                val icon = shortcut["icon"] ?: "ic_launcher"
                
                Log.d(TAG, "  - Creating shortcut: id=$id, label=$label")
                
                val intent = Intent(this, MainActivity::class.java)
                intent.action = Intent.ACTION_VIEW
                intent.putExtra("shortcut_action", id)
                
                ShortcutInfo.Builder(this, id)
                    .setShortLabel(label)
                    .setLongLabel(label)
                    .setIcon(Icon.createWithResource(this, android.R.drawable.ic_menu_send))
                    .setIntent(intent)
                    .build()
            }
            
            shortcutManager?.dynamicShortcuts = shortcutInfoList
            Log.i(TAG, "${shortcutInfoList.size} shortcuts registered with ShortcutManager")
        } else {
            Log.w(TAG, "Dynamic shortcuts not supported on API ${Build.VERSION.SDK_INT}")
        }
    }
=======
        biometricPrompt.authenticate(promptInfo)
    }
>>>>>>> b809db52c8320cb0078995620a649233a6517937
}
