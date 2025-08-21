import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String userId,
    required TransactionType type,
    required double amount,
    String? imageUrl,
    String? recipientName,
    String? recipientAccount,
    String? description,
    required TransactionStatus status,
    String? referenceNumber,
    required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

enum TransactionType { transfer, billPayment, deposit, withdrawal }

enum TransactionStatus { pending, completed, failed, refunded }
