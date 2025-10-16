import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/data/models/branch_model.dart';
import 'package:banking_app/features/transfer/data/models/transfer_model.dart';

part 'transfer_state.freezed.dart';

/// Represents the state of the transfer feature.
class TransferState extends Equatable {
  const TransferState({
    this.status = const TransferStatus.initial(),
    this.accounts = const [],
    this.cards = const [],
    this.beneficiaries = const [],
    this.banks = const [],
    this.branches = const [],
    this.filteredBeneficiaries = const [],
    this.sameBankBeneficiaries = const [],
    this.otherBankBeneficiaries = const [],
    this.viaCardBeneficiaries = const [],
    this.disabledBeneficiaries = const {},
    this.selectedAccount,
    this.selectedCard,
    this.selectedTransferType = TransferType.cardNumber,
    this.selectedBeneficiary,
    this.selectedBank,
    this.selectedBranch,
    this.amount,
    this.cardNumber,
    this.content,
    this.transactionFee = 0.0,
    this.transactionLimit,
    this.saveToDirectory = false,
    this.transferId,
    this.transaction,
    this.newBeneficiary,
    this.searchQuery = '',
    this.avatarUrl,
    this.name,
    this.authMethod,
    this.biometricAvailable = false,
    this.biometricEnabled = false,
    this.biometricAuthenticated = false,
    this.isOtpVerified = false,
    this.otpSent = false,
    this.errorMessage,
    this.otp,
    this.clearName = false,
    this.clearAvatar = false,
    this.clearForm = false,
  });

  final TransferStatus status;
  final List<AccountModel> accounts;
  final List<CardModel> cards;
  final List<BeneficiaryModel> beneficiaries;
  final List<BankModel> banks;
  final List<BranchModel> branches;
  final AccountModel? selectedAccount;
  final CardModel? selectedCard;
  final TransferType selectedTransferType;
  final BeneficiaryModel? selectedBeneficiary;
  final BankModel? selectedBank;
  final BranchModel? selectedBranch;
  final double? amount;
  final String? content;
  final double transactionFee;
  final double? transactionLimit;
  final bool saveToDirectory;
  final String? transferId;
  final TransactionModel? transaction;
  final BeneficiaryModel? newBeneficiary;
  final String searchQuery;
  final List<BeneficiaryModel> filteredBeneficiaries;
  final List<BeneficiaryModel> sameBankBeneficiaries;
  final List<BeneficiaryModel> otherBankBeneficiaries;
  final List<BeneficiaryModel> viaCardBeneficiaries;
  final Map<String, String> disabledBeneficiaries;
  final String? avatarUrl;
  final String? name;
  final String? cardNumber;
  final AuthMethod? authMethod;
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool biometricAuthenticated;
  final bool isOtpVerified;
  final bool otpSent;
  final String? otp;
  final String? errorMessage;
  final bool clearName;
  final bool clearAvatar;
  final bool clearForm;

  TransferState copyWith({
    TransferStatus? status,
    List<AccountModel>? accounts,
    List<CardModel>? cards,
    List<BeneficiaryModel>? beneficiaries,
    AuthMethod? authMethod,
    List<BankModel>? banks,
    List<BranchModel>? branches,
    AccountModel? selectedAccount,
    CardModel? selectedCard,
    bool clearAccount = false,
    bool clearCard = false,
    bool clearTransferType = false,
    bool clearBeneficiary = false,
    TransferType? selectedTransferType,
    BeneficiaryModel? selectedBeneficiary,
    BeneficiaryModel? newBeneficiary,
    double? amount,
    String? content,
    String? avatarUrl,
    String? name,
    String? cardNumber,
    double? transactionFee,
    double? transactionLimit,
    bool? saveToDirectory,
    String? errorMessage,
    BankModel? selectedBank,
    BranchModel? selectedBranch,
    String? transferId,
    TransactionModel? transaction,
    String? searchQuery,
    List<BeneficiaryModel>? filteredBeneficiaries,
    List<BeneficiaryModel>? sameBankBeneficiaries,
    List<BeneficiaryModel>? otherBankBeneficiaries,
    List<BeneficiaryModel>? viaCardBeneficiaries,
    Map<String, String>? disabledBeneficiaries,
    bool? biometricAvailable,
    bool? biometricEnabled,
    bool? biometricAuthenticated,
    bool? isOtpVerified,
    bool? otpSent,
    String? otp,
    bool? clearName,
    bool? clearAvatar,
    bool? clearForm,
  }) {
    return TransferState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      cards: cards ?? this.cards,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      newBeneficiary: newBeneficiary ?? this.newBeneficiary,
      banks: banks ?? this.banks,
      branches: branches ?? this.branches,
      authMethod: authMethod ?? this.authMethod,
      selectedAccount: clearAccount
          ? null
          : (selectedAccount ?? this.selectedAccount),
      selectedCard: clearCard ? null : (selectedCard ?? this.selectedCard),
      selectedTransferType: clearTransferType
          ? TransferType.cardNumber
          : selectedTransferType ?? this.selectedTransferType,
      selectedBeneficiary: clearBeneficiary
          ? null
          : selectedBeneficiary ?? this.selectedBeneficiary,
      amount: amount ?? this.amount,
      content: content ?? this.content,
      transactionFee: transactionFee ?? this.transactionFee,
      transactionLimit: transactionLimit ?? this.transactionLimit,
      saveToDirectory: saveToDirectory ?? this.saveToDirectory,
      errorMessage: errorMessage,
      transferId: transferId ?? this.transferId,
      transaction: transaction ?? this.transaction,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredBeneficiaries:
          filteredBeneficiaries ?? this.filteredBeneficiaries,
      sameBankBeneficiaries:
          sameBankBeneficiaries ?? this.sameBankBeneficiaries,
      otherBankBeneficiaries:
          otherBankBeneficiaries ?? this.otherBankBeneficiaries,
      viaCardBeneficiaries: viaCardBeneficiaries ?? this.viaCardBeneficiaries,
      disabledBeneficiaries:
          disabledBeneficiaries ?? this.disabledBeneficiaries,
      selectedBank: selectedBank ?? this.selectedBank,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      name: name ?? this.name,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAuthenticated:
          biometricAuthenticated ?? this.biometricAuthenticated,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      otpSent: otpSent ?? this.otpSent,
      otp: otp ?? this.otp,
      clearName: clearName ?? this.clearName,
      clearAvatar: clearAvatar ?? this.clearAvatar,
      clearForm: clearForm ?? this.clearForm,
      cardNumber: cardNumber ?? this.cardNumber,
    );
  }

  @override
  List<Object?> get props => [
    status,
    accounts,
    cardNumber,
    cards,
    beneficiaries,
    newBeneficiary,
    banks,
    branches,
    selectedAccount,
    selectedCard,
    selectedTransferType,
    authMethod,
    selectedBeneficiary,
    amount,
    content,
    transactionFee,
    transactionLimit,
    saveToDirectory,
    errorMessage,
    transferId,
    avatarUrl,
    name,
    transaction,
    searchQuery,
    selectedBank,
    selectedBranch,
    filteredBeneficiaries,
    sameBankBeneficiaries,
    otherBankBeneficiaries,
    viaCardBeneficiaries,
    disabledBeneficiaries,
    biometricAvailable,
    biometricEnabled,
    biometricAuthenticated,
    isOtpVerified,
    otpSent,
    otp,
    clearName,
    clearAvatar,
    clearForm,
  ];

  /// Whether the user can use biometrics for authentication.
  bool get canUseBiometrics => biometricAvailable && biometricEnabled;

  /// Whether the user has been authenticated.
  bool get isAuthenticated => biometricAuthenticated;

  /// Whether the user can confirm the transfer.
  bool get canConfirmTransfer {
    return (selectedAccount != null || selectedCard != null) &&
        selectedBeneficiary != null &&
        amount != null &&
        amount! > 0;
  }

  /// Whether the entered OTP is valid.
  bool get isOtpValid => otp?.length == 6;
}

/// Represents the status of the transfer process.
@freezed
sealed class TransferStatus with _$TransferStatus {
  /// The initial status.
  const factory TransferStatus.initial() = TransferStatusInitial;

  /// The loading status.
  const factory TransferStatus.loading() = TransferStatusLoading;

  /// The status when the app is awaiting OTP verification.
  const factory TransferStatus.awaitingOtp() = TransferStatusAwaitingOtp;

  /// The status when the app is awaiting biometric authentication.
  const factory TransferStatus.awaitingBiometric() =
      TransferStatusAwaitingBiometric;

  /// The success status.
  const factory TransferStatus.success() = TransferStatusSuccess;

  /// The failure status.
  const factory TransferStatus.failure() = TransferStatusFailure;
}
