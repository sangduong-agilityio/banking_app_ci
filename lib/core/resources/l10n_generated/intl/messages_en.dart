// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(type) => "Hi, ${type}";

  static String m1(type) => "You\'ve pay your ${type} bill!";

  static String m2(type) => "Pay ${type} bill this month";

  static String m3(type) => "Type ${type} bill code";

  static String m4(type) => "${type} fee";

  static String m5(type) => "Cached data • Updated: ${type}";

  static String m6(type) => "Fresh data • Updated: ${type}";

  static String m7(type) => "Offline rate ${type}";

  static String m8(type) => "Available balance: ${type}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accountAddCardButton": MessageLookupByLibrary.simpleMessage("Add card"),
    "accountAndCardTitle": MessageLookupByLibrary.simpleMessage(
      "Account and Card",
    ),
    "accountAvailableBalanceTitle": MessageLookupByLibrary.simpleMessage(
      "Available balance",
    ),
    "accountBranchTitle": MessageLookupByLibrary.simpleMessage("Branch"),
    "accountCancelTitle": MessageLookupByLibrary.simpleMessage("Cancel"),
    "accountCardNumberTitle": MessageLookupByLibrary.simpleMessage(
      "Card number",
    ),
    "accountCardTitle": MessageLookupByLibrary.simpleMessage("Card"),
    "accountContentTitle": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this card?",
    ),
    "accountDeleteCardTitle": MessageLookupByLibrary.simpleMessage(
      "Delete Card",
    ),
    "accountDeleteTitle": MessageLookupByLibrary.simpleMessage("Delete"),
    "accountFromDateTitle": MessageLookupByLibrary.simpleMessage("Form"),
    "accountGoodThruTitle": MessageLookupByLibrary.simpleMessage("Good thru"),
    "accountInterestRateTitle": MessageLookupByLibrary.simpleMessage(
      "Interest rate",
    ),
    "accountManagementTitle": MessageLookupByLibrary.simpleMessage(
      "Management",
    ),
    "accountNameTitle": MessageLookupByLibrary.simpleMessage("Name"),
    "accountTermTitle": MessageLookupByLibrary.simpleMessage("Time deposit"),
    "accountTitle": MessageLookupByLibrary.simpleMessage("Account"),
    "accountToDateTitle": MessageLookupByLibrary.simpleMessage("To"),
    "accountValidFromTitle": MessageLookupByLibrary.simpleMessage("Valid from"),
    "applicationErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred. Please contact support if this persists.",
    ),
    "authErrorBiometricFailed": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication failed.",
    ),
    "authErrorBiometricNotEnabled": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication is not enabled.",
    ),
    "authErrorEmailAlreadyExists": MessageLookupByLibrary.simpleMessage(
      "An account with this email already exists.",
    ),
    "authErrorEmailNotConfirmed": MessageLookupByLibrary.simpleMessage(
      "Please check your email and confirm your account.",
    ),
    "authErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Authentication failed. Please try again.",
    ),
    "authErrorInvalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password. Please try again.",
    ),
    "authErrorLoginFailed": MessageLookupByLibrary.simpleMessage(
      "Login failed. Please check your email and password.",
    ),
    "authErrorNoSavedCredentials": MessageLookupByLibrary.simpleMessage(
      "No saved credentials found for biometric login.",
    ),
    "authErrorSignupFailed": MessageLookupByLibrary.simpleMessage(
      "Signup failed. Please verify your information and try again.",
    ),
    "authErrorTooManyAttempts": MessageLookupByLibrary.simpleMessage(
      "Too many failed attempts. Please try again in 15 minutes.",
    ),
    "authErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "An unknown error occurred. Please try again.",
    ),
    "authErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
      "No account found with this email address.",
    ),
    "authErrorWeakPassword": MessageLookupByLibrary.simpleMessage(
      "Password is too weak. Please choose a stronger password.",
    ),
    "exchangeRateError": MessageLookupByLibrary.simpleMessage(
      "Failed to load data",
    ),
    "homeAccountAndCardTitle": MessageLookupByLibrary.simpleMessage(
      "Account and Card",
    ),
    "homeBeneficiaryTitle": MessageLookupByLibrary.simpleMessage("Beneficiary"),
    "homeCreditCardTitle": MessageLookupByLibrary.simpleMessage("Credit card"),
    "homeGreetingTitle": m0,
    "homeMobileRechargeTitle": MessageLookupByLibrary.simpleMessage(
      "Mobile recharge",
    ),
    "homePayTheBillTitle": MessageLookupByLibrary.simpleMessage(
      "Pay the \nbill",
    ),
    "homeSaveOnlineTitle": MessageLookupByLibrary.simpleMessage("Save Online"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
    "homeTransactionReportTitle": MessageLookupByLibrary.simpleMessage(
      "Transaction \nReport",
    ),
    "homeTransferTitle": MessageLookupByLibrary.simpleMessage("Transfer"),
    "homeWithdrawTitle": MessageLookupByLibrary.simpleMessage("Withdraw"),
    "httpErrorBadRequest": MessageLookupByLibrary.simpleMessage(
      "Invalid request. Please check your input and try again.",
    ),
    "httpErrorForbidden": MessageLookupByLibrary.simpleMessage(
      "Access denied. Please contact support if this persists.",
    ),
    "httpErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Service temporarily unavailable. Please try again later.",
    ),
    "httpErrorNotFound": MessageLookupByLibrary.simpleMessage(
      "Service not found. Please try again later.",
    ),
    "httpErrorServerError": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "httpErrorTooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many requests. Please wait a moment and try again.",
    ),
    "httpErrorUnauthorized": MessageLookupByLibrary.simpleMessage(
      "Session expired. Please sign in again.",
    ),
    "landingDescription": MessageLookupByLibrary.simpleMessage(
      "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam,",
    ),
    "landingTitle": MessageLookupByLibrary.simpleMessage("Jane Cooper"),
    "messageTitle": MessageLookupByLibrary.simpleMessage("Message"),
    "networkErrorConnection": MessageLookupByLibrary.simpleMessage(
      "Please check your internet connection and try again.",
    ),
    "networkErrorGeneric": MessageLookupByLibrary.simpleMessage(
      "Network error occurred. Please try again.",
    ),
    "networkErrorSecurity": MessageLookupByLibrary.simpleMessage(
      "Security certificate error. Please contact support.",
    ),
    "networkErrorTimeout": MessageLookupByLibrary.simpleMessage(
      "Request timed out. Please check your connection and try again.",
    ),
    "noItemsFoundTitle": MessageLookupByLibrary.simpleMessage("No items found"),
    "pageNotSupportedYet": MessageLookupByLibrary.simpleMessage(
      "This page is not supported yet!",
    ),
    "payBillAddressTitle": MessageLookupByLibrary.simpleMessage("Address"),
    "payBillAllTitle": MessageLookupByLibrary.simpleMessage("All the Bills"),
    "payBillAmountTitle": MessageLookupByLibrary.simpleMessage("Amount"),
    "payBillButton": MessageLookupByLibrary.simpleMessage("Pay the bill"),
    "payBillCheckButton": MessageLookupByLibrary.simpleMessage("Check"),
    "payBillCheckHistoryTitle": MessageLookupByLibrary.simpleMessage(
      "Check Payment history",
    ),
    "payBillChooseCompanyHint": MessageLookupByLibrary.simpleMessage(
      "Choose Company",
    ),
    "payBillCodeHint": MessageLookupByLibrary.simpleMessage("Bill Code"),
    "payBillCodeTitle": MessageLookupByLibrary.simpleMessage("Code"),
    "payBillCompanyTitle": MessageLookupByLibrary.simpleMessage("Company"),
    "payBillConfirmButton": MessageLookupByLibrary.simpleMessage("Confirm"),
    "payBillDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter the correct bill code to check information.",
    ),
    "payBillElectricDescription": MessageLookupByLibrary.simpleMessage(
      "Pay electric bill this month",
    ),
    "payBillElectricTitle": MessageLookupByLibrary.simpleMessage(
      "Electric bill",
    ),
    "payBillFormTitle": MessageLookupByLibrary.simpleMessage("From"),
    "payBillHistoryTitle": MessageLookupByLibrary.simpleMessage(
      "Payment history",
    ),
    "payBillInternetDescription": MessageLookupByLibrary.simpleMessage(
      "Pay internet bill this month",
    ),
    "payBillInternetTitle": MessageLookupByLibrary.simpleMessage(
      "Internet bill",
    ),
    "payBillNameTitle": MessageLookupByLibrary.simpleMessage("Name"),
    "payBillPhoneNumberTitle": MessageLookupByLibrary.simpleMessage(
      "Phone number",
    ),
    "payBillStatusTitle": MessageLookupByLibrary.simpleMessage("Status"),
    "payBillTaxTitle": MessageLookupByLibrary.simpleMessage("Tax"),
    "payBillTitle": MessageLookupByLibrary.simpleMessage("Pay the bill"),
    "payBillToTitle": MessageLookupByLibrary.simpleMessage("To"),
    "payBillTotalTitle": MessageLookupByLibrary.simpleMessage("Total"),
    "payBillTracsactionTitle": m1,
    "payBillTransactionSuccess": MessageLookupByLibrary.simpleMessage(
      "Transaction successfully!",
    ),
    "payBillTypeCategory": m2,
    "payBillTypeLabel": m3,
    "payBillTypeTitle": m4,
    "payBillWaterDescription": MessageLookupByLibrary.simpleMessage(
      "Pay water bill this month",
    ),
    "payBillWaterTitle": MessageLookupByLibrary.simpleMessage("Water bill"),
    "searchAmoutTitle": MessageLookupByLibrary.simpleMessage("Amount"),
    "searchBranchDescription": MessageLookupByLibrary.simpleMessage(
      "Search for branch",
    ),
    "searchBranchSelectedTitle": MessageLookupByLibrary.simpleMessage("Branch"),
    "searchBuyTitle": MessageLookupByLibrary.simpleMessage("Buy"),
    "searchCachedDataTitle": m5,
    "searchCancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "searchContinueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "searchCountryTitle": MessageLookupByLibrary.simpleMessage("Country"),
    "searchCurrentRateCalculatorTitle": MessageLookupByLibrary.simpleMessage(
      "Current rate",
    ),
    "searchCurrentRateTitle": MessageLookupByLibrary.simpleMessage(
      "Current Rate",
    ),
    "searchDepositTitle": MessageLookupByLibrary.simpleMessage("Deposit"),
    "searchExchangeButton": MessageLookupByLibrary.simpleMessage("Exchange"),
    "searchExchangeDescription": MessageLookupByLibrary.simpleMessage(
      "Exchange amount of money",
    ),
    "searchExchangeRateDescription": MessageLookupByLibrary.simpleMessage(
      "Search for exchange rate",
    ),
    "searchExchangeRateTitle": MessageLookupByLibrary.simpleMessage(
      "Exchange rate",
    ),
    "searchExchangeTitle": MessageLookupByLibrary.simpleMessage("Exchange"),
    "searchFormTitle": MessageLookupByLibrary.simpleMessage("From"),
    "searchFreshDataTitle": m6,
    "searchInterestKindTitle": MessageLookupByLibrary.simpleMessage(
      "Interest kind",
    ),
    "searchInterestRateDescription": MessageLookupByLibrary.simpleMessage(
      "Search for interest rate",
    ),
    "searchInterestRateTitle": MessageLookupByLibrary.simpleMessage(
      "Interest rate",
    ),
    "searchLanguageTitle": MessageLookupByLibrary.simpleMessage("Language"),
    "searchLiveRateTitle": MessageLookupByLibrary.simpleMessage("Live rate"),
    "searchOfflineExchangeContent": MessageLookupByLibrary.simpleMessage(
      "The exchange rate is offline and may be outdated. Do you want to proceed with the transaction?",
    ),
    "searchOfflineExchangeTitle": MessageLookupByLibrary.simpleMessage(
      "Offline Exchange",
    ),
    "searchOfflineRateTitle": m7,
    "searchPerformExchangeStatusOffline": MessageLookupByLibrary.simpleMessage(
      "Transaction completed with offline rate",
    ),
    "searchPerformExchangeStatusSuccess": MessageLookupByLibrary.simpleMessage(
      "Transaction completed successfully",
    ),
    "searchRateTitle": MessageLookupByLibrary.simpleMessage("Rate"),
    "searchRetryButton": MessageLookupByLibrary.simpleMessage("Retry"),
    "searchSelectedCurrencyTitle": MessageLookupByLibrary.simpleMessage(
      "Select the currency",
    ),
    "searchSellTitle": MessageLookupByLibrary.simpleMessage("Sell"),
    "searchTitle": MessageLookupByLibrary.simpleMessage("Search"),
    "searchToTitle": MessageLookupByLibrary.simpleMessage("To"),
    "searchUsingOfflineExchangeTitle": MessageLookupByLibrary.simpleMessage(
      "Using offline exchange rate",
    ),
    "settingAppInformationTitle": MessageLookupByLibrary.simpleMessage(
      "App information",
    ),
    "settingCancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "settingChangePasswordButton": MessageLookupByLibrary.simpleMessage(
      "Change password",
    ),
    "settingChangePasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Change password",
    ),
    "settingConfirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Confirm password",
    ),
    "settingCustomerCareTitle": MessageLookupByLibrary.simpleMessage(
      "Customer care",
    ),
    "settingLanguaguesTitle": MessageLookupByLibrary.simpleMessage("Languages"),
    "settingLogoutContent": MessageLookupByLibrary.simpleMessage(
      "You will be returned to the login screen",
    ),
    "settingLogoutLogoutButton": MessageLookupByLibrary.simpleMessage(
      "Log out",
    ),
    "settingLogoutTitle": MessageLookupByLibrary.simpleMessage("Log out?"),
    "settingNewPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "New password",
    ),
    "settingPasswordTitle": MessageLookupByLibrary.simpleMessage("Password"),
    "settingRecentPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Recent password",
    ),
    "settingTitle": MessageLookupByLibrary.simpleMessage("Setting"),
    "settingTouchIdLabel": MessageLookupByLibrary.simpleMessage("Touch ID"),
    "signInButton": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInDescription": MessageLookupByLibrary.simpleMessage(
      "Hello there, sign in to continue",
    ),
    "signInEmailHint": MessageLookupByLibrary.simpleMessage(
      "Enter your email address",
    ),
    "signInForgotPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot your password?",
    ),
    "signInPassowrdHint": MessageLookupByLibrary.simpleMessage(
      "Enter your password",
    ),
    "signInSignUpPrompt": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "signInTitle": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInWelcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "signUpAlreadyAcccount": MessageLookupByLibrary.simpleMessage(
      "Have an account? ",
    ),
    "signUpButton": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signUpDescription": MessageLookupByLibrary.simpleMessage(
      "Hello there, create New account",
    ),
    "signUpEmailHint": MessageLookupByLibrary.simpleMessage(
      "Enter your email address",
    ),
    "signUpPassowrdHint": MessageLookupByLibrary.simpleMessage(
      "Enter your password",
    ),
    "signUpTermAndConditionButton": MessageLookupByLibrary.simpleMessage(
      "Term and Conditions",
    ),
    "signUpTermAndConditions": MessageLookupByLibrary.simpleMessage(
      "By creating an account your agree \nto our ",
    ),
    "signUpTitle": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signUpUsername": MessageLookupByLibrary.simpleMessage(
      "Enter your user name",
    ),
    "signUpWelcomeTitle": MessageLookupByLibrary.simpleMessage("Welcome to us"),
    "transactionBalanceTitle": MessageLookupByLibrary.simpleMessage("Balance"),
    "transactionRecentTitle": MessageLookupByLibrary.simpleMessage("Recent"),
    "transactionReportTitle": MessageLookupByLibrary.simpleMessage(
      "Transaction report",
    ),
    "transactionTodayTitle": MessageLookupByLibrary.simpleMessage("Today"),
    "transactionYesterdayTitle": MessageLookupByLibrary.simpleMessage(
      "Yesterday",
    ),
    "transferAccountSelected": MessageLookupByLibrary.simpleMessage(
      "Select Account",
    ),
    "transferAddNewBeneficiaryLabel": MessageLookupByLibrary.simpleMessage(
      "Beneficiary Name",
    ),
    "transferAddNewBeneficiaryNameTitle": MessageLookupByLibrary.simpleMessage(
      "Please add beneficiary name",
    ),
    "transferAddNewBeneficiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Add New",
    ),
    "transferAmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "transferAnotherBankTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer to another bank",
    ),
    "transferAvailableBalanceTitle": m8,
    "transferBeneficiaryBank": MessageLookupByLibrary.simpleMessage(
      "Beneficiary bank",
    ),
    "transferBeneficiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Beneficiary",
    ),
    "transferBiometricAuthenticationTitle":
        MessageLookupByLibrary.simpleMessage(
          "Use biometric authentication instead",
        ),
    "transferCardNumberLabel": MessageLookupByLibrary.simpleMessage(
      "Card number",
    ),
    "transferChooseBankLabel": MessageLookupByLibrary.simpleMessage(
      "Choose bank",
    ),
    "transferChooseBeneficiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Choose beneficiary",
    ),
    "transferChooseBranchLabel": MessageLookupByLibrary.simpleMessage(
      "Choose branch",
    ),
    "transferChooseTransactionTitle": MessageLookupByLibrary.simpleMessage(
      "Choose transaction",
    ),
    "transferConfirmButton": MessageLookupByLibrary.simpleMessage("Confirm"),
    "transferConfirmTitle": MessageLookupByLibrary.simpleMessage("Confirm"),
    "transferConfirmTransaction": MessageLookupByLibrary.simpleMessage(
      "Confirm transaction information",
    ),
    "transferContentLabel": MessageLookupByLibrary.simpleMessage("Content"),
    "transferEnterOtpCodeTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter the OTP code",
    ),
    "transferErrorAuthenticationRequired": MessageLookupByLibrary.simpleMessage(
      "Please complete authentication before confirming transfer.",
    ),
    "transferErrorBiometricFailed": MessageLookupByLibrary.simpleMessage(
      "Biometric authentication failed",
    ),
    "transferErrorBiometricUnavailable": MessageLookupByLibrary.simpleMessage(
      "Biometric login not available",
    ),
    "transferErrorCalculateFee": MessageLookupByLibrary.simpleMessage(
      "Failed to calculate transaction fee",
    ),
    "transferErrorNoPendingTransaction": MessageLookupByLibrary.simpleMessage(
      "No pending transfer found to confirm.",
    ),
    "transferErrorOtpInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid OTP. Please try again",
    ),
    "transferErrorTransferFailed": MessageLookupByLibrary.simpleMessage(
      "Transfer failed. Please try again.",
    ),
    "transferFindBeneficiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Find Beneficiary",
    ),
    "transferFormLabel": MessageLookupByLibrary.simpleMessage("Form"),
    "transferGetOtpButton": MessageLookupByLibrary.simpleMessage("Get OTP"),
    "transferGetOtpTransactionTitle": MessageLookupByLibrary.simpleMessage(
      "Get OTP to verify transaction",
    ),
    "transferNameLabel": MessageLookupByLibrary.simpleMessage("Name"),
    "transferNoBeneficiariesFoundTitle": MessageLookupByLibrary.simpleMessage(
      "No beneficiaries found",
    ),
    "transferOtpLabel": MessageLookupByLibrary.simpleMessage("OTP"),
    "transferResendButton": MessageLookupByLibrary.simpleMessage("Resend"),
    "transferSameBankTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer to the same bank",
    ),
    "transferSaveBeneficiaryTitle": MessageLookupByLibrary.simpleMessage(
      "Save to beneficiary directory",
    ),
    "transferSaveDirectoryButton": MessageLookupByLibrary.simpleMessage(
      "Save to directory",
    ),
    "transferSelectBeneficiary": MessageLookupByLibrary.simpleMessage(
      "Choose beneficiary bank",
    ),
    "transferSelectedAccountHint": MessageLookupByLibrary.simpleMessage(
      "Choose account / card",
    ),
    "transferSendOtpToEmailTitle": MessageLookupByLibrary.simpleMessage(
      "OTP has been sent to your email. Please check your inbox",
    ),
    "transferSuccessDescription": MessageLookupByLibrary.simpleMessage(
      "You have successfully transferred \n",
    ),
    "transferSuccessTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer successful!",
    ),
    "transferTitle": MessageLookupByLibrary.simpleMessage("Transfer"),
    "transferToLabel": MessageLookupByLibrary.simpleMessage("To"),
    "transferTransactionFeeLabel": MessageLookupByLibrary.simpleMessage(
      "Transaction fee",
    ),
    "transferViaCardNumberTitle": MessageLookupByLibrary.simpleMessage(
      "Transfer via card number",
    ),
    "validatorConfirmPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Confirm Password is required",
    ),
    "validatorConfirmedPasswordNotMatch": MessageLookupByLibrary.simpleMessage(
      "Password and confirm password not match",
    ),
    "validatorEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Email is required",
    ),
    "validatorEmailWrongFormat": MessageLookupByLibrary.simpleMessage(
      "Email is invalid format",
    ),
    "validatorNameCharacterMinimum": MessageLookupByLibrary.simpleMessage(
      "Name 6-character minimum",
    ),
    "validatorNameRequired": MessageLookupByLibrary.simpleMessage(
      "Name is required",
    ),
    "validatorPasswordCharacterMinimum": MessageLookupByLibrary.simpleMessage(
      "Password 8-character minimum",
    ),
    "validatorPasswordRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "validatorPasswordWrongFormat": MessageLookupByLibrary.simpleMessage(
      "Password is least one uppercase, lowercase letter",
    ),
  };
}
