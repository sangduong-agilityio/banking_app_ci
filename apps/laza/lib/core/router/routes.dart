import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extenssions/context_extenssions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/router/page_transition.dart';
import 'package:laza/core/widgets/bottom_navigation_bar.dart';
import 'package:laza/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:laza/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:laza/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:laza/features/brand_detail/presentation/screens/brand_detail_screen.dart';
import 'package:laza/features/home/presentation/screens/home_sreen.dart';
import 'package:laza/features/let_started/presentation/screens/let_started_screen.dart';
import 'package:laza/features/product_detail/presentation/screens/product_detail_screen.dart';

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
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          context: context,
          state: state,
          child: const LetStartedScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.signInScreen.path,
        name: AppRoutesName.signInScreen.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
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
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
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
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.brandDetailScreen.path,
        name: AppRoutesName.brandDetailScreen.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const BrandDetailScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.productDetailScreen.path,
        name: AppRoutesName.productDetailScreen.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const ProductDetailScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state, navigationShell) => Scaffold(
          backgroundColor: context.colorScheme.background,
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
          path: AppRoutesName.homeScreen.path,
          name: AppRoutesName.homeScreen.name,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            context: context,
            state: state,
            child: const HomeScreen(),
          ),
        ),
      ],
    ),
  ];
}

List<LSBottomNavigationBarItem> bottomNavigationBarItems(BuildContext context) {
  return <LSBottomNavigationBarItem>[
    /// Home
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

    /// Search
    LSBottomNavigationBarItem(
      icon: SvgPicture.asset(
        Assets.icons.icHeart.path,
        height: 25,
      ),
      activeIcon: SvgPicture.asset(
        Assets.icons.icHeart.path,
        colorFilter:
            ColorFilter.mode(context.colorScheme.primary, BlendMode.srcIn),
      ),
    ),

    /// Save
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

    /// Profile
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
