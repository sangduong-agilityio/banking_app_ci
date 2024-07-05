import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/router/page_transition.dart';
import 'package:laza/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:laza/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:laza/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:laza/features/home/presentation/screens/home_sreen.dart';
import 'package:laza/features/let_started/presentation/screens/let_started_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutesName {
  static final homeScreen = RouteName('/home', 'home');
  static final startedScreen = RouteName('/startedScreen', 'startedScreen');
  static final signInScreen = RouteName('/signInScreen', 'signInScreen');
  static final signUpScreen = RouteName('/signUpScreen', 'signUpScreen');
  static final forgotPasswordScreen =
      RouteName('/forgotPasswordScreen', 'forgotPasswordScreen');
  static final productDetailScreen =
      RouteName('/productDetailPage', 'productDetailPage');
  static final brandDetailScreen =
      RouteName('/brandDetailScreen', 'brandDetailScreen');
}

class RouteName {
  RouteName(this.path, this.name);

  final String path;
  final String name;
}

class AppRouter {
  static final GoRouter routes = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoutesName.startedScreen.path,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutesName.startedScreen.path,
          name: AppRoutesName.startedScreen.name,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            context: context,
            state: state,
            child: const LetStartedScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutesName.signInScreen.path,
          name: AppRoutesName.signInScreen.name,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            transitionDuration: const Duration(milliseconds: 300),
            context: context,
            state: state,
            child: const SignInScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutesName.signUpScreen.path,
          name: AppRoutesName.signUpScreen.name,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            transitionDuration: const Duration(milliseconds: 300),
            context: context,
            state: state,
            child: const SignUpScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutesName.forgotPasswordScreen.path,
          name: AppRoutesName.forgotPasswordScreen.name,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            transitionDuration: const Duration(milliseconds: 300),
            context: context,
            state: state,
            child: const ForgotPasswordScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutesName.homeScreen.path,
          name: AppRoutesName.homeScreen.name,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            transitionDuration: const Duration(milliseconds: 300),
            context: context,
            state: state,
            child: const HomeScreen(),
          ),
        ),
      ]);
}
