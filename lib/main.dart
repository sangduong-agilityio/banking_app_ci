import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/app/app.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/config.dart';
import 'package:http/http.dart' as http;
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/error_handling/error_sanitizer.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();

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
    Config.load(),
  ]);

  await locator.allReady();

  // Quick AG-UI connection test on startup (non-blocking)
  _testAgUiConnection();

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

void _testAgUiConnection() async {
  try {
    final url = Uri.parse('${Config.aguiBaseUrl.replaceAll(RegExp(r'/$'), '')}/tool_based_generative_ui');
    final client = http.Client();
    final payload = {
      'threadId': 'test_thread',
      'runId': 'test_run',
      'state': {},
      'messages': [
        {'id': 'm1', 'content': 'hello from app'}
      ],
      'tools': [],
      'context': [],
      'forwardedProps': {}
    };

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (Config.aguiApiKey != null) 'Authorization': 'Bearer ${Config.aguiApiKey}'
      },
      body: jsonEncode(payload),
    );

    // Print status and body for debugging purposes
    // ignore: avoid_print
    print('AG-UI test response: ${response.statusCode}');
    // ignore: avoid_print
    print(response.body);
  } catch (e, st) {
    // ignore: avoid_print
    print('AG-UI test failed: $e');
    // ignore: avoid_print
    print(st);
  }
}
