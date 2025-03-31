import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: Env.supabaseUrl,
  //   anonKey: Env.supabaseKey,
  // );

  runApp(const TradlyShopApp());
}

class TradlyShopApp extends StatefulWidget {
  const TradlyShopApp({super.key});

  @override
  State<TradlyShopApp> createState() => _TradlyShopAppState();
}

class _TradlyShopAppState extends State<TradlyShopApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      if ((FocusManager.instance.primaryFocus?.hasFocus ?? false) &&
          Platform.isAndroid) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: TaTheme.light,
      darkTheme: TaTheme.dark,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: [
        ...S.delegate.supportedLocales,
        const Locale('en', ''),
      ],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        ),
        breakpoints: [
          /// Mobile sizes (Pixel 4a, Galaxy S20, iPhones, most Android
          /// devices)
          const Breakpoint(
            start: 0,
            end: 768,
            name: MOBILE,
          ),

          /// Tablets (iPad, Galaxy Tab)
          const Breakpoint(
            start: 769,
            end: 1024,
            name: TABLET,
          ),
        ],
      ),
      routeInformationProvider: TARouter.router.routeInformationProvider,
      routeInformationParser: TARouter.router.routeInformationParser,
      routerDelegate: TARouter.router.routerDelegate,
    );
  }
}
