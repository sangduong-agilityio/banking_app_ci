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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get homeTitle {
    return Intl.message('Home', name: 'homeTitle', desc: '', args: []);
  }

  /// `Search`
  String get searchTitle {
    return Intl.message('Search', name: 'searchTitle', desc: '', args: []);
  }

  /// `Message`
  String get messageTitle {
    return Intl.message('Message', name: 'messageTitle', desc: '', args: []);
  }

  /// `Setting`
  String get settingTitle {
    return Intl.message('Setting', name: 'settingTitle', desc: '', args: []);
  }

  /// `Email is required`
  String get validatorEmailRequired {
    return Intl.message(
      'Email is required',
      name: 'validatorEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is invalid format`
  String get validatorEmailWrongFormat {
    return Intl.message(
      'Email is invalid format',
      name: 'validatorEmailWrongFormat',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get validatorNameRequired {
    return Intl.message(
      'Name is required',
      name: 'validatorNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Name 6-character minimum`
  String get validatorNameCharacterMinimum {
    return Intl.message(
      'Name 6-character minimum',
      name: 'validatorNameCharacterMinimum',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get validatorPasswordRequired {
    return Intl.message(
      'Password is required',
      name: 'validatorPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password 8-character minimum`
  String get validatorPasswordCharacterMinimum {
    return Intl.message(
      'Password 8-character minimum',
      name: 'validatorPasswordCharacterMinimum',
      desc: '',
      args: [],
    );
  }

  /// `Password is least one uppercase, lowercase letter`
  String get validatorPasswordWrongFormat {
    return Intl.message(
      'Password is least one uppercase, lowercase letter',
      name: 'validatorPasswordWrongFormat',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password is required`
  String get validatorConfirmPasswordRequired {
    return Intl.message(
      'Confirm Password is required',
      name: 'validatorConfirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirm password not match`
  String get validatorConfirmedPasswordNotMatch {
    return Intl.message(
      'Password and confirm password not match',
      name: 'validatorConfirmedPasswordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Jane Cooper`
  String get landingTitle {
    return Intl.message(
      'Jane Cooper',
      name: 'landingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ut enim ad minima veniam, quis nostrum exercitat ionem ullam corporis suscipit laboriosam,`
  String get landingDescription {
    return Intl.message(
      'Ut enim ad minima veniam, quis nostrum exercitat ionem ullam corporis suscipit laboriosam,',
      name: 'landingDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signInTitle {
    return Intl.message('Sign in', name: 'signInTitle', desc: '', args: []);
  }

  /// `Welcome Back`
  String get signInWelcomeTitle {
    return Intl.message(
      'Welcome Back',
      name: 'signInWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get signInEmailHint {
    return Intl.message(
      'Enter your email address',
      name: 'signInEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get signInPassowrdHint {
    return Intl.message(
      'Enter your password',
      name: 'signInPassowrdHint',
      desc: '',
      args: [],
    );
  }

  /// `Hello there, sign in to continue`
  String get signInDescription {
    return Intl.message(
      'Hello there, sign in to continue',
      name: 'signInDescription',
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

  /// `Sign in`
  String get signInButton {
    return Intl.message('Sign in', name: 'signInButton', desc: '', args: []);
  }

  /// `Sign up`
  String get signUpTitle {
    return Intl.message('Sign up', name: 'signUpTitle', desc: '', args: []);
  }

  /// `Welcome to us`
  String get signUpWelcomeTitle {
    return Intl.message(
      'Welcome to us',
      name: 'signUpWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hello there, create New account`
  String get signUpDescription {
    return Intl.message(
      'Hello there, create New account',
      name: 'signUpDescription',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account your aggree \nto our  Term and Condtions`
  String get signUpTermAndConditions {
    return Intl.message(
      'By creating an account your aggree \nto our  Term and Condtions',
      name: 'signUpTermAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUpButton {
    return Intl.message('Sign up', name: 'signUpButton', desc: '', args: []);
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

  /// `Enter your user name`
  String get signUpUsername {
    return Intl.message(
      'Enter your user name',
      name: 'signUpUsername',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get signUpEmailHint {
    return Intl.message(
      'Enter your email address',
      name: 'signUpEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get signUpPassowrdHint {
    return Intl.message(
      'Enter your password',
      name: 'signUpPassowrdHint',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning`
  String get homegreetingTitle {
    return Intl.message(
      'Good Morning',
      name: 'homegreetingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account and Card`
  String get homeAccountAndCardTitle {
    return Intl.message(
      'Account and Card',
      name: 'homeAccountAndCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get homeTransferTitle {
    return Intl.message(
      'Transfer',
      name: 'homeTransferTitle',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get homeWithdrawTitle {
    return Intl.message(
      'Withdraw',
      name: 'homeWithdrawTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mobile recharge`
  String get homeMobileRechargeTitle {
    return Intl.message(
      'Mobile recharge',
      name: 'homeMobileRechargeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay the \nbill`
  String get homePayTheBillTitle {
    return Intl.message(
      'Pay the \nbill',
      name: 'homePayTheBillTitle',
      desc: '',
      args: [],
    );
  }

  /// `Creadit card`
  String get homeCreditCardTitle {
    return Intl.message(
      'Creadit card',
      name: 'homeCreditCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transaction \nReport`
  String get homeTransactionReportTitle {
    return Intl.message(
      'Transaction \nReport',
      name: 'homeTransactionReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transactions`
  String get transactionsHistoryTitle {
    return Intl.message(
      'Recent Transactions',
      name: 'transactionsHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tranfer money to`
  String get transferMoneyTitle {
    return Intl.message(
      'Tranfer money to',
      name: 'transferMoneyTitle',
      desc: '',
      args: [],
    );
  }

  /// `No fee`
  String get tranfersMoneyNoFeeTitle {
    return Intl.message(
      'No fee',
      name: 'tranfersMoneyNoFeeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select your account`
  String get tranfersMoneySelectAccount {
    return Intl.message(
      'Select your account',
      name: 'tranfersMoneySelectAccount',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get tranfersMoneySendButton {
    return Intl.message(
      'Send',
      name: 'tranfersMoneySendButton',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get tranfersMoneyCloseButton {
    return Intl.message(
      'Close',
      name: 'tranfersMoneyCloseButton',
      desc: '',
      args: [],
    );
  }

  /// `View Recepit`
  String get tranfersMoneyViewReceipt {
    return Intl.message(
      'View Recepit',
      name: 'tranfersMoneyViewReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountTitle {
    return Intl.message('Account', name: 'accountTitle', desc: '', args: []);
  }

  /// `Save Changes`
  String get accountSaveButton {
    return Intl.message(
      'Save Changes',
      name: 'accountSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Card Holder Name`
  String get accountCardHolderTitle {
    return Intl.message(
      'Card Holder Name',
      name: 'accountCardHolderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Expiry date`
  String get accountExpiryDateTitle {
    return Intl.message(
      'Expiry date',
      name: 'accountExpiryDateTitle',
      desc: '',
      args: [],
    );
  }

  /// `DETAIL INFORMATION`
  String get accountDetailInfoTitle {
    return Intl.message(
      'DETAIL INFORMATION',
      name: 'accountDetailInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get accountNameLabel {
    return Intl.message('Name', name: 'accountNameLabel', desc: '', args: []);
  }

  /// `Phone Number`
  String get accountPhoneNumberLabel {
    return Intl.message(
      'Phone Number',
      name: 'accountPhoneNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get accountEmailLabel {
    return Intl.message(
      'E-mail',
      name: 'accountEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Home Address`
  String get accountHomeAddressLabel {
    return Intl.message(
      'Home Address',
      name: 'accountHomeAddressLabel',
      desc: '',
      args: [],
    );
  }

  /// `Pay the bill`
  String get payBillTitle {
    return Intl.message(
      'Pay the bill',
      name: 'payBillTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay the bill`
  String get payBillButton {
    return Intl.message(
      'Pay the bill',
      name: 'payBillButton',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get payBillConfirmButton {
    return Intl.message(
      'Confirm',
      name: 'payBillConfirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Transaction successfully!`
  String get payBillTransactionSuccess {
    return Intl.message(
      'Transaction successfully!',
      name: 'payBillTransactionSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You 've pay your {type} bill!`
  String payBillTracsactionTitle(String type) {
    return Intl.message(
      'You \'ve pay your $type bill!',
      name: 'payBillTracsactionTitle',
      desc: '',
      args: [type],
    );
  }

  /// `Electric bill`
  String get payBillElectricTitle {
    return Intl.message(
      'Electric bill',
      name: 'payBillElectricTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay electric bill this month`
  String get payBillElectricDescription {
    return Intl.message(
      'Pay electric bill this month',
      name: 'payBillElectricDescription',
      desc: '',
      args: [],
    );
  }

  /// `Water bill`
  String get payBillWaterTitle {
    return Intl.message(
      'Water bill',
      name: 'payBillWaterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay water bill this month`
  String get payBillWaterDescription {
    return Intl.message(
      'Pay water bill this month',
      name: 'payBillWaterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Internet bill`
  String get payBillInternetTitle {
    return Intl.message(
      'Internet bill',
      name: 'payBillInternetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay internet bill this month`
  String get payBillInternetDescription {
    return Intl.message(
      'Pay internet bill this month',
      name: 'payBillInternetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Check Payment history`
  String get payBillCheckHistoryTitle {
    return Intl.message(
      'Check Payment history',
      name: 'payBillCheckHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `All the Bills`
  String get payBillAllTitle {
    return Intl.message(
      'All the Bills',
      name: 'payBillAllTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get payBillNameTitle {
    return Intl.message('Name', name: 'payBillNameTitle', desc: '', args: []);
  }

  /// `Address`
  String get payBillAddressTitle {
    return Intl.message(
      'Address',
      name: 'payBillAddressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get payBillPhoneNumberTitle {
    return Intl.message(
      'Phone number',
      name: 'payBillPhoneNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get payBillCodeTitle {
    return Intl.message('Code', name: 'payBillCodeTitle', desc: '', args: []);
  }

  /// `From`
  String get payBillFormTitle {
    return Intl.message('From', name: 'payBillFormTitle', desc: '', args: []);
  }

  /// `To`
  String get payBillToTitle {
    return Intl.message('To', name: 'payBillToTitle', desc: '', args: []);
  }

  /// `Payment history`
  String get payBillHistoryTitle {
    return Intl.message(
      'Payment history',
      name: 'payBillHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get payBillStatusTitle {
    return Intl.message(
      'Status',
      name: 'payBillStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get payBillAmountTitle {
    return Intl.message(
      'Amount',
      name: 'payBillAmountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose Company`
  String get payBillChooseCompanyHint {
    return Intl.message(
      'Choose Company',
      name: 'payBillChooseCompanyHint',
      desc: '',
      args: [],
    );
  }

  /// `Bill Code`
  String get payBillCodeHint {
    return Intl.message(
      'Bill Code',
      name: 'payBillCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct bill code to check information.`
  String get payBillDescription {
    return Intl.message(
      'Please enter the correct bill code to check information.',
      name: 'payBillDescription',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get payBillCheckButton {
    return Intl.message(
      'Check',
      name: 'payBillCheckButton',
      desc: '',
      args: [],
    );
  }

  /// `Type {type} bill code `
  String payBillTypeLabel(String type) {
    return Intl.message(
      'Type $type bill code ',
      name: 'payBillTypeLabel',
      desc: '',
      args: [type],
    );
  }

  /// `Company`
  String get payBillCompanyTitle {
    return Intl.message(
      'Company',
      name: 'payBillCompanyTitle',
      desc: '',
      args: [],
    );
  }

  /// `{type} fee`
  String payBillTypeTitle(String type) {
    return Intl.message(
      '$type fee',
      name: 'payBillTypeTitle',
      desc: '',
      args: [type],
    );
  }

  /// `Tax`
  String get payBillTaxTitle {
    return Intl.message('Tax', name: 'payBillTaxTitle', desc: '', args: []);
  }

  /// `Total`
  String get payBillTotalTitle {
    return Intl.message('Total', name: 'payBillTotalTitle', desc: '', args: []);
  }

  /// `Pay {type} bill this month`
  String payBillTypeCategory(String type) {
    return Intl.message(
      'Pay $type bill this month',
      name: 'payBillTypeCategory',
      desc: '',
      args: [type],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
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
