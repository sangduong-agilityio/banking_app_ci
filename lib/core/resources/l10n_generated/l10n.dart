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

  /// `Message`
  String get messageTitle {
    return Intl.message('Message', name: 'messageTitle', desc: '', args: []);
  }

  /// `Setting`
  String get settingTitle {
    return Intl.message('Setting', name: 'settingTitle', desc: '', args: []);
  }

  /// `No items found`
  String get noItemsFoundTitle {
    return Intl.message(
      'No items found',
      name: 'noItemsFoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `This page is not supported yet!`
  String get pageNotSupportedYet {
    return Intl.message(
      'This page is not supported yet!',
      name: 'pageNotSupportedYet',
      desc: '',
      args: [],
    );
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

  /// `Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam,`
  String get landingDescription {
    return Intl.message(
      'Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam,',
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

  /// `By creating an account your agree to our `
  String get signUpTermAndConditions {
    return Intl.message(
      'By creating an account your agree to our ',
      name: 'signUpTermAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Term and Conditions`
  String get signUpTermAndConditionButton {
    return Intl.message(
      'Term and Conditions',
      name: 'signUpTermAndConditionButton',
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

  /// `Hi, {type}`
  String homeGreetingTitle(String type) {
    return Intl.message(
      'Hi, $type',
      name: 'homeGreetingTitle',
      desc: '',
      args: [type],
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

  /// `Pay the bill`
  String get homePayTheBillTitle {
    return Intl.message(
      'Pay the bill',
      name: 'homePayTheBillTitle',
      desc: '',
      args: [],
    );
  }

  /// `Credit card`
  String get homeCreditCardTitle {
    return Intl.message(
      'Credit card',
      name: 'homeCreditCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Report`
  String get homeTransactionReportTitle {
    return Intl.message(
      'Transaction Report',
      name: 'homeTransactionReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save Online`
  String get homeSaveOnlineTitle {
    return Intl.message(
      'Save Online',
      name: 'homeSaveOnlineTitle',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary`
  String get homeBeneficiaryTitle {
    return Intl.message(
      'Beneficiary',
      name: 'homeBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchTitle {
    return Intl.message('Search', name: 'searchTitle', desc: '', args: []);
  }

  /// `Branch`
  String get searchBranchSelectedTitle {
    return Intl.message(
      'Branch',
      name: 'searchBranchSelectedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Interest rate`
  String get searchInterestRateTitle {
    return Intl.message(
      'Interest rate',
      name: 'searchInterestRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Exchange rate`
  String get searchExchangeRateTitle {
    return Intl.message(
      'Exchange rate',
      name: 'searchExchangeRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get searchExchangeTitle {
    return Intl.message(
      'Exchange',
      name: 'searchExchangeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Interest kind`
  String get searchInterestKindTitle {
    return Intl.message(
      'Interest kind',
      name: 'searchInterestKindTitle',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get searchDepositTitle {
    return Intl.message(
      'Deposit',
      name: 'searchDepositTitle',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get searchRateTitle {
    return Intl.message('Rate', name: 'searchRateTitle', desc: '', args: []);
  }

  /// `Country`
  String get searchCountryTitle {
    return Intl.message(
      'Country',
      name: 'searchCountryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get searchBuyTitle {
    return Intl.message('Buy', name: 'searchBuyTitle', desc: '', args: []);
  }

  /// `Sell`
  String get searchSellTitle {
    return Intl.message('Sell', name: 'searchSellTitle', desc: '', args: []);
  }

  /// `Language`
  String get searchLanguageTitle {
    return Intl.message(
      'Language',
      name: 'searchLanguageTitle',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get searchFormTitle {
    return Intl.message('From', name: 'searchFormTitle', desc: '', args: []);
  }

  /// `To`
  String get searchToTitle {
    return Intl.message('To', name: 'searchToTitle', desc: '', args: []);
  }

  /// `Current Rate`
  String get searchCurrentRateTitle {
    return Intl.message(
      'Current Rate',
      name: 'searchCurrentRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Exchange`
  String get searchExchangeButton {
    return Intl.message(
      'Exchange',
      name: 'searchExchangeButton',
      desc: '',
      args: [],
    );
  }

  /// `Search for branch`
  String get searchBranchDescription {
    return Intl.message(
      'Search for branch',
      name: 'searchBranchDescription',
      desc: '',
      args: [],
    );
  }

  /// `Search for interest rate`
  String get searchInterestRateDescription {
    return Intl.message(
      'Search for interest rate',
      name: 'searchInterestRateDescription',
      desc: '',
      args: [],
    );
  }

  /// `Search for exchange rate`
  String get searchExchangeRateDescription {
    return Intl.message(
      'Search for exchange rate',
      name: 'searchExchangeRateDescription',
      desc: '',
      args: [],
    );
  }

  /// `Exchange amount of money`
  String get searchExchangeDescription {
    return Intl.message(
      'Exchange amount of money',
      name: 'searchExchangeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Current rate`
  String get searchCurrentRateCalculatorTitle {
    return Intl.message(
      'Current rate',
      name: 'searchCurrentRateCalculatorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get searchAmoutTitle {
    return Intl.message('Amount', name: 'searchAmoutTitle', desc: '', args: []);
  }

  /// `Select the currency`
  String get searchSelectedCurrencyTitle {
    return Intl.message(
      'Select the currency',
      name: 'searchSelectedCurrencyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Offline Exchange`
  String get searchOfflineExchangeTitle {
    return Intl.message(
      'Offline Exchange',
      name: 'searchOfflineExchangeTitle',
      desc: '',
      args: [],
    );
  }

  /// `The exchange rate is offline and may be outdated. Do you want to proceed with the transaction?`
  String get searchOfflineExchangeContent {
    return Intl.message(
      'The exchange rate is offline and may be outdated. Do you want to proceed with the transaction?',
      name: 'searchOfflineExchangeContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get searchCancelButton {
    return Intl.message(
      'Cancel',
      name: 'searchCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get searchContinueButton {
    return Intl.message(
      'Continue',
      name: 'searchContinueButton',
      desc: '',
      args: [],
    );
  }

  /// `Transaction completed with offline rate`
  String get searchPerformExchangeStatusOffline {
    return Intl.message(
      'Transaction completed with offline rate',
      name: 'searchPerformExchangeStatusOffline',
      desc: '',
      args: [],
    );
  }

  /// `Transaction completed successfully`
  String get searchPerformExchangeStatusSuccess {
    return Intl.message(
      'Transaction completed successfully',
      name: 'searchPerformExchangeStatusSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Live rate`
  String get searchLiveRateTitle {
    return Intl.message(
      'Live rate',
      name: 'searchLiveRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Using offline exchange rate`
  String get searchUsingOfflineExchangeTitle {
    return Intl.message(
      'Using offline exchange rate',
      name: 'searchUsingOfflineExchangeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get searchRetryButton {
    return Intl.message('Retry', name: 'searchRetryButton', desc: '', args: []);
  }

  /// `Offline rate {type}`
  String searchOfflineRateTitle(String type) {
    return Intl.message(
      'Offline rate $type',
      name: 'searchOfflineRateTitle',
      desc: '',
      args: [type],
    );
  }

  /// `Cached data • Updated: {type}`
  String searchCachedDataTitle(String type) {
    return Intl.message(
      'Cached data • Updated: $type',
      name: 'searchCachedDataTitle',
      desc: '',
      args: [type],
    );
  }

  /// `Fresh data • Updated: {type}`
  String searchFreshDataTitle(String type) {
    return Intl.message(
      'Fresh data • Updated: $type',
      name: 'searchFreshDataTitle',
      desc: '',
      args: [type],
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

  /// `You've pay your {type} bill!`
  String payBillTracsactionTitle(String type) {
    return Intl.message(
      'You\'ve pay your $type bill!',
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

  /// `Type {type} bill code`
  String payBillTypeLabel(String type) {
    return Intl.message(
      'Type $type bill code',
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

  /// `Transfer`
  String get transferTitle {
    return Intl.message('Transfer', name: 'transferTitle', desc: '', args: []);
  }

  /// `Add New`
  String get transferAddNewBeneficiaryTitle {
    return Intl.message(
      'Add New',
      name: 'transferAddNewBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please add beneficiary name`
  String get transferAddNewBeneficiaryNameTitle {
    return Intl.message(
      'Please add beneficiary name',
      name: 'transferAddNewBeneficiaryNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary`
  String get transferBeneficiaryTitle {
    return Intl.message(
      'Beneficiary',
      name: 'transferBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select Account`
  String get transferAccountSelected {
    return Intl.message(
      'Select Account',
      name: 'transferAccountSelected',
      desc: '',
      args: [],
    );
  }

  /// `Choose account / card`
  String get transferSelectedAccountHint {
    return Intl.message(
      'Choose account / card',
      name: 'transferSelectedAccountHint',
      desc: '',
      args: [],
    );
  }

  /// `Transfer via card number`
  String get transferViaCardNumberTitle {
    return Intl.message(
      'Transfer via card number',
      name: 'transferViaCardNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer to the same bank`
  String get transferSameBankTitle {
    return Intl.message(
      'Transfer to the same bank',
      name: 'transferSameBankTitle',
      desc: '',
      args: [],
    );
  }

  /// `Transfer to another bank`
  String get transferAnotherBankTitle {
    return Intl.message(
      'Transfer to another bank',
      name: 'transferAnotherBankTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose transaction`
  String get transferChooseTransactionTitle {
    return Intl.message(
      'Choose transaction',
      name: 'transferChooseTransactionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose beneficiary`
  String get transferChooseBeneficiaryTitle {
    return Intl.message(
      'Choose beneficiary',
      name: 'transferChooseBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Find Beneficiary`
  String get transferFindBeneficiaryTitle {
    return Intl.message(
      'Find Beneficiary',
      name: 'transferFindBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Available balance: {type}`
  String transferAvailableBalanceTitle(String type) {
    return Intl.message(
      'Available balance: $type',
      name: 'transferAvailableBalanceTitle',
      desc: '',
      args: [type],
    );
  }

  /// `Save to directory`
  String get transferSaveDirectoryButton {
    return Intl.message(
      'Save to directory',
      name: 'transferSaveDirectoryButton',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get transferNameLabel {
    return Intl.message('Name', name: 'transferNameLabel', desc: '', args: []);
  }

  /// `Resend`
  String get transferResendButton {
    return Intl.message(
      'Resend',
      name: 'transferResendButton',
      desc: '',
      args: [],
    );
  }

  /// `Card number`
  String get transferCardNumberLabel {
    return Intl.message(
      'Card number',
      name: 'transferCardNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary Name`
  String get transferAddNewBeneficiaryLabel {
    return Intl.message(
      'Beneficiary Name',
      name: 'transferAddNewBeneficiaryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Save to beneficiary directory`
  String get transferSaveBeneficiaryTitle {
    return Intl.message(
      'Save to beneficiary directory',
      name: 'transferSaveBeneficiaryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get transferConfirmButton {
    return Intl.message(
      'Confirm',
      name: 'transferConfirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get transferConfirmTitle {
    return Intl.message(
      'Confirm',
      name: 'transferConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get transferAmountLabel {
    return Intl.message(
      'Amount',
      name: 'transferAmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get transferContentLabel {
    return Intl.message(
      'Content',
      name: 'transferContentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose bank`
  String get transferChooseBankLabel {
    return Intl.message(
      'Choose bank',
      name: 'transferChooseBankLabel',
      desc: '',
      args: [],
    );
  }

  /// `Choose branch`
  String get transferChooseBranchLabel {
    return Intl.message(
      'Choose branch',
      name: 'transferChooseBranchLabel',
      desc: '',
      args: [],
    );
  }

  /// `Form`
  String get transferFormLabel {
    return Intl.message('Form', name: 'transferFormLabel', desc: '', args: []);
  }

  /// `To`
  String get transferToLabel {
    return Intl.message('To', name: 'transferToLabel', desc: '', args: []);
  }

  /// `Transaction fee`
  String get transferTransactionFeeLabel {
    return Intl.message(
      'Transaction fee',
      name: 'transferTransactionFeeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Beneficiary bank`
  String get transferBeneficiaryBank {
    return Intl.message(
      'Beneficiary bank',
      name: 'transferBeneficiaryBank',
      desc: '',
      args: [],
    );
  }

  /// `Choose beneficiary bank`
  String get transferSelectBeneficiary {
    return Intl.message(
      'Choose beneficiary bank',
      name: 'transferSelectBeneficiary',
      desc: '',
      args: [],
    );
  }

  /// `Confirm transaction information`
  String get transferConfirmTransaction {
    return Intl.message(
      'Confirm transaction information',
      name: 'transferConfirmTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Transfer successful!`
  String get transferSuccessTitle {
    return Intl.message(
      'Transfer successful!',
      name: 'transferSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get OTP to verify transaction`
  String get transferGetOtpTransactionTitle {
    return Intl.message(
      'Get OTP to verify transaction',
      name: 'transferGetOtpTransactionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Get OTP`
  String get transferGetOtpButton {
    return Intl.message(
      'Get OTP',
      name: 'transferGetOtpButton',
      desc: '',
      args: [],
    );
  }

  /// `OTP has been sent to your email. Please check your inbox`
  String get transferSendOtpToEmailTitle {
    return Intl.message(
      'OTP has been sent to your email. Please check your inbox',
      name: 'transferSendOtpToEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `OTP`
  String get transferOtpLabel {
    return Intl.message('OTP', name: 'transferOtpLabel', desc: '', args: []);
  }

  /// `Please enter the OTP code`
  String get transferEnterOtpCodeTitle {
    return Intl.message(
      'Please enter the OTP code',
      name: 'transferEnterOtpCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use biometric authentication instead`
  String get transferBiometricAuthenticationTitle {
    return Intl.message(
      'Use biometric authentication instead',
      name: 'transferBiometricAuthenticationTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully transferred`
  String get transferSuccessDescription {
    return Intl.message(
      'You have successfully transferred',
      name: 'transferSuccessDescription',
      desc: '',
      args: [],
    );
  }

  /// `No beneficiaries found`
  String get transferNoBeneficiariesFoundTitle {
    return Intl.message(
      'No beneficiaries found',
      name: 'transferNoBeneficiariesFoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get settingPasswordTitle {
    return Intl.message(
      'Password',
      name: 'settingPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get settingLanguaguesTitle {
    return Intl.message(
      'Languages',
      name: 'settingLanguaguesTitle',
      desc: '',
      args: [],
    );
  }

  /// `App information`
  String get settingAppInformationTitle {
    return Intl.message(
      'App information',
      name: 'settingAppInformationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Customer care`
  String get settingCustomerCareTitle {
    return Intl.message(
      'Customer care',
      name: 'settingCustomerCareTitle',
      desc: '',
      args: [],
    );
  }

  /// `19008989`
  String get settingCustomerCareSubtitle {
    return Intl.message(
      '19008989',
      name: 'settingCustomerCareSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get settingChangePasswordTitle {
    return Intl.message(
      'Change password',
      name: 'settingChangePasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Log out?`
  String get settingLogoutTitle {
    return Intl.message(
      'Log out?',
      name: 'settingLogoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `You will be returned to the login screen`
  String get settingLogoutContent {
    return Intl.message(
      'You will be returned to the login screen',
      name: 'settingLogoutContent',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get settingLogoutLogoutButton {
    return Intl.message(
      'Log out',
      name: 'settingLogoutLogoutButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get settingCancelButton {
    return Intl.message(
      'Cancel',
      name: 'settingCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Recent password`
  String get settingRecentPasswordLabel {
    return Intl.message(
      'Recent password',
      name: 'settingRecentPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get settingNewPasswordLabel {
    return Intl.message(
      'New password',
      name: 'settingNewPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get settingConfirmPasswordLabel {
    return Intl.message(
      'Confirm password',
      name: 'settingConfirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get settingChangePasswordButton {
    return Intl.message(
      'Change password',
      name: 'settingChangePasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `Touch ID`
  String get settingTouchIdLabel {
    return Intl.message(
      'Touch ID',
      name: 'settingTouchIdLabel',
      desc: '',
      args: [],
    );
  }

  /// `Transaction report`
  String get transactionReportTitle {
    return Intl.message(
      'Transaction report',
      name: 'transactionReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get transactionBalanceTitle {
    return Intl.message(
      'Balance',
      name: 'transactionBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get transactionTodayTitle {
    return Intl.message(
      'Today',
      name: 'transactionTodayTitle',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get transactionYesterdayTitle {
    return Intl.message(
      'Yesterday',
      name: 'transactionYesterdayTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recent`
  String get transactionRecentTitle {
    return Intl.message(
      'Recent',
      name: 'transactionRecentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountTitle {
    return Intl.message('Account', name: 'accountTitle', desc: '', args: []);
  }

  /// `Card`
  String get accountCardTitle {
    return Intl.message('Card', name: 'accountCardTitle', desc: '', args: []);
  }

  /// `Management`
  String get accountManagementTitle {
    return Intl.message(
      'Management',
      name: 'accountManagementTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account and Card`
  String get accountAndCardTitle {
    return Intl.message(
      'Account and Card',
      name: 'accountAndCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add card`
  String get accountAddCardButton {
    return Intl.message(
      'Add card',
      name: 'accountAddCardButton',
      desc: '',
      args: [],
    );
  }

  /// `Available balance`
  String get accountAvailableBalanceTitle {
    return Intl.message(
      'Available balance',
      name: 'accountAvailableBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Branch`
  String get accountBranchTitle {
    return Intl.message(
      'Branch',
      name: 'accountBranchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Form`
  String get accountFromDateTitle {
    return Intl.message(
      'Form',
      name: 'accountFromDateTitle',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get accountToDateTitle {
    return Intl.message('To', name: 'accountToDateTitle', desc: '', args: []);
  }

  /// `Time deposit`
  String get accountTermTitle {
    return Intl.message(
      'Time deposit',
      name: 'accountTermTitle',
      desc: '',
      args: [],
    );
  }

  /// `Interest rate`
  String get accountInterestRateTitle {
    return Intl.message(
      'Interest rate',
      name: 'accountInterestRateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Card`
  String get accountDeleteCardTitle {
    return Intl.message(
      'Delete Card',
      name: 'accountDeleteCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this card?`
  String get accountContentTitle {
    return Intl.message(
      'Are you sure you want to delete this card?',
      name: 'accountContentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get accountCancelTitle {
    return Intl.message(
      'Cancel',
      name: 'accountCancelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get accountDeleteTitle {
    return Intl.message(
      'Delete',
      name: 'accountDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get accountNameTitle {
    return Intl.message('Name', name: 'accountNameTitle', desc: '', args: []);
  }

  /// `Card number`
  String get accountCardNumberTitle {
    return Intl.message(
      'Card number',
      name: 'accountCardNumberTitle',
      desc: '',
      args: [],
    );
  }

  /// `Valid from`
  String get accountValidFromTitle {
    return Intl.message(
      'Valid from',
      name: 'accountValidFromTitle',
      desc: '',
      args: [],
    );
  }

  /// `Good thru`
  String get accountGoodThruTitle {
    return Intl.message(
      'Good thru',
      name: 'accountGoodThruTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load data`
  String get exchangeRateError {
    return Intl.message(
      'Failed to load data',
      name: 'exchangeRateError',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. Please check your email and password.`
  String get authErrorLoginFailed {
    return Intl.message(
      'Login failed. Please check your email and password.',
      name: 'authErrorLoginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Signup failed. Please verify your information and try again.`
  String get authErrorSignupFailed {
    return Intl.message(
      'Signup failed. Please verify your information and try again.',
      name: 'authErrorSignupFailed',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication is not enabled.`
  String get authErrorBiometricNotEnabled {
    return Intl.message(
      'Biometric authentication is not enabled.',
      name: 'authErrorBiometricNotEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed.`
  String get authErrorBiometricFailed {
    return Intl.message(
      'Biometric authentication failed.',
      name: 'authErrorBiometricFailed',
      desc: '',
      args: [],
    );
  }

  /// `No saved credentials found for biometric login.`
  String get authErrorNoSavedCredentials {
    return Intl.message(
      'No saved credentials found for biometric login.',
      name: 'authErrorNoSavedCredentials',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred. Please try again.`
  String get authErrorUnknown {
    return Intl.message(
      'An unknown error occurred. Please try again.',
      name: 'authErrorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `No pending transfer found to confirm.`
  String get transferErrorNoPendingTransaction {
    return Intl.message(
      'No pending transfer found to confirm.',
      name: 'transferErrorNoPendingTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP. Please try again`
  String get transferErrorOtpInvalid {
    return Intl.message(
      'Invalid OTP. Please try again',
      name: 'transferErrorOtpInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Biometric login not available`
  String get transferErrorBiometricUnavailable {
    return Intl.message(
      'Biometric login not available',
      name: 'transferErrorBiometricUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed`
  String get transferErrorBiometricFailed {
    return Intl.message(
      'Biometric authentication failed',
      name: 'transferErrorBiometricFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to calculate transaction fee`
  String get transferErrorCalculateFee {
    return Intl.message(
      'Failed to calculate transaction fee',
      name: 'transferErrorCalculateFee',
      desc: '',
      args: [],
    );
  }

  /// `Transfer failed. Please try again.`
  String get transferErrorTransferFailed {
    return Intl.message(
      'Transfer failed. Please try again.',
      name: 'transferErrorTransferFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please complete authentication before confirming transfer.`
  String get transferErrorAuthenticationRequired {
    return Intl.message(
      'Please complete authentication before confirming transfer.',
      name: 'transferErrorAuthenticationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password. Please try again.`
  String get authErrorInvalidCredentials {
    return Intl.message(
      'Invalid email or password. Please try again.',
      name: 'authErrorInvalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Please check your email and confirm your account.`
  String get authErrorEmailNotConfirmed {
    return Intl.message(
      'Please check your email and confirm your account.',
      name: 'authErrorEmailNotConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `No account found with this email address.`
  String get authErrorUserNotFound {
    return Intl.message(
      'No account found with this email address.',
      name: 'authErrorUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Too many failed attempts. Please try again in 15 minutes.`
  String get authErrorTooManyAttempts {
    return Intl.message(
      'Too many failed attempts. Please try again in 15 minutes.',
      name: 'authErrorTooManyAttempts',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak. Please choose a stronger password.`
  String get authErrorWeakPassword {
    return Intl.message(
      'Password is too weak. Please choose a stronger password.',
      name: 'authErrorWeakPassword',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email already exists.`
  String get authErrorEmailAlreadyExists {
    return Intl.message(
      'An account with this email already exists.',
      name: 'authErrorEmailAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed. Please try again.`
  String get authErrorGeneric {
    return Intl.message(
      'Authentication failed. Please try again.',
      name: 'authErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Request timed out. Please check your connection and try again.`
  String get networkErrorTimeout {
    return Intl.message(
      'Request timed out. Please check your connection and try again.',
      name: 'networkErrorTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection and try again.`
  String get networkErrorConnection {
    return Intl.message(
      'Please check your internet connection and try again.',
      name: 'networkErrorConnection',
      desc: '',
      args: [],
    );
  }

  /// `Security certificate error. Please contact support.`
  String get networkErrorSecurity {
    return Intl.message(
      'Security certificate error. Please contact support.',
      name: 'networkErrorSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Network error occurred. Please try again.`
  String get networkErrorGeneric {
    return Intl.message(
      'Network error occurred. Please try again.',
      name: 'networkErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Invalid request. Please check your input and try again.`
  String get httpErrorBadRequest {
    return Intl.message(
      'Invalid request. Please check your input and try again.',
      name: 'httpErrorBadRequest',
      desc: '',
      args: [],
    );
  }

  /// `Session expired. Please sign in again.`
  String get httpErrorUnauthorized {
    return Intl.message(
      'Session expired. Please sign in again.',
      name: 'httpErrorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Access denied. Please contact support if this persists.`
  String get httpErrorForbidden {
    return Intl.message(
      'Access denied. Please contact support if this persists.',
      name: 'httpErrorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Service not found. Please try again later.`
  String get httpErrorNotFound {
    return Intl.message(
      'Service not found. Please try again later.',
      name: 'httpErrorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests. Please wait a moment and try again.`
  String get httpErrorTooManyRequests {
    return Intl.message(
      'Too many requests. Please wait a moment and try again.',
      name: 'httpErrorTooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get httpErrorServerError {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'httpErrorServerError',
      desc: '',
      args: [],
    );
  }

  /// `Service temporarily unavailable. Please try again later.`
  String get httpErrorGeneric {
    return Intl.message(
      'Service temporarily unavailable. Please try again later.',
      name: 'httpErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please contact support if this persists.`
  String get applicationErrorGeneric {
    return Intl.message(
      'An unexpected error occurred. Please contact support if this persists.',
      name: 'applicationErrorGeneric',
      desc: '',
      args: [],
    );
  }

  /// `You are currently offline.`
  String get offline_text {
    return Intl.message(
      'You are currently offline.',
      name: 'offline_text',
      desc: '',
      args: [],
    );
  }

  /// `Using cached rates`
  String get searchUsingCachedRates {
    return Intl.message(
      'Using cached rates',
      name: 'searchUsingCachedRates',
      desc: '',
      args: [],
    );
  }

  /// `1 {fromCurrency} = {rate} {toCurrency}`
  String searchExchangeRate(
    String fromCurrency,
    String rate,
    String toCurrency,
  ) {
    return Intl.message(
      '1 $fromCurrency = $rate $toCurrency',
      name: 'searchExchangeRate',
      desc: '',
      args: [fromCurrency, rate, toCurrency],
    );
  }

  /// `Available Balance`
  String get cardAvailableBalance {
    return Intl.message(
      'Available Balance',
      name: 'cardAvailableBalance',
      desc: '',
      args: [],
    );
  }

  /// `************`
  String get cardMaskedBalance {
    return Intl.message(
      '************',
      name: 'cardMaskedBalance',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get transactionCardNumber {
    return Intl.message(
      'Card Number',
      name: 'transactionCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Same Bank`
  String get transactionSameBank {
    return Intl.message(
      'Same Bank',
      name: 'transactionSameBank',
      desc: '',
      args: [],
    );
  }

  /// `Other Bank`
  String get transactionOtherBank {
    return Intl.message(
      'Other Bank',
      name: 'transactionOtherBank',
      desc: '',
      args: [],
    );
  }

  /// `Electric Bill`
  String get transactionElectricBill {
    return Intl.message(
      'Electric Bill',
      name: 'transactionElectricBill',
      desc: '',
      args: [],
    );
  }

  /// `Water Bill`
  String get transactionWaterBill {
    return Intl.message(
      'Water Bill',
      name: 'transactionWaterBill',
      desc: '',
      args: [],
    );
  }

  /// `Internet Bill`
  String get transactionInternetBill {
    return Intl.message(
      'Internet Bill',
      name: 'transactionInternetBill',
      desc: '',
      args: [],
    );
  }

  /// `Transfer: Via Card Number`
  String get transactionTransferViaCardNumber {
    return Intl.message(
      'Transfer: Via Card Number',
      name: 'transactionTransferViaCardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Transfer: Same Bank`
  String get transactionTransferSameBank {
    return Intl.message(
      'Transfer: Same Bank',
      name: 'transactionTransferSameBank',
      desc: '',
      args: [],
    );
  }

  /// `Transfer: Other Bank`
  String get transactionTransferOtherBank {
    return Intl.message(
      'Transfer: Other Bank',
      name: 'transactionTransferOtherBank',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transactionTransfer {
    return Intl.message(
      'Transfer',
      name: 'transactionTransfer',
      desc: '',
      args: [],
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
