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
}
