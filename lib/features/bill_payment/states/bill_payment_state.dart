import 'package:equatable/equatable.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_payment_state.freezed.dart';

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

@freezed
class BillPaymentStatus with _$BillPaymentStatus {
  const factory BillPaymentStatus.initial() = BillPaymentStatusInitial;
  const factory BillPaymentStatus.loading() = BillPaymentStatusLoading;
  const factory BillPaymentStatus.loaded() = BillPaymentStatusLoaded;
  const factory BillPaymentStatus.awaitingOtp() = BillPaymentStatusAwaitingOtp;
  const factory BillPaymentStatus.success() = BillPaymentStatusSuccess;
  const factory BillPaymentStatus.failure() = BillPaymentStatusFailure;
}
