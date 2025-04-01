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

  /// `Don't have an account? Sign up`
  String get signInSignUpPrompt {
    return Intl.message(
      'Don\'t have an account? Sign up',
      name: 'signInSignUpPrompt',
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
