import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';

part 'transfer_state.freezed.dart';

class TransferState extends Equatable {
  const TransferState({
    this.status = const TransferStatus.initial(),
    this.accounts = const [],
    this.beneficiaries = const [],
    this.banks = const [],
    this.selectedAccount,
    this.selectedTransferType = TransferType.cardNumber,
    this.selectedBeneficiary,
    this.amount,
    this.content,
    this.transactionFee = 0.0,
    this.saveToDirectory = false,
    this.errorMessage,
    this.transactionId,
    this.transaction,
  });

  final TransferStatus status;
  final List<Account> accounts;
  final List<Beneficiary> beneficiaries;
  final List<Bank> banks;
  final Account? selectedAccount;
  final TransferType selectedTransferType;
  final Beneficiary? selectedBeneficiary;
  final double? amount;
  final String? content;
  final double transactionFee;
  final bool saveToDirectory;
  final String? errorMessage;
  final String? transactionId;
  final Transaction? transaction;

  @override
  List<Object?> get props => [
    status,
    accounts,
    beneficiaries,
    banks,
    selectedAccount,
    selectedTransferType,
    selectedBeneficiary,
    amount,
    content,
    transactionFee,
    saveToDirectory,
    errorMessage,
    transactionId,
    transaction,
  ];

  TransferState copyWith({
    TransferStatus? status,
    List<Account>? accounts,
    List<Beneficiary>? beneficiaries,
    List<Bank>? banks,
    Account? selectedAccount,
    TransferType? selectedTransferType,
    Beneficiary? selectedBeneficiary,
    double? amount,
    String? content,
    double? transactionFee,
    bool? saveToDirectory,
    String? errorMessage,
    String? transactionId,
    Transaction? transaction,
  }) {
    return TransferState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      banks: banks ?? this.banks,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedTransferType: selectedTransferType ?? this.selectedTransferType,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
      amount: amount ?? this.amount,
      content: content ?? this.content,
      transactionFee: transactionFee ?? this.transactionFee,
      saveToDirectory: saveToDirectory ?? this.saveToDirectory,
      errorMessage: errorMessage,
      transactionId: transactionId ?? this.transactionId,
      transaction: transaction ?? this.transaction,
    );
  }
}

@freezed
sealed class TransferStatus with _$TransferStatus {
  const factory TransferStatus.initial() = TransferStatusInitial;
  const factory TransferStatus.loading() = TransferStatusLoading;
  const factory TransferStatus.success() = TransferStatusSuccess;
  const factory TransferStatus.failure() = TransferStatusFailure;
}
