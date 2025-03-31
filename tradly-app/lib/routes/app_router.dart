import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/routes/router_guard.dart';
import 'package:tradly_app/screens/auth/otp_verification_screen.dart';
import 'package:tradly_app/screens/auth/send_otp_screen.dart';
import 'package:tradly_app/screens/auth/sign_in_screen.dart';
import 'package:tradly_app/screens/auth/sign_up_screen.dart';
import 'package:tradly_app/screens/home/home_screen.dart';
import 'package:tradly_app/screens/on_boarding/on_boarding_screen.dart';
import 'package:tradly_app/widgets/not_found.dart';

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
    ];
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
