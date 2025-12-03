import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Configure Crashlytics for production-ready error tracking
  await _configureCrashlytics();

 

  _runApp();
}

/// Determine if an error should be marked as fatal
bool _isFatalError(Object error) {
  // Network errors are usually non-fatal (user can retry)
  if (error.toString().toLowerCase().contains('socket')) return false;
  if (error.toString().toLowerCase().contains('network')) return false;
  if (error.toString().toLowerCase().contains('timeout')) return false;
  
  // Type errors are usually fatal
  if (error is TypeError) return true;
  if (error is NoSuchMethodError) return true;
  
  // Null errors are fatal
  if (error.toString().contains('Null check operator')) return true;
  
  // Default: treat as fatal
  return true;
}

/// Configure Firebase Crashlytics with enhanced error tracking
Future<void> _configureCrashlytics() async {
  // Set Crashlytics collection enabled
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Enhanced Flutter error handler with context
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }

    // Always report to Crashlytics with full context
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    
    // Add breadcrumb for context
    FirebaseCrashlytics.instance.log(
      'Flutter Error: ${details.exception.runtimeType} in ${details.library ?? "unknown"}',
    );
  };

  // Enhanced async error handler
  PlatformDispatcher.instance.onError = (error, stack) {
    // Determine if error is fatal
    final isFatal = _isFatalError(error);
    
    // Log breadcrumb
    FirebaseCrashlytics.instance.log(
      'Async Error: ${error.runtimeType} - Fatal: $isFatal',
    );
    
    // Record to Crashlytics
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: isFatal,
      reason: 'Uncaught async error',
    );
    
    return true;
  };

  // Log app start
  FirebaseCrashlytics.instance.log('App started successfully');
}

Future<void> _runApp() async {
  _setupGlobalErrorHandlers();

  await Future.wait([
    Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey),
    AppLocators.setupLocators(),
    initializeDateFormatting('en_US'),
  ]);

  await locator.allReady();

  runApp(const BankingApp());
}

void _setupGlobalErrorHandlers() {
  // Set custom keys for all crashes
  FirebaseCrashlytics.instance.setCustomKey('app_environment', kDebugMode ? 'debug' : 'production');
  FirebaseCrashlytics.instance.setCustomKey('flutter_version', 'Flutter 3.x');
  
  // Log initialization complete
  FirebaseCrashlytics.instance.log('Global error handlers configured');
}

