import 'package:banking_app/app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterGuard {
  static Future<String?> authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');
    final isLoggedIn = sessionToken != null;

    // Public routes that don't require authentication
    final publicRoutes = [
      BAPaths.landing.path,
      BAPaths.signIn.path,
      BAPaths.signUp.path,
    ];

    final currentPath = state.uri.toString();

    // If logged in and trying to access landing/signin, redirect to home
    if (isLoggedIn &&
        (currentPath == BAPaths.landing.path ||
            currentPath == BAPaths.signIn.path)) {
      return BAPaths.home.path;
    }

    // If not logged in and trying to access protected route, redirect to landing
    if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
      return BAPaths.home.path;
    }

    return null;
  }
}
