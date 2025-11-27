import 'package:banking_app/app/router/app_router.dart';
import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/data/services/platform_channel_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BankingApp extends StatefulWidget {
  const BankingApp({super.key});

  @override
  State<BankingApp> createState() => _BankingAppState();
}

class _BankingAppState extends State<BankingApp> with WidgetsBindingObserver {
  final PlatformChannelService _platformService = PlatformChannelService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAppShortcuts();
    _checkShortcutLaunch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App lifecycle changed: $state');
    if (state == AppLifecycleState.resumed) {
      _checkShortcutLaunch();
    }
  }

  Future<void> _setupAppShortcuts() async {
    try {
      await _platformService.addAppShortcuts([
        {'id': 'quick_transfer', 'label': 'Quick Transfer', 'icon': 'ic_send'},
        {'id': 'check_balance', 'label': 'Check Balance', 'icon': 'ic_account'},
      ]);
      debugPrint('[SHORTCUT] App shortcuts added');
    } catch (e) {
      debugPrint('[SHORTCUT] Failed to add shortcuts: $e');
    }
  }

  Future<void> _checkShortcutLaunch() async {
    // Wait a bit for the app to be fully initialized
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final action = await _platformService.getShortcutAction();
      if (action != null && mounted) {
        debugPrint('[SHORTCUT] Detected action: $action');
        // Add extra delay before navigation
        await Future.delayed(const Duration(milliseconds: 300));
        _handleShortcutAction(action);
      }
    } catch (e) {
      debugPrint('[SHORTCUT] Error checking shortcut: $e');
    }
  }

  void _handleShortcutAction(String action) {
    if (!mounted) return;

    debugPrint('[SHORTCUT] Handling action: $action');

    try {
      switch (action) {
        case 'quick_transfer':
          debugPrint('[SHORTCUT] Navigating to transfer');
          BAAppRouter.router.go('/home/transfer');
          break;
        case 'check_balance':
          debugPrint('[SHORTCUT] Navigating to account');
          BAAppRouter.router.go('/home/account');
          break;
        default:
          debugPrint('[SHORTCUT] Unknown action: $action');
      }
    } catch (e) {
      debugPrint('[SHORTCUT] Navigation error: $e');
    }
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
