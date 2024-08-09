import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:laza/core/extensions/context_extensions.dart';
import 'package:laza/core/gen_assets/assets.gen.dart';
import 'package:laza/core/router/page_transition.dart';
import 'package:laza/data/models/brand_model.dart';
import 'package:laza/data/models/product_model.dart';
import 'package:laza/presentations/layout/bottom_navigation_bar.dart';
import 'package:laza/presentations/pages/auth/forgot_password.dart';
import 'package:laza/presentations/pages/auth/reset_password.dart';
import 'package:laza/presentations/pages/auth/sign_in.dart';
import 'package:laza/presentations/pages/auth/sign_up.dart';
import 'package:laza/presentations/pages/brand_detail/brand_detail.dart';
import 'package:laza/presentations/pages/brand_detail/brand_view.dart';
import 'package:laza/presentations/pages/cart/cart_product.dart';
import 'package:laza/presentations/pages/home/home.dart';
import 'package:laza/presentations/pages/let_started/let_started.dart';
import 'package:laza/presentations/pages/product/list_all_product.dart';
import 'package:laza/presentations/pages/product/product_detail.dart';
import 'package:laza/presentations/pages/wishList/wish_list.dart';
import 'package:laza/presentations/widgets/drawer_menu.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutesName {
  static final homePage = RouteName('/homePage', 'homePage');
  static final wishListPage = RouteName('/wishListPage', 'wishListPage');
  static final cartProductPage =
      RouteName('/cartProductPage', 'cartProductPage');
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
  static final drawerMenu = RouteName('/drawerMenu', 'drawerMenu');
  static final allListProduct = RouteName('/allListProduct', 'allListProduct');
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
          child: BrandDetailPage(
            brand: state.extra as Brand,
          ),
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
          child: ProductDetailPage(
            product: state.extra as Product,
          ),
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
      GoRoute(
        path: AppRoutesName.drawerMenu.path,
        name: AppRoutesName.drawerMenu.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          context: context,
          state: state,
          child: const LSDrawerMenu(),
        ),
      ),
      GoRoute(
        path: AppRoutesName.allListProduct.path,
        name: AppRoutesName.allListProduct.name,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => PageTransaction.defaultPageTransition(
          transitionDuration: const Duration(milliseconds: 300),
          context: context,
          state: state,
          child: const ListAllProduct(),
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
            child: HomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.wishListPage.path,
          name: AppRoutesName.wishListPage.name,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            context: context,
            state: state,
            child: const WishListPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutesName.cartProductPage.path,
          name: AppRoutesName.cartProductPage.name,
          pageBuilder: (context, state) =>
              PageTransaction.defaultPageTransition(
            context: context,
            state: state,
            child: const CartProductPage(),
          ),
        ),
      ],
    )
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
        height: 25,
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
