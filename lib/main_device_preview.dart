import 'dart:ui';

import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
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

  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorSanitizer.logSecureError(
      error,
      stack,
      context: {'source': 'PlatformDispatcher'},
      isCritical: true,
    );
    return true;
  };
}
