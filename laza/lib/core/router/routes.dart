import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/router/page_transition.dart';
import 'package:laza/presentations/pages/auth/forgot_password.dart';
import 'package:laza/presentations/pages/auth/password_reset.dart';
import 'package:laza/presentations/pages/auth/sign_in.dart';
import 'package:laza/presentations/pages/auth/sign_up.dart';
import 'package:laza/presentations/pages/brand_detail/brand_detail.dart';
import 'package:laza/presentations/pages/brand_detail/brand_view.dart';
import 'package:laza/presentations/pages/home/home.dart';
import 'package:laza/presentations/pages/let_started/let_started.dart';
import 'package:laza/presentations/pages/product_detail/product_detail.dart';
import 'package:laza/presentations/layout/bottom_navigation_bar.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutesName {
  static final homePage = RouteName('/homePage', 'homePage');
  static final startedPage = RouteName('/startedPage', 'startedPage');
  static final signInPage = RouteName('/signInPage', 'signInPage');
  static final signUpPage = RouteName('/signUpPage', 'signUpPage');
  static final forgotPasswordPage =
      RouteName('/forgotPasswordPage', 'forgotPasswordPage');
  static final resetPasswordPage =
      RouteName('/resetPasswordPage', 'resetPasswordPage');
  static final productDetailPage =
      RouteName('/productDetailPage', 'productDetailPage');
  static final brandDetailPage =
      RouteName('/brandDetailPage', 'brandDetailPage');
  static final brandViewAll = RouteName('/brandViewAll', 'brandViewAll');
}

class RouteName {
  RouteName(this.path, this.name);

  final String path;
  final String name;
}

class AppRouter {
  static final GoRouter routes = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: AppRoutesName.startedPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          context: context,
          state: state,
          child: const LetStartedPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.signInPage.path,
        name: AppRoutesName.signInPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const SignInPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.signUpPage.path,
        name: AppRoutesName.signUpPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const SignUpPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.forgotPasswordPage.path,
        name: AppRoutesName.forgotPasswordPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.brandDetailPage.path,
        name: AppRoutesName.brandDetailPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const BrandDetailPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.productDetailPage.path,
        name: AppRoutesName.productDetailPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const ProductDetailPage(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.brandViewAll.path,
        name: AppRoutesName.brandViewAll.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const BrandViewAll(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.resetPasswordPage.path,
        name: AppRoutesName.resetPasswordPage.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const PasswordResetPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, navigationShell) => Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: navigationShell,
          bottomNavigationBar: LSBottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            items: bottomNavigationBarItems(context),
          ),
        ),
        branches: bottomNavigationBarBranches(),
      ),
    ],
  );
}

List<StatefulShellBranch> bottomNavigationBarBranches() {
  return <StatefulShellBranch>[
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.homePage.path,
          name: AppRoutesName.homePage.name,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            context: context,
            state: state,
            child: const HomePage(),
          ),
        ),
      ],
    ),
  ];
}

List<LSBottomNavigationBarItem> bottomNavigationBarItems(BuildContext context) {
  return <LSBottomNavigationBarItem>[
    LSBottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.icons.icHome.path,
      ),
      activeIcon: SvgPicture.asset(
        Assets.icons.icHome.path,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      ),
    ),
    LSBottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.icons.icHeartBreak.path,
        height: 25,
      ),
      activeIcon: SvgPicture.asset(
        Assets.icons.icHeartBreak.path,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      ),
    ),
    LSBottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.icons.icBag.path,
        colorFilter: ColorFilter.mode(
          context.colorScheme.tertiaryContainer,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        Assets.icons.icBag.path,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      ),
    ),
    LSBottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.icons.icWallet.path,
        colorFilter: ColorFilter.mode(
          context.colorScheme.tertiaryContainer,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: SvgPicture.asset(
        Assets.icons.icWallet.path,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      ),
    ),
  ];
}
