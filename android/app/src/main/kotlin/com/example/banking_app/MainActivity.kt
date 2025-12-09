package com.example.banking_app

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.drawable.Icon
import android.os.BatteryManager
import android.os.Build
import android.util.Log
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executor
import com.example.banking_app.widget.ExchangeRateWidgetProvider
import com.example.banking_app.widget.WidgetWorkManager
import com.example.banking_app.service.BackgroundTimerService

class MainActivity : FlutterFragmentActivity() {
    companion object {
        private const val TAG = "PlatformChannel"
    }
    
    // Define the channel name (must match the Dart side)
    private val CHANNEL = "system_info"
    private val WIDGET_CHANNEL = "com.example.banking_app/widget"
    private val BG_SERVICE_CHANNEL = "com.example.banking_app/bg_service"
    private var shortcutAction: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d(TAG, "Configuring Flutter engine and setting up MethodChannels")

        // Set up the main MethodChannel
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
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "processData" -> {
                    val inputData = call.argument<String>("inputData")
                    val timestamp = call.argument<Long>("timestamp")
                    Log.d(TAG, "Processing data: $inputData at $timestamp")
                    
                    val processedData = "Processed: $inputData at $timestamp"
                    result.success(processedData)
                }
                "sendHelloWorld" -> {
                    val message = call.argument<String>("message")
                    val fromFlutter = call.argument<Boolean>("fromFlutter") ?: false
                    Log.d(TAG, "Received Hello World: message='$message', fromFlutter=$fromFlutter")
                    
                    val response = if (fromFlutter) {
                        "Android says: Received '$message' from Flutter!"
                    } else {
                        "Android says: Hello!"
                    }
                    Log.d(TAG, "Sending response: $response")
                    result.success(response)
                }
                "isBiometricAvailable" -> {
                    Log.d(TAG, "Checking biometric availability...")
                    val isAvailable = isBiometricAvailable()
                    Log.i(TAG, "Biometric available: $isAvailable")
                    result.success(isAvailable)
                }
                "authenticateWithBiometric" -> {
                    val reason = call.argument<String>("reason") ?: "Authenticate to continue"
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

        // Set up the Widget MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
            val startTime = System.currentTimeMillis()
            Log.i(TAG, "Widget method called: ${call.method}")
            
            when (call.method) {
                "updateExchangeRates" -> {
                    val ratesJson = call.argument<String>("rates")
                    if (ratesJson != null) {
                        Log.d(TAG, "Updating widget with exchange rates...")
                        updateWidgetExchangeRates(ratesJson)
                        result.success(true)
                    } else {
                        Log.e(TAG, "Exchange rates data is null")
                        result.error("INVALID_ARGUMENT", "Exchange rates data is null", null)
                    }
                }
                "initializeWidget" -> {
                    val apiEndpoint = call.argument<String>("apiEndpoint")
                    Log.d(TAG, "Initializing widget with API endpoint: $apiEndpoint")
                    initializeWidgetWork(apiEndpoint)
                    result.success(true)
                }
                "refreshWidget" -> {
                    Log.d(TAG, "Triggering widget refresh...")
                    WidgetWorkManager.forceRefresh(this)
                    result.success(true)
                }
                "isWidgetSupported" -> {
                    result.success(true)
                }
                else -> {
                    Log.w(TAG, "Widget method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
            
            val duration = System.currentTimeMillis() - startTime
            Log.i(TAG, "Widget method '${call.method}' completed in ${duration}ms")
        }

        // Set up the Background Service MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BG_SERVICE_CHANNEL).setMethodCallHandler { call, result ->
            Log.i(TAG, "Background service method called: ${call.method}")
            
            when (call.method) {
                "startService" -> {
                    startService(Intent(this, BackgroundTimerService::class.java))
                    Log.d(TAG, "Background service started")
                    result.success("Service started")
                }
                "stopService" -> {
                    stopService(Intent(this, BackgroundTimerService::class.java))
                    Log.d(TAG, "Background service stopped")
                    result.success("Service stopped")
                }
                else -> {
                    Log.w(TAG, "Background service method not implemented: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i(TAG, "MainActivity onCreate")
        handleShortcutIntent(intent)
        
        // Initialize widget work manager for background updates
        WidgetWorkManager.initialize(this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.i(TAG, "MainActivity onNewIntent")
        handleShortcutIntent(intent)
        
        // Check if we need to refresh exchange rates (from widget)
        if (intent.getStringExtra("action") == "refresh_exchange_rates") {
            Log.i(TAG, "Widget requested exchange rates refresh")
            // The Flutter app should handle this via a callback or event
        }
    }

    private fun handleShortcutIntent(intent: Intent) {
        val action = intent.getStringExtra("shortcut_action")
        if (action != null) {
            Log.i(TAG, "Shortcut action detected: $action")
            shortcutAction = action
        }
    }

    /**
     * Updates the home screen widget with new exchange rate data.
     * Called from Flutter when new rates are fetched.
     */
    private fun updateWidgetExchangeRates(ratesJson: String) {
        ExchangeRateWidgetProvider.saveExchangeRates(this, ratesJson)
        ExchangeRateWidgetProvider.updateWidgets(this)
        Log.i(TAG, "Widget updated with new exchange rates")
    }

    /**
     * Initializes background work for widget updates.
     * Stores the API endpoint for the worker to use.
     */
    private fun initializeWidgetWork(apiEndpoint: String?) {
        if (apiEndpoint != null) {
            val prefs = getSharedPreferences("flutter_prefs", Context.MODE_PRIVATE)
            prefs.edit().putString("api_endpoint", apiEndpoint).apply()
            Log.d(TAG, "Saved API endpoint for widget: $apiEndpoint")
        }
        WidgetWorkManager.initialize(this)
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
        Log.d(TAG, "Setting up biometric prompt...")
        val executor: Executor = ContextCompat.getMainExecutor(this)
        val biometricPrompt = BiometricPrompt(this, executor,
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    super.onAuthenticationError(errorCode, errString)
                    Log.e(TAG, "Biometric authentication error: $errString (code: $errorCode)")
                    result.success(mapOf(
                        "success" to false,
                        "message" to "Authentication error: $errString"
                    ))
                }

                override fun onAuthenticationSucceeded(authResult: BiometricPrompt.AuthenticationResult) {
                    super.onAuthenticationSucceeded(authResult)
                    Log.i(TAG, "Biometric authentication succeeded!")
                    result.success(mapOf(
                        "success" to true,
                        "message" to "Authentication successful!"
                    ))
                }

                override fun onAuthenticationFailed() {
                    super.onAuthenticationFailed()
                    Log.w(TAG, "Biometric authentication failed (user can retry)")
                }
            })

        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Biometric Authentication")
            .setSubtitle(reason)
            .setNegativeButtonText("Cancel")
            .build()

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
}
