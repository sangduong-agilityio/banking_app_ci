import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/core/routes/router_guard.dart';
import 'package:tradly_app/presentations/pages/auth/otp_verification_screen.dart';
import 'package:tradly_app/presentations/pages/auth/send_otp_screen.dart';
import 'package:tradly_app/presentations/pages/auth/sign_in_screen.dart';
import 'package:tradly_app/presentations/pages/auth/sign_up_screen.dart';
import 'package:tradly_app/presentations/pages/home/home_screen.dart';
import 'package:tradly_app/presentations/pages/on_boarding/on_boarding_screen.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/beverages_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/bread_bakery_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/egg_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/frozen_veg_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/fruit_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/home_care_list.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/pet_care.dart';
import 'package:tradly_app/presentations/pages/product_detail/views/vegetables_list.dart';
import 'package:tradly_app/presentations/widgets/not_found.dart';

class TARouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: TAPaths.home.path,
    navigatorKey: rootNavigatorKey,
    routes: _getRoutes(),
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) => RouterGuard.authGuard(context, state),
  );

  static List<GoRoute> _getRoutes() {
    return [
      GoRoute(
        name: TAPaths.onboarding.name,
        path: TAPaths.onboarding.path,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        name: TAPaths.signIn.name,
        path: TAPaths.signIn.path,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        name: TAPaths.signUp.name,
        path: TAPaths.signUp.path,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: TAPaths.sendOTP.name,
        path: TAPaths.sendOTP.path,
        builder: (context, state) => const SendOtpScreen(),
      ),
      GoRoute(
        name: TAPaths.otpVerification.name,
        path: TAPaths.otpVerification.path,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        name: TAPaths.home.name,
        path: TAPaths.home.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: TAPaths.beverages.name,
        path: TAPaths.beverages.path,
        builder: (context, state) => const BeveragesList(),
      ),
      GoRoute(
        name: TAPaths.vegetables.name,
        path: TAPaths.vegetables.path,
        builder: (context, state) => const VegetablesList(),
      ),
      GoRoute(
        name: TAPaths.breadBakely.name,
        path: TAPaths.breadBakely.path,
        builder: (context, state) => const BreadBakeryList(),
      ),
      GoRoute(
        name: TAPaths.egg.name,
        path: TAPaths.egg.path,
        builder: (context, state) => const EggList(),
      ),
      GoRoute(
        name: TAPaths.fruit.name,
        path: TAPaths.fruit.path,
        builder: (context, state) => const FruitList(),
      ),
      GoRoute(
        name: TAPaths.homeCare.name,
        path: TAPaths.homeCare.path,
        builder: (context, state) => const HomeCareList(),
      ),
      GoRoute(
        name: TAPaths.frozenVeg.name,
        path: TAPaths.frozenVeg.path,
        builder: (context, state) => const FrozenVegList(),
      ),
      GoRoute(
        name: TAPaths.petCare.name,
        path: TAPaths.petCare.path,
        builder: (context, state) => const PetCareList(),
      ),
    ];
  }

  static void navigateToCategory(BuildContext context, String routeName,
      {Map<String, String>? queryParams}) {
    context.pushNamed(routeName,
        queryParameters: queryParams ?? <String, dynamic>{});
  }
}

enum TAPaths {
  onboarding(
    name: 'onboarding',
    path: '/',
  ),
  signIn(
    name: 'signIn',
    path: '/signIn',
  ),
  signUp(
    name: 'signUp',
    path: '/signUp',
  ),
  sendOTP(
    name: 'sendOTP',
    path: '/sendOTP',
  ),
  otpVerification(
    name: 'otpVerification',
    path: '/otpVerification',
  ),
  home(
    name: 'home',
    path: '/home',
  ),
  beverages(
    name: 'beverages',
    path: '/beverages',
  ),
  vegetables(
    name: 'vegetables',
    path: '/vegetables',
  ),
  breadBakely(
    name: 'breadBakely',
    path: '/breadBakely',
  ),
  frozenVeg(
    name: 'frozenVeg',
    path: '/frozenVeg',
  ),
  egg(
    name: 'egg',
    path: '/egg',
  ),
  fruit(
    name: 'fruit',
    path: '/fruit',
  ),
  homeCare(
    name: 'homeCare',
    path: '/homeCare',
  ),
  petCare(
    name: 'petCare',
    path: '/petCare',
  );

  const TAPaths({
    required this.name,
    required this.path,
  });

  final String name;

  final String path;

  @override
  String toString() => name;
}
