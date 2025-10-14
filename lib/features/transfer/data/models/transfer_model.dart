import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

/// An enum representing the authentication method for a transfer.
enum AuthMethod { otp, fingerprint, faceId }

/// Represents a transfer transaction.
@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    String? id,
    String? userId,
    AccountModel? fromAccount,
    CardModel? fromCard,
    BeneficiaryModel? toBeneficiary,
    double? amount,
    double? transactionFee,
    String? content,
    required TransferType transferType,
    AuthMethod? authMethod,
    String? otpCode,
    String? transactionId,
    @Default(false) bool saveToDirectory,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}

/// Represents a request to initiate a transfer.
@freezed
class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    required double amount,
    required TransferType transferType,
    required BeneficiaryModel toBeneficiary,
  }) = _TransferRequest;

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);
}

/// Represents the fee for a transfer.
@freezed
class TransferFee with _$TransferFee {
  const factory TransferFee({
    required double amount,
    required double fee,
    required double total,
  }) = _TransferFee;

  factory TransferFee.fromJson(Map<String, dynamic> json) =>
      _$TransferFeeFromJson(json);
}
