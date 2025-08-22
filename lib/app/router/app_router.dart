// import 'package:banking_app/app/router/router_guard.dart';
import 'package:banking_app/core/widgets/layouts/bottom_navigation_bar.dart';
import 'package:banking_app/core/widgets/layouts/not_found.dart';
import 'package:banking_app/core/widgets/layouts/scaffold.dart';
import 'package:banking_app/features/auth/pages/sign_in_page.dart';
import 'package:banking_app/features/auth/pages/sign_up_page.dart';
import 'package:banking_app/features/dashboard/pages/home_page.dart';
import 'package:banking_app/features/landing/landing_page.dart';
import 'package:banking_app/features/landing/pages/message.dart';
import 'package:banking_app/features/landing/pages/search.dart';
import 'package:banking_app/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BAAppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: BAPaths.home.path,
    navigatorKey: rootNavigatorKey,
    routes: _getRoutes(),
    errorBuilder: (context, state) => const NotFoundScreen(),
    // redirect: (context, state) => RouterGuard.authGuard(context, state),
  );

  static List<RouteBase> _getRoutes() {
    return [
      GoRoute(
        path: BAPaths.landing.path,
        name: BAPaths.landing.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LandingSceen()),
      ),
      GoRoute(
        path: BAPaths.signIn.path,
        name: BAPaths.signIn.name,
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: SignInScreen()),
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
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: BAPaths.home.path,
                name: BAPaths.home.name,
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: BAPaths.search.path,
                name: BAPaths.search.name,
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: BAPaths.message.path,
                name: BAPaths.message.name,
                builder: (context, state) => const MessagePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            routes: [
              GoRoute(
                path: BAPaths.setting.path,
                name: BAPaths.setting.name,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ];
  }
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
