import 'dart:ui';

import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Guard to avoid initializing Firebase multiple times
bool _firebaseInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!_firebaseInitialized) {
    await Firebase.initializeApp();
    
    // Enable Crashlytics collection
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    
    _firebaseInitialized = true;
  }

  await _runApp();
}

Future<void> _runApp() async {
  _setupGlobalErrorHandlers();

  await Future.wait([
    Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey),
    AppLocators.setupLocators(),
    initializeDateFormatting('en_US'),
  ]);

  await locator.allReady();

  runApp(
    DevicePreview(enabled: true, builder: (context) => const BankingApp()),
  );
}

void _setupGlobalErrorHandlers() {
  // Firebase Crashlytics is already set up in main()
  // Additional error handling can be added here if needed
}
