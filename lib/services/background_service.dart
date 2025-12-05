import 'package:flutter/services.dart';

class BackgroundService {
  static const platform = MethodChannel('com.example.banking_app/bg_service');

  static Future<void> startService() async {
  await platform.invokeMethod('startService');
  }

  static Future<void> stopService() async {
    await platform.invokeMethod('stopService');
  }
}
