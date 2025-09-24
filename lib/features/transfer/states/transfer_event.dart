import 'package:equatable/equatable.dart';

import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';

abstract class TransferEvt extends Equatable {
  const TransferEvt();

  @override
  List<Object?> get props => [];
}

class TransferInitializeEvt extends TransferEvt {}

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

class ResetTransferEvt extends TransferEvt {}

class SelectAccountEvt extends TransferEvt {
  const SelectAccountEvt(this.account);
  final AccountModel account;

  @override
  List<Object> get props => [account];
}

class SelectCardEvt extends TransferEvt {
  const SelectCardEvt(this.card);
  final CardModel card;

  @override
  List<Object> get props => [card];
}

class SelectTransferTypeEvt extends TransferEvt {
  const SelectTransferTypeEvt(this.transferType);
  final TransferType transferType;

  @override
  List<Object> get props => [transferType];
}

class SelectBeneficiaryEvt extends TransferEvt {
  const SelectBeneficiaryEvt(this.beneficiary);
  final BeneficiaryModel beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

class SelectBankEvt extends TransferEvt {
  const SelectBankEvt(this.bank);
  final BankModel bank;

  @override
  List<Object> get props => [bank];
}

class SelectBranchEvt extends TransferEvt {
  const SelectBranchEvt(this.branch);
  final BranchModel branch;

  @override
  List<Object> get props => [branch];
}

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
  });

  final String? name;
  final String? cardNumber;
  final double? amount;
  final String? content;
  final bool? saveToDirectory;
  final BankModel? bank;
  final BranchModel? branch;
  final String? avatarUrl;

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
  ];
}

class FillTransferDetailsEvt extends TransferEvt {
  final double amount;
  final String content;

  const FillTransferDetailsEvt({required this.amount, required this.content});

  @override
  List<Object> get props => [amount, content];
}

class AddNewBeneficiaryEvt extends TransferEvt {
  const AddNewBeneficiaryEvt(this.beneficiary);
  final BeneficiaryModel beneficiary;

  @override
  List<Object> get props => [beneficiary];
}

class SearchBeneficiaryEvt extends TransferEvt {
  final String query;
  const SearchBeneficiaryEvt(this.query);

  @override
  List<Object?> get props => [query];
}

class CalculateTransactionFeeEvt extends TransferEvt {}

class ConfirmTransferEvt extends TransferEvt {
  const ConfirmTransferEvt({this.beneficiary});
  final BeneficiaryModel? beneficiary;

  @override
  List<Object?> get props => [beneficiary];
}

class SendOtpEvt extends TransferEvt {
  const SendOtpEvt({required this.transferId});

  final String transferId;
  @override
  List<Object?> get props => [transferId];
}

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

class ConfirmWithBiometricEvt extends TransferEvt {
  const ConfirmWithBiometricEvt();

  @override
  List<Object?> get props => [];
}
