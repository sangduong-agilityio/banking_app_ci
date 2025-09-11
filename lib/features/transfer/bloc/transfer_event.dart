import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransferEvt extends Equatable {
  const TransferEvt();

  @override
  List<Object?> get props => [];
}

class TransferInitializeEvt extends TransferEvt {}

class SelectAccountEvt extends TransferEvt {
  final Account account;
  const SelectAccountEvt(this.account);

  @override
  List<Object> get props => [account];
}

class SelectTransferTypeEvt extends TransferEvt {
  final TransferType transferType;
  const SelectTransferTypeEvt(this.transferType);

  @override
  List<Object> get props => [transferType];
}

class SelectBeneficiaryEvt extends TransferEvt {
  final Beneficiary beneficiary;
  const SelectBeneficiaryEvt(this.beneficiary);

  @override
  List<Object> get props => [beneficiary];
}

class AddNewBeneficiaryEvt extends TransferEvt {
  final Beneficiary beneficiary;
  const AddNewBeneficiaryEvt(this.beneficiary);

  @override
  List<Object> get props => [beneficiary];
}

class UpdateTransferFormEvt extends TransferEvt {
  final String? recipientName;
  final String? cardNumber;
  final double? amount;
  final String? content;
  final bool? saveToDirectory;

  const UpdateTransferFormEvt({
    this.amount,
    this.content,
    this.recipientName,
    this.saveToDirectory,
    this.cardNumber,
  });

  @override
  List<Object?> get props => [
    amount,
    content,
    saveToDirectory,
    cardNumber,
    content,
  ];
}

class CalculateTransactionFeeEvt extends TransferEvt {}

class InitiateTransfer extends TransferEvt {}

class VerifyOTPEvt extends TransferEvt {
  final String otpCode;
  const VerifyOTPEvt(this.otpCode);

  @override
  List<Object> get props => [otpCode];
}

class AuthenticateWithBiometricsEvt extends TransferEvt {}

class AuthenticateWithFaceIdEvt extends TransferEvt {}

class ConfirmTransferEvt extends TransferEvt {}

class ResetTransferEvt extends TransferEvt {}
