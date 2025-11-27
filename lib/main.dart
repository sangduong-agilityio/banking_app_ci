import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:banking_app/core/observers/debug_bloc_observer.dart';

Future<void> main() async {
  // Enable BLoC debugging in debug mode
  if (kDebugMode) {
    Bloc.observer = DebugBlocObserver(
      enableLogging: true,
      enableAnalysis: true,
    );
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

    // Sentry removed: use Crashlytics hoặc log locally nếu cần
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorSanitizer.logSecureError(
      error,
      stack,
      context: {'source': 'PlatformDispatcher'},
      isCritical: true,
    );
    // Sentry removed: use Crashlytics hoặc log locally nếu cần
    return true;
  };
}
