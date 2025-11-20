import 'package:flutter/services.dart';

/// Service for communicating with native platform code
class PlatformChannelService {
  // Define the MethodChannel with a unique channel name
  static const MethodChannel _channel = MethodChannel('system_info');

  /// Get the native OS version
  /// Returns a string like "Android 14" or "iOS 18.0"
  Future<String> getSystemVersion() async {
    try {
      // Invoke the native method
      final String version = await _channel.invokeMethod('getSystemVersion');
      return version;
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      return "Failed to get system version: '${e.message}'";
    } catch (e) {
      // Handle other errors
      return "Failed to get system version: '$e'";
    }
  }

  /// Example: Get battery level (additional example)
  Future<int> getBatteryLevel() async {
    try {
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (e) {
      throw 'Failed to get battery level: ${e.message}';
    }
  }

  /// Example: Send data to native side
  Future<String> sendDataToNative(String data) async {
    try {
      final String result = await _channel.invokeMethod('processData', {
        'inputData': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      return result;
    } on PlatformException catch (e) {
      throw 'Failed to send data: ${e.message}';
    }
  }

  /// Send "Hello World" to native and receive response
  /// Returns a greeting message from native platform
  Future<String> sendHelloWorld() async {
    try {
      final String response = await _channel.invokeMethod('sendHelloWorld', {
        'message': 'Hello World',
        'fromFlutter': true,
      });
      return response;  
    } on PlatformException catch (e) {
      throw 'Failed to send Hello World: ${e.message}';
    }
  }

  /// Check if biometric authentication is available
  /// Returns true if device has biometric hardware and enrolled biometrics
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _channel.invokeMethod('isBiometricAvailable');
      return isAvailable;
    } on PlatformException catch (e) {
      throw 'Failed to check biometric availability: ${e.message}';
    }
  }

  /// Authenticate using biometric (fingerprint/face)
  /// Returns true if authentication successful, false otherwise
  Future<Map<String, dynamic>> authenticateWithBiometric({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'authenticateWithBiometric',
        {'reason': reason},
      );
      return {
        'success': result['success'] as bool,
        'message': result['message'] as String,
      };
    } on PlatformException catch (e) {
      return {
        'success': false,
        'message': 'Authentication failed: ${e.message}',
      };
    }
  }

  /// Add app shortcuts dynamically
  /// Shortcuts appear when long-pressing the app icon
  Future<void> addAppShortcuts(List<Map<String, String>> shortcuts) async {
    try {
      await _channel.invokeMethod('addAppShortcuts', {
        'shortcuts': shortcuts,
      });
    } on PlatformException catch (e) {
      throw 'Failed to add app shortcuts: ${e.message}';
    }
  }

  /// Get the shortcut action that launched the app
  /// Returns shortcut ID or null if app was launched normally
  Future<String?> getShortcutAction() async {
    try {
      final String? action = await _channel.invokeMethod('getShortcutAction');
      return action;
    } on PlatformException catch (e) {
      throw 'Failed to get shortcut action: ${e.message}';
    }
  }
}
