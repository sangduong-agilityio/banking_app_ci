import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionStatus { pending, completed, failed, cancelled }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required TransferType type,
    required double amount,
    @JsonKey(name: 'from_account_id') String? fromAccountId,
    @JsonKey(name: 'to_beneficiary_id') String? toBeneficiaryId,
    String? recipientName,
    String? recipientAccount,
    String? description,
    @Default(TransactionStatus.pending) TransactionStatus status,
    @JsonKey(name: 'transaction_fee') double? transactionFee,
    String? referenceNumber,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
