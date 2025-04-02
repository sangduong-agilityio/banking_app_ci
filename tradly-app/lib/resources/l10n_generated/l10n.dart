// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Empowering Artisans, Farmers & Micro Business`
  String get onBoardingBusinessDescription {
    return Intl.message(
      'Empowering Artisans, Farmers & Micro Business',
      name: 'onBoardingBusinessDescription',
      desc: '',
      args: [],
    );
  }

  /// `Connecting NGOs, Social Enterprises with Communities`
  String get onBoardingSocialDescription {
    return Intl.message(
      'Connecting NGOs, Social Enterprises with Communities',
      name: 'onBoardingSocialDescription',
      desc: '',
      args: [],
    );
  }

  /// ` Donate, Invest & Support infrastructure projects`
  String get onBoardingsupportDescription {
    return Intl.message(
      ' Donate, Invest & Support infrastructure projects',
      name: 'onBoardingsupportDescription',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get onBoardingNextButton {
    return Intl.message(
      'Next',
      name: 'onBoardingNextButton',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get onBoardingFinishButton {
    return Intl.message(
      'Finish',
      name: 'onBoardingFinishButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to tradly`
  String get signInWelcomeTitle {
    return Intl.message(
      'Welcome to tradly',
      name: 'signInWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get signInLoginPrompt {
    return Intl.message(
      'Login to your account',
      name: 'signInLoginPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Email/Mobile Number`
  String get signInEmailOrMobileLabel {
    return Intl.message(
      'Email/Mobile Number',
      name: 'signInEmailOrMobileLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get signInPasswordLabel {
    return Intl.message(
      'Password',
      name: 'signInPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get signInLoginButton {
    return Intl.message(
      'Login',
      name: 'signInLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get signInForgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'signInForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get signInSignUpPrompt {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'signInSignUpPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUpButton {
    return Intl.message(
      'Sign up',
      name: 'signUpButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to tradly`
  String get signUpWelcomeTitle {
    return Intl.message(
      'Welcome to tradly',
      name: 'signUpWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Signup to your account`
  String get signUpTitle {
    return Intl.message(
      'Signup to your account',
      name: 'signUpTitle',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get signUpFirstNameLabel {
    return Intl.message(
      'First Name',
      name: 'signUpFirstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get signUpLastNameLabel {
    return Intl.message(
      'Last Name',
      name: 'signUpLastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email ID/Phone Number`
  String get signUpEmailOrPhoneNumberLabel {
    return Intl.message(
      'Email ID/Phone Number',
      name: 'signUpEmailOrPhoneNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get signUpPasswordLabel {
    return Intl.message(
      'Password',
      name: 'signUpPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter Password`
  String get signUpReEnterPasswordLabel {
    return Intl.message(
      'Re-enter Password',
      name: 'signUpReEnterPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get signUpCreateButton {
    return Intl.message(
      'Create',
      name: 'signUpCreateButton',
      desc: '',
      args: [],
    );
  }

  /// `Have an account? `
  String get signUpAlreadyAcccount {
    return Intl.message(
      'Have an account? ',
      name: 'signUpAlreadyAcccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signInButton {
    return Intl.message(
      'Sign in',
      name: 'signInButton',
      desc: '',
      args: [],
    );
  }

  /// `Verify your phone number`
  String get sendOtpTitle {
    return Intl.message(
      'Verify your phone number',
      name: 'sendOtpTitle',
      desc: '',
      args: [],
    );
  }

  /// `We have sent you an SMS with a code to enter number`
  String get sendOtpDescription {
    return Intl.message(
      'We have sent you an SMS with a code to enter number',
      name: 'sendOtpDescription',
      desc: '',
      args: [],
    );
  }

  /// `Or login with Social network`
  String get sendOtpLoginSocialNetWorkTitle {
    return Intl.message(
      'Or login with Social network',
      name: 'sendOtpLoginSocialNetWorkTitle',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get sendOtpNextButton {
    return Intl.message(
      'Next',
      name: 'sendOtpNextButton',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get sendOtpPhoneNumberTitle {
    return Intl.message(
      'Phone Number',
      name: 'sendOtpPhoneNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone Verification`
  String get otpVerificationTitle {
    return Intl.message(
      'Phone Verification',
      name: 'otpVerificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your OTP code here`
  String get otpVerificationDescription {
    return Intl.message(
      'Enter your OTP code here',
      name: 'otpVerificationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Didn’t you received any code?`
  String get otpVerificationReceivedCodeTitle {
    return Intl.message(
      'Didn’t you received any code?',
      name: 'otpVerificationReceivedCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Resent new code`
  String get otpVerificationResentCodeTitle {
    return Intl.message(
      'Resent new code',
      name: 'otpVerificationResentCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get otpVerificationButton {
    return Intl.message(
      'Verify',
      name: 'otpVerificationButton',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
