
import 'package:banking_app/app/app.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';


// Guard to avoid initializing Firebase multiple times

Future<void> main() async {
 
   runApp(
    DevicePreview(enabled: true, builder: (context) => const BankingApp()),
  );
}
