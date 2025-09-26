import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

enum AuthMethod { otp, fingerprint, faceId }

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    String? id,
    @JsonKey(name: 'user_id') String? userId,
    AccountModel? fromAccount,
    CardModel? fromCard,
    BeneficiaryModel? toBeneficiary,
    double? amount,
    double? transactionFee,
    String? content,
    required TransferType transferType,
    AuthMethod? authMethod,
    String? otpCode,
    @Default(false) bool saveToDirectory,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}

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
