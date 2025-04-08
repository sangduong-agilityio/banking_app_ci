import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/core/routes/app_router.dart';

class RouterGuard {
  static Future<String?> authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final restrictedScreens = [
      state.namedLocation(TAPaths.home.name),
    ];
    final isRestricted = restrictedScreens.contains(state.matchedLocation);

    final userSession = await getUserSession();
    final isAuthorized = !isRestricted || (userSession?.sessionToken != null);

    return isAuthorized ? null : TAPaths.home.path;
  }

  static Future<UserSession?> getUserSession() async {
    return null;
  }
}

class UserSession {
  final String? sessionToken;

  UserSession({this.sessionToken});
}
