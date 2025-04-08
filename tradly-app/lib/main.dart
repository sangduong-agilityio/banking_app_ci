import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tradly_app/environments/env.dart';
import 'package:tradly_app/data/repositories/auth_repo.dart';
import 'package:tradly_app/core/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/core/routes/app_router.dart';
import 'package:tradly_app/presentations/pages/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/core/themes/app_theme.dart';
import 'package:tradly_app/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rcfffgbdtvmpzrodsyzm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJjZmZmZ2JkdHZtcHpyb2RzeXptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2NDMzNTksImV4cCI6MjA1OTIxOTM1OX0.qrP9QiXbT3KMlTbniOj9rBc8OHAkvxseI3H6hCqgYlE',
  );

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(
            authRepository: AuthRepositoryImplement(Supabase.instance.client),
          ),
        ),
        // Add other BLoCs here if needed
      ],
      child: TAProvider(
        child: MaterialApp.router(
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
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
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
        ),
      ),
    );
  }
}
