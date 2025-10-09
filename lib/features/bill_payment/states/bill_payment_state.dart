import 'package:equatable/equatable.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_payment_state.freezed.dart';

/// Represents the state of the bill payment feature.
class BillPaymentState extends Equatable {
  const BillPaymentState({
    this.status = const BillPaymentStatus.initial(),
    this.bills = const [],
    this.companies = const [],
    this.accounts = const [],
    this.cards = const [],
    this.selectedCompany,
    this.selectedAccount,
    this.selectedCard,
    this.amount,
    this.fee,
    this.otpSent = false,
    this.isOtpVerified = false,
    this.clearAccount = false,
    this.clearCard = false,
    this.errorMessage,
    this.transactionId,
    this.selectedBill,
    this.billCode,
    this.phoneNumber,
    this.otpCode,
    this.billId,
  });

  final BillPaymentStatus status;
  final List<BillPaymentModel> bills;
  final List<CompanyModel> companies;
  final BillPaymentModel? selectedBill;
  final CompanyModel? selectedCompany;
  final List<AccountModel> accounts;
  final List<CardModel> cards;
  final AccountModel? selectedAccount;
  final CardModel? selectedCard;
  final double? amount;
  final double? fee;
  final bool otpSent;
  final String? billCode;
  final String? billId;
  final String? phoneNumber;
  final bool isOtpVerified;
  final String? errorMessage;
  final String? transactionId;
  final String? otpCode;
  final bool clearAccount;
  final bool clearCard;

  BillPaymentState copyWith({
    BillPaymentStatus? status,
    List<BillPaymentModel>? bills,
    List<CompanyModel>? companies,
    List<AccountModel>? accounts,
    List<CardModel>? cards,
    AccountModel? selectedAccount,
    CardModel? selectedCard,
    CompanyModel? selectedCompany,
    double? amount,
    double? fee,
    bool? otpSent,
    String? billId,
    bool? isOtpVerified,
    bool? clearAccount,
    bool? clearCard,
    String? errorMessage,
    String? transactionId,
    BillPaymentModel? selectedBill,
    String? billCode,
    String? phoneNumber,
    String? otpCode,
  }) {
    return BillPaymentState(
      status: status ?? this.status,
      bills: bills ?? this.bills,
      companies: companies ?? this.companies,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedCard: selectedCard ?? this.selectedCard,
      amount: amount ?? this.amount,
      accounts: accounts ?? this.accounts,
      cards: cards ?? this.cards,
      billId: billId ?? this.billId,
      fee: fee ?? this.fee,
      otpSent: otpSent ?? this.otpSent,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      transactionId: transactionId ?? this.transactionId,
      selectedBill: selectedBill ?? this.selectedBill,
      billCode: billCode ?? this.billCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      clearAccount: clearAccount ?? this.clearAccount,
      clearCard: clearCard ?? this.clearCard,
      otpCode: otpCode ?? this.otpCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bills,
    companies,
    selectedCompany,
    selectedAccount,
    selectedCard,
    accounts,
    billId,
    cards,
    amount,
    fee,
    otpSent,
    isOtpVerified,
    transactionId,
    selectedBill,
    billCode,
    phoneNumber,
    clearAccount,
    clearCard,
    otpCode,
    errorMessage,
  ];
}

/// Represents the different statuses of the bill payment process.
@freezed
class BillPaymentStatus with _$BillPaymentStatus {
  /// The initial state.
  const factory BillPaymentStatus.initial() = BillPaymentStatusInitial;

  /// The state when data is being loaded.
  const factory BillPaymentStatus.loading() = BillPaymentStatusLoading;

  /// The state when data has been successfully loaded.
  const factory BillPaymentStatus.loaded() = BillPaymentStatusLoaded;

  /// The state when the application is waiting for OTP verification.
  const factory BillPaymentStatus.awaitingOtp() = BillPaymentStatusAwaitingOtp;

  /// The state when the payment is successful.
  const factory BillPaymentStatus.success() = BillPaymentStatusSuccess;

  /// The state when an error has occurred.
  const factory BillPaymentStatus.failure() = BillPaymentStatusFailure;
}
