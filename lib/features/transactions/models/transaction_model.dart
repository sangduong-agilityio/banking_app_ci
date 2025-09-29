import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionStatus { pending, completed, failed, cancelled }

enum TransferType { cardNumber, sameBank, otherBank, billPayment }

enum TransactionCategory { transfer, electric, water, internet }

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String userId,
    required TransferType type,
    required double amount,
    String? fromAccount,
    String? fromCardId,
    String? toBeneficiary,
    String? recipientName,
    String? recipientAccount,
    String? description,
    @Default(TransactionStatus.pending) TransactionStatus status,
    double? transactionFee,
    String? referenceNumber,
    DateTime? createdAt,
    DateTime? completedAt,

    TransactionCategory? category,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionCategoryExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.transfer:
        return const Color(0xFFFF4267);
      case TransactionCategory.electric:
        return const Color(0xFF0890FE);
      case TransactionCategory.water:
        return const Color(0xFF3629B7);
      case TransactionCategory.internet:
        return const Color(0xFF52D5BA);
    }
  }

  Widget get iconWidget {
    switch (this) {
      case TransactionCategory.transfer:
        return BAAssets.transferMoneyBill();
      case TransactionCategory.electric:
        return BAAssets.electricBill();
      case TransactionCategory.water:
        return BAAssets.waterBill();
      case TransactionCategory.internet:
        return BAAssets.internetBill();
    }
  }
}
