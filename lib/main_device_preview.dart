import 'dart:ui';

import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Guard to avoid initializing Sentry multiple times (hot restart / multiple entry files)
bool _sentryInitialized = false;

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  if (!_sentryInitialized) {
    await SentryFlutter.init((options) {
    // Don't send events from device-preview / local runs. Only enable DSN in production.
    options
      ..dsn = Env.sentryEnv == 'production' ? Env.sentryDsn : ''
      ..environment = '${Env.sentryEnv}-device-preview'
      ..tracesSampleRate = 1.0
      ..enableAutoPerformanceTracing = true
      ..enableAppLifecycleBreadcrumbs = true
      ..debug = Env.sentryEnv != 'production'
      ..beforeSend = (event, hint) {
        final msg = event.message?.formatted ?? '';
        if (msg.contains('Hot reload')) return null;
        return event;
      };
    }, appRunner: _runApp);
    _sentryInitialized = true;
  } else {
    await _runApp();
  }
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
    DevicePreview(
      enabled: true,
      builder: (context) => const BankingApp(),
    ),
  );
}

void _setupGlobalErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorSanitizer.logSecureError(
      details.exception,
      details.stack,
      context: {
        'library': details.library ?? 'unknown',
        'context': details.context?.toString(),
      },
      isCritical: !details.silent,
    );

    Sentry.captureException(details.exception, stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorSanitizer.logSecureError(
      error,
      stack,
      context: {'source': 'PlatformDispatcher'},
      isCritical: true,
    );
    Sentry.captureException(error, stackTrace: stack);
    return true;
  };
}
