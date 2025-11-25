import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:banking_app/core/observers/debug_bloc_observer.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Enable BLoC debugging in debug mode
  if (kDebugMode) {
    Bloc.observer = DebugBlocObserver(
      enableLogging: true,
      enableAnalysis: true,
    );
  }

  await SentryFlutter.init((options) {
    options
      ..dsn = Env.sentryDsn
      ..environment = Env.sentryEnv
      ..tracesSampleRate = 1.0
      ..enableAutoPerformanceTracing = true
      ..enableAppLifecycleBreadcrumbs = true
      ..debug = Env.sentryEnv != 'production'
      ..beforeSend = (event, hint) {
        if (Env.sentryEnv == 'development') {
          final msg = event.message?.formatted ?? '';
          if (msg.contains('Hot reload')) return null;
        }
        return event;
      };
  }, appRunner: _runApp);
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

    /// Capture to Sentry as well
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
