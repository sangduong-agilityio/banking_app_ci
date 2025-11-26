import 'package:banking_app/app/router/router_guard.dart';
import 'package:banking_app/core/observers/debug_navigation_observer.dart';
import 'package:banking_app/core/widgets/layouts/bottom_navigation_bar.dart';
import 'package:banking_app/core/widgets/layouts/not_found.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/account/presentation/views/account_and_card_screen.dart';
import 'package:banking_app/features/auth/presentation/views/sign_in_screen.dart';
import 'package:banking_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:banking_app/features/bill_payment/presentation/views/bill_payment_screen.dart';
import 'package:banking_app/features/home/presentation/views/home_screen.dart';
import 'package:banking_app/features/message/message_screen.dart';
import 'package:banking_app/features/search/presentation/views/exchange_rate_screen.dart';
import 'package:banking_app/features/search/presentation/views/exchange_screen.dart';
import 'package:banking_app/features/search/presentation/views/interest_rate_screen.dart';
import 'package:banking_app/features/search/presentation/views/search_screen.dart';
import 'package:banking_app/features/setting/presentation/views/setting_screen.dart';
import 'package:banking_app/features/setting/presentation/widgets/platform_channel_demo.dart';
import 'package:banking_app/features/transactions/presentation/views/graphql_transaction_demo_screen.dart';
import 'package:banking_app/features/transactions/presentation/views/transaction_report_screen.dart';
import 'package:banking_app/features/transfer/presentation/views/transfer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BAAppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();
  static final searchNavigatorKey = GlobalKey<NavigatorState>();
  static final messageNavigatorKey = GlobalKey<NavigatorState>();
  static final settingNavigatorKey = GlobalKey<NavigatorState>();

  static final _debugObserver = DebugNavigationObserver();

  static final router = GoRouter(
    initialLocation: BAPaths.signIn.path,
    navigatorKey: rootNavigatorKey,
    observers: kDebugMode ? [_debugObserver] : [],
    routes: [
      GoRoute(
        path: BAPaths.signIn.path,
        name: BAPaths.signIn.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignInScreen()),
      ),
      GoRoute(
        path: BAPaths.signUp.path,
        name: BAPaths.signUp.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignUpScreen()),
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return BAScaffold(
            body: navigationShell,
            bottomNavigationBar: BABottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) =>
                  navigationShell.goBranch(index, initialLocation: true),
              items: bottomNavigationBarItems(context),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: BAPaths.home.path,
                name: BAPaths.home.name,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: BAPaths.account.path,
                    name: BAPaths.account.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const AccountAndCardScreen(),
                  ),
                  GoRoute(
                    path: BAPaths.transfer.path,
                    name: BAPaths.transfer.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const TransferScreen(),
                  ),
                  GoRoute(
                    path: BAPaths.payBill.path,
                    name: BAPaths.payBill.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const BillPaymentScreen(),
                  ),
                  GoRoute(
                    path: BAPaths.transactionReport.path,
                    name: BAPaths.transactionReport.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) {
                      return GraphQLTransactionDemoScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: searchNavigatorKey,
            routes: [
              GoRoute(
                path: BAPaths.search.path,
                name: BAPaths.search.name,
                builder: (context, state) => const SearchScreen(),
                routes: [
                  GoRoute(
                    path: BAPaths.interestRate.path,
                    name: BAPaths.interestRate.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const InterestRateScreen(),
                  ),
                  GoRoute(
                    path: BAPaths.exchangeRate.path,
                    name: BAPaths.exchangeRate.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const ExchangeRateScreen(),
                  ),
                  GoRoute(
                    path: BAPaths.exchange.path,
                    name: BAPaths.exchange.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const ExchangeScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: messageNavigatorKey,
            routes: [
              GoRoute(
                path: BAPaths.message.path,
                name: BAPaths.message.name,
                builder: (context, state) => const MessageScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingNavigatorKey,
            routes: [
              GoRoute(
                path: BAPaths.setting.path,
                name: BAPaths.setting.name,
                builder: (context, state) => const SettingScreen(),
                routes: [
                  GoRoute(
                    path: BAPaths.platformChannelDemo.path,
                    name: BAPaths.platformChannelDemo.name,
                    parentNavigatorKey: BAAppRouter.rootNavigatorKey,
                    builder: (context, state) => const PlatformChannelDemo(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // Log redirect events
      if (kDebugMode) {
        debugPrint('[NAV] REDIRECT: ${state.matchedLocation}');
      }
      return RouterGuard.authGuard(context, state);
    },
    errorBuilder: (context, state) {
      // Log errors
      if (kDebugMode) {
        debugPrint('[NAV]ERROR: ${state.error} at ${state.matchedLocation}');
      }
      return const NotFoundScreen();
    },
  );
}

enum BAPaths {
  signIn(name: 'signIn', path: '/signin'),
  signUp(name: 'signUp', path: '/signup'),
  home(name: 'home', path: '/home'),
  account(name: 'account', path: '/account'),
  transfer(name: 'transfer', path: '/transfer'),
  payBill(name: 'payBill', path: '/payBill'),
  transactionReport(name: 'transactionReport', path: '/transactionReport'),
  search(name: 'search', path: '/search'),
  interestRate(name: 'interestRate', path: '/interestRate'),
  exchangeRate(name: 'exchangeRate', path: '/exchangeRate'),
  exchange(name: 'exchange', path: '/exchange'),
  message(name: 'message', path: '/message'),
  setting(name: 'setting', path: '/setting'),
  platformChannelDemo(name: 'platformChannelDemo', path: '/platformChannelDemo');

  const BAPaths({required this.name, required this.path});
  final String name;
  final String path;
}
