import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/dependency_injection/service_locator.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);

  // Setup service locators
  await AppLocators.setupLocators();

  // Wait until all async singletons are ready
  await locator.allReady();

  // Setup intl date formatting
  await initializeDateFormatting('en_US', null);

  runApp(const BankingApp());
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
