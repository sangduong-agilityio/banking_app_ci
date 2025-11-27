import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// NavigatorObserver để log navigation events ra Debug Console
/// Sử dụng debugPrint để tích hợp tốt với Flutter DevTools
class DebugNavigationObserver extends NavigatorObserver {
  final bool enableLogging;

  DebugNavigationObserver({this.enableLogging = kDebugMode});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (enableLogging && kDebugMode) {
      final routeName = route.settings.name ?? 'unknown';
      final previousName = previousRoute?.settings.name ?? 'none';
      debugPrint('[NAV] PUSH: $routeName (from: $previousName)');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (enableLogging && kDebugMode) {
      final routeName = route.settings.name ?? 'unknown';
      final previousName = previousRoute?.settings.name ?? 'none';
      debugPrint('[NAV] POP: $routeName (back to: $previousName)');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (enableLogging && kDebugMode) {
      final newRouteName = newRoute?.settings.name ?? 'unknown';
      final oldRouteName = oldRoute?.settings.name ?? 'unknown';
      debugPrint('[NAV] REPLACE: $oldRouteName → $newRouteName');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);

    if (enableLogging && kDebugMode) {
      final routeName = route.settings.name ?? 'unknown';
      debugPrint('[NAV] REMOVE: $routeName');
    }
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);

    if (enableLogging && kDebugMode) {
      debugPrint('[NAV] User gesture started');
    }
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();

    if (enableLogging && kDebugMode) {
      debugPrint('[NAV] User gesture stopped');
    }
  }
}
