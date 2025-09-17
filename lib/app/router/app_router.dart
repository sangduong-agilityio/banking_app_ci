import 'package:banking_app/app/router/router_guard.dart';
import 'package:banking_app/core/widgets/layouts/bottom_navigation_bar.dart';
import 'package:banking_app/core/widgets/layouts/not_found.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/views/sign_in_screen.dart';
import 'package:banking_app/features/auth/views/sign_up_screen.dart';
import 'package:banking_app/features/home/views/home_screen.dart';
import 'package:banking_app/features/landing/landing_screen.dart';
import 'package:banking_app/features/message/message_screen.dart';
import 'package:banking_app/features/search/views/search_screen.dart';
import 'package:banking_app/features/setting/views/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BAAppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();
  static final searchNavigatorKey = GlobalKey<NavigatorState>();
  static final messageNavigatorKey = GlobalKey<NavigatorState>();
  static final settingNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: BAPaths.landing.path,
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: BAPaths.landing.path,
        name: BAPaths.landing.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LandingScreen()),
      ),
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
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: BAPaths.home.path,
                name: BAPaths.home.name,
                builder: (context, state) => const HomeScreen(),
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
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) => RouterGuard.authGuard(context, state),
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

enum BAPaths {
  landing(name: 'landing', path: '/landing'),
  signIn(name: 'signIn', path: '/signin'),
  signUp(name: 'signUp', path: '/signup'),
  home(name: 'home', path: '/home'),
  search(name: 'search', path: '/search'),
  message(name: 'message', path: '/message'),
  setting(name: 'setting', path: '/setting');

  const BAPaths({required this.name, required this.path});
  final String name;
  final String path;
}
