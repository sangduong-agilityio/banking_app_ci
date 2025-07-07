import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/features/product_detail/repositories/product_repo.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/themes/app_theme.dart';
import 'package:tradly_app/firebase_options.dart';
import 'package:tradly_app/utils/locator.dart';
import 'package:tradly_app/features/product_detail/states/product_detail_bloc.dart';
import 'package:tradly_app/features/order_history/states/order_history_bloc.dart';
import 'package:tradly_app/features/wish_list/states/wish_list_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLocators.setupLocators();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseKey,
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
          create: (_) => ProductDetailBloc(
            repo: locator.get<ProductRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => OrderHistoryBloc(),
        ),
        BlocProvider(
          create: (_) => WishListCubit(),
        ),
      ],
      child: MaterialApp.router(
        theme: TATheme.light,
        darkTheme: TATheme.dark,
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
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 768, name: MOBILE),
            const Breakpoint(start: 769, end: 1024, name: TABLET),
          ],
        ),
        routeInformationProvider: TARouter.router.routeInformationProvider,
        routeInformationParser: TARouter.router.routeInformationParser,
        routerDelegate: TARouter.router.routerDelegate,
      ),
    );
  }
}
