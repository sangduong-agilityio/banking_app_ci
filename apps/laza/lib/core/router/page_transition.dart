import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageTransaction {
  static CustomTransitionPage defaultPageTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    bool animationLeftToRight = false,
    Duration? transitionDuration,
  }) {
    return CustomTransitionPage<void>(
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 200),
      key: state.pageKey,
      barrierDismissible: true,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildSlideTransition(
          animation: animation,
          child: child,
          animationLeftToRight: animationLeftToRight,
        );
      },
    );
  }

  static CustomTransitionPage slideUpPageTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      transitionDuration: const Duration(milliseconds: 200),
      key: state.pageKey,
      barrierDismissible: true,
      child: child,
      transitionsBuilder: (c, animation, a2, child) => FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
        child: child,
      ),
    );
  }

  static Widget _buildSlideTransition({
    required Animation<double> animation,
    required Widget child,
    bool animationLeftToRight = false,
  }) =>
      SlideTransition(
        position: Tween<Offset>(
          begin:
              animationLeftToRight ? const Offset(-1, 0) : const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}
