import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/constant/constants.dart';
import 'package:laza/core/l10n/l10n_generated/l10n.dart';
import 'package:laza/core/router/routes.dart';
import 'package:laza/core/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseKey,
  );
  runApp(const ProviderScope(child: LazaShopApp()));
}

class LazaShopApp extends StatelessWidget {
  const LazaShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: [
        ...S.delegate.supportedLocales,
        const Locale('en', ''),
      ],
      routeInformationProvider: AppRouter.routes.routeInformationProvider,
      routeInformationParser: AppRouter.routes.routeInformationParser,
      routerDelegate: AppRouter.routes.routerDelegate,
    );
  }
}
