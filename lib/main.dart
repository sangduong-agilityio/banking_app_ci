import 'dart:ui';
import 'package:banking_app/app/app.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

/// Entry point of the application
void main() async {
  // Ensure Flutter and Sentry bindings are initialized before running the app
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Initialize Sentry for crash/error tracking
  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;
    options.environment = Env.sentryEnv;
    options.tracesSampleRate = 1.0;
    options.debug = Env.sentryEnv != 'production';

    // Filter out unnecessary events (e.g., hot reload logs in dev mode)
    options.beforeSend = (event, hint) {
      if (Env.sentryEnv == 'development') {
        final msg = event.message?.formatted ?? '';
        if (msg.contains('Hot reload')) return null;
      }
      return event;
    };
  }, appRunner: _runApp);
}

/// Runs the main app logic
Future<void> _runApp() async {
  // Set up centralized error handling for both Flutter and Dart errors
  _setupGlobalErrorHandlers();

  // Initialize Supabase (backend & database connection)
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

  // Set up dependency injection container
  await AppLocators.setupLocators();
  await locator.allReady();

  // Initialize date formatting for localization
  await initializeDateFormatting('en_US');

  // Run the Flutter app
  runApp(const BankingApp());
}

/// Defines how global errors are handled and logged securely
void _setupGlobalErrorHandlers() {
  // Catch and log all Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);

    await ErrorSanitizer.logSecureError(
      details.exception,
      details.stack,
      context: {
        'library': details.library ?? 'unknown',
        'context': details.context?.toString(),
        'silent': details.silent,
      },
      isCritical: !details.silent,
    );
  };

  // Catch and log platform-level or Dart runtime errors
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorSanitizer.logSecureError(
      error,
      stack,
      context: {'source': 'platform_dispatcher'},
      isCritical: true,
    );
    return true;
  };
}
