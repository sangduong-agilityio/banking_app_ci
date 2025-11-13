import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:equatable/equatable.dart';

import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/data/models/branch_model.dart';

/// The base class for all events related to the transfer feature.
abstract class TransferEvt extends Equatable {
  const TransferEvt();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the transfer screen.
class TransferInitializeEvt extends TransferEvt {}

/// Event to initialize the beneficiaries screen.
class BeneficiariesInitializeEvt extends TransferEvt {
  const BeneficiariesInitializeEvt({
    required this.beneficiaries,
    required this.banks,
  });

  final List<BeneficiaryModel> beneficiaries;
  final List<BankModel> banks;

  @override
  List<Object?> get props => [beneficiaries, banks];
}

/// Event triggered when the user selects an account.
class SelectAccountEvt extends TransferEvt {
  const SelectAccountEvt(this.account);

  final AccountModel account;

  @override
  List<Object> get props => [account];
}

/// Event triggered when the user selects a card.
class SelectCardEvt extends TransferEvt {
  const SelectCardEvt(this.card);

  final CardModel card;

  @override
  List<Object> get props => [card];
}

/// Event triggered when the user selects a transfer type.
class SelectTransferTypeEvt extends TransferEvt {
  const SelectTransferTypeEvt(this.transferType);

  final TransferType transferType;

  @override
  List<Object> get props => [transferType];
}

/// Event triggered when the user selects a beneficiary.
class SelectBeneficiaryEvt extends TransferEvt {
  const SelectBeneficiaryEvt(this.beneficiary);

  final BeneficiaryModel beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

/// Event triggered when the user selects a bank.
class SelectBankEvt extends TransferEvt {
  const SelectBankEvt(this.bank);

  final BankModel bank;

  @override
  List<Object> get props => [bank];
}

/// Event triggered when the user selects a branch.
class SelectBranchEvt extends TransferEvt {
  const SelectBranchEvt(this.branch);

  final BranchModel branch;

  @override
  List<Object> get props => [branch];
}

/// Event to update the transfer details.
class UpdateTransferDetailsEvt extends TransferEvt {
  const UpdateTransferDetailsEvt({
    this.amount,
    this.content,
    this.name,
    this.saveToDirectory,
    this.cardNumber,
    this.bank,
    this.branch,
    this.avatarUrl,
    this.clearForm,
  });

  final String? name;
  final String? cardNumber;
  final double? amount;
  final String? content;
  final bool? saveToDirectory;
  final BankModel? bank;
  final BranchModel? branch;
  final String? avatarUrl;
  final bool? clearForm;

  @override
  List<Object?> get props => [
    amount,
    content,
    saveToDirectory,
    cardNumber,
    bank,
    name,
    avatarUrl,
    branch,
    clearForm,
  ];
}

/// Event to fill the transfer details.
class FillTransferDetailsEvt extends TransferEvt {
  const FillTransferDetailsEvt({required this.amount, required this.content});

  final double amount;
  final String content;

  @override
  List<Object> get props => [amount, content];
}

/// Event to add a new beneficiary.
class AddNewBeneficiaryEvt extends TransferEvt {
  const AddNewBeneficiaryEvt(this.beneficiary);

  final BeneficiaryModel beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

/// Event to search for a beneficiary.
class SearchBeneficiaryEvt extends TransferEvt {
  const SearchBeneficiaryEvt(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to calculate the transaction fee.
class CalculateTransactionFeeEvt extends TransferEvt {}

/// Event to confirm the transfer.
class ConfirmTransferEvt extends TransferEvt {
  const ConfirmTransferEvt({this.beneficiary});

  final BeneficiaryModel? beneficiary;

  @override
  List<Object?> get props => [beneficiary];
}

/// Event to send an OTP.
class SendOtpEvt extends TransferEvt {
  const SendOtpEvt({required this.transferId});

  final String transferId;

  @override
  List<Object?> get props => [transferId];
}

/// Event to confirm the transfer with an OTP.
class ConfirmTransferWithOtpEvt extends TransferEvt {
  const ConfirmTransferWithOtpEvt({
    required this.otpCode,
    required this.transferId,
  });

  final String otpCode;
  final String transferId;

  @override
  List<Object?> get props => [otpCode, transferId];
}

/// Event to confirm the transfer with biometrics.
class ConfirmWithBiometricEvt extends TransferEvt {
  const ConfirmWithBiometricEvt();

  @override
  List<Object?> get props => [];
}

/// Event triggered when the OTP value changes.
class OtpChangedEvt extends TransferEvt {
  const OtpChangedEvt(this.otp);

  final String otp;

  @override
  List<Object> get props => [otp];
}

/// Event to clear the error message.
class BiometricErrorMessageEvt extends TransferEvt {
  const BiometricErrorMessageEvt();

  @override
  List<Object?> get props => [];
}

/// Event to reorder beneficiaries.
class ReorderBeneficiaryEvt extends TransferEvt {
  const ReorderBeneficiaryEvt({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

