import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BankingApp extends StatefulWidget {
  const BankingApp({super.key});

  @override
  State<BankingApp> createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App lifecycle changed: $state');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: BATheme.lightTheme,
      darkTheme: BATheme.darkTheme,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [S.delegate],
      supportedLocales: [
        ...S.delegate.supportedLocales,
        const Locale('en', ''),
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 768, name: MOBILE),
          Breakpoint(start: 769, end: 1024, name: TABLET),
          Breakpoint(start: 1025, end: double.infinity, name: DESKTOP),
        ],
      ),
      routeInformationProvider: BAAppRouter.router.routeInformationProvider,
      routeInformationParser: BAAppRouter.router.routeInformationParser,
      routerDelegate: BAAppRouter.router.routerDelegate,
    );
  }
}
