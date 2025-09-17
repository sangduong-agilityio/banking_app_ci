import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_app/app/router/app_router.dart';

class RouterGuard {
  static Future<String?> authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');

    final isLoggingIn =
        state.matchedLocation == BAPaths.signIn.path ||
        state.matchedLocation == BAPaths.signUp.path ||
        state.matchedLocation == BAPaths.landing.path;

    if (token == null && !isLoggingIn) {
      return BAPaths.signIn.path;
    }

    if (token != null && isLoggingIn) {
      return BAPaths.home.path;
    }

    return null;
  }
}
