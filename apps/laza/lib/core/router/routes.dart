import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/page_transition.dart';
import 'package:laza/features/let_started/screen/let_started_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutesName {
  static final startedPage = RouteName('/startedPage', 'startedPage');
  static final signInPage = RouteName('/signInPage', 'signInPage');
  static final signUpPage = RouteName('/signUpPage', 'signUpPage');
  static final forgotPasswordPage =
      RouteName('/forgotPasswordPage', 'forgotPasswordPage');
  static final homePage = RouteName('/homePage', 'homePage');
  static final productDetailPage =
      RouteName('/productDetailPage', 'productDetailPage');
  static final brandDetailPage =
      RouteName('/brandDetailPage', 'brandDetailPage');
}

class RouteName {
  RouteName(this.path, this.name);

  final String path;
  final String name;
}

class AppRouter {
  static final GoRouter routes =
      GoRouter(navigatorKey: rootNavigatorKey, routes: <RouteBase>[
    GoRoute(
      path: AppRoutesName.startedPage.path,
      name: AppRoutesName.startedPage.name,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
        context: context,
        state: state,
        child: const LetStartedPage(),
      ),
    ),
  ]);
}
