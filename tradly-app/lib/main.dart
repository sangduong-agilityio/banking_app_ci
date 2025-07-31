import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tradly_app/app_provider.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/configs/app_router.dart';
import 'package:tradly_app/service/service_initializer.dart';
import 'package:tradly_app/themes/app_theme.dart';
import 'package:tradly_app/utils/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeServices();

  await AppLocator.setup();

  runApp(const TradlyShopApp());
}

class TradlyShopApp extends StatefulWidget {
  const TradlyShopApp({super.key});

  @override
  State<TradlyShopApp> createState() => _TradlyShopAppState();
}

class _TradlyShopAppState extends State<TradlyShopApp> {
  @override
  Widget build(BuildContext context) {
    return TAProvider(
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
        builder: (context, child) => AccessibilityTools(
          minimumTapAreas: MinimumTapAreas.material,
          checkSemanticLabels: false,
          checkFontOverflows: true,
          checkImageLabels: true,
          logLevel: LogLevel.verbose,
          buttonsAlignment: ButtonsAlignment.bottomRight,
          enableButtonsDrag: false,
          testingToolsConfiguration: TestingToolsConfiguration(
            enabled: true,
            minTextScale: 1.0,
            maxTextScale: 2,
          ),
          child: ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 768, name: MOBILE),
              const Breakpoint(start: 769, end: 1024, name: TABLET),
            ],
          ),
        ),
        routeInformationProvider: TARouter.router.routeInformationProvider,
        routeInformationParser: TARouter.router.routeInformationParser,
        routerDelegate: TARouter.router.routerDelegate,
      ),
    );
  }
}
