import 'dart:ui';
import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/security/error_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  /// Ensure that plugin services are initialized
  SentryWidgetsFlutterBinding.ensureInitialized();

  // Initialize Sentry for error tracking
  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;

    options.environment = Env.sentryEnv;

    options.tracesSampleRate = 1.0;

    options.debug = Env.sentryEnv != 'production';

    options.beforeSend = (event, hint) {
      if (Env.sentryEnv == 'development') {
        final msg = event.message?.formatted ?? '';
        if (msg.contains('Hot reload')) return null;
      }
      return event;
    };
  }, appRunner: _runApp);
}

/// The main application runner
Future<void> _runApp() async {
  // Set up global error handlers
  _setupGlobalErrorHandlers();

  // Initialize Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

  // Configure dependency injection
  await AppLocators.setupLocators();

  // Ensure all singletons are ready
  await locator.allReady();

  // Initialize date formatting for localization
  await initializeDateFormatting('en_US');

  runApp(const BankingApp());
}

/// Sets up global error handlers for Flutter and Dart errors
void _setupGlobalErrorHandlers() {
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

  /// Catches errors outside the Flutter framework
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

class BankingApp extends StatefulWidget {
  const BankingApp({super.key});

  @override
  State<BankingApp> createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: BATheme.lightTheme,
      darkTheme: BATheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [S.delegate],
      supportedLocales: [
        ...S.delegate.supportedLocales,
        const Locale('en', ''),
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 768, name: MOBILE),
          const Breakpoint(start: 769, end: 1024, name: TABLET),
        ],
      ),
      routeInformationProvider: BAAppRouter.router.routeInformationProvider,
      routeInformationParser: BAAppRouter.router.routeInformationParser,
      routerDelegate: BAAppRouter.router.routerDelegate,
    );
  }
}
