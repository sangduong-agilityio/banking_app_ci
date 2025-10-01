import 'package:banking_app/core/widgets/assets.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionStatus { pending, completed, failed, cancelled }

enum TransferType { cardNumber, sameBank, otherBank }

enum TransactionCategory { electric, water, internet }

enum TransactionDisplayType { transfer, electric, water, internet }

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

/// Extension cho TransferType
extension TransferTypeExtension on TransferType {
  String get label {
    switch (this) {
      case TransferType.cardNumber:
        return 'Card Number';
      case TransferType.sameBank:
        return 'Same Bank';
      case TransferType.otherBank:
        return 'Other Bank';
    }
  }
}

/// Extension on TransactionCategory to provide UI properties
extension TransactionCategoryExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.electric:
        return const Color(0xFF0890FE);
      case TransactionCategory.water:
        return const Color(0xFF3629B7);
      case TransactionCategory.internet:
        return const Color(0xFF52D5BA);
    }
  }

  /// Icon widget for category
  Widget get iconWidget {
    switch (this) {
      case TransactionCategory.electric:
        return BAAssets.electricBill();
      case TransactionCategory.water:
        return BAAssets.waterBill();
      case TransactionCategory.internet:
        return BAAssets.internetBill();
    }
  }

  /// Label for category
  String get label {
    switch (this) {
      case TransactionCategory.electric:
        return 'Electric Bill';
      case TransactionCategory.water:
        return 'Water Bill';
      case TransactionCategory.internet:
        return 'Internet Bill';
    }
  }
}

/// Extension on TransactionDisplayType to provide UI properties
extension TransactionDisplayTypeExtension on TransactionDisplayType {
  Color get color {
    switch (this) {
      case TransactionDisplayType.transfer:
        return const Color(0xFFFF4267);
      case TransactionDisplayType.electric:
        return const Color(0xFF0890FE);
      case TransactionDisplayType.water:
        return const Color(0xFF3629B7);
      case TransactionDisplayType.internet:
        return const Color(0xFF52D5BA);
    }
  }

  /// Icon widget for display type
  Widget get iconWidget {
    switch (this) {
      case TransactionDisplayType.transfer:
        return BAAssets.transferMoneyBill();
      case TransactionDisplayType.electric:
        return BAAssets.electricBill();
      case TransactionDisplayType.water:
        return BAAssets.waterBill();
      case TransactionDisplayType.internet:
        return BAAssets.internetBill();
    }
  }

  /// Label for display type
  String get label {
    switch (this) {
      case TransactionDisplayType.transfer:
        return 'Transfer';
      case TransactionDisplayType.electric:
        return 'Electric Bill';
      case TransactionDisplayType.water:
        return 'Water Bill';
      case TransactionDisplayType.internet:
        return 'Internet Bill';
    }
  }
}

/// Extension on TransactionModel to provide computed properties for UI
extension TransactionModelExtension on TransactionModel {
  TransactionDisplayType get displayType {
    if (category != null) {
      switch (category!) {
        case TransactionCategory.electric:
          return TransactionDisplayType.electric;
        case TransactionCategory.water:
          return TransactionDisplayType.water;
        case TransactionCategory.internet:
          return TransactionDisplayType.internet;
      }
    }

    return TransactionDisplayType.transfer;
  }

  Color get displayColor => displayType.color;

  Widget get displayIcon => displayType.iconWidget;

  String get displayTitle => displayType.label;

  String get displaySubtitle {
    if (displayType == TransactionDisplayType.transfer) {
      return type.label;
    }

    return description ?? recipientName ?? recipientAccount ?? '';
  }

  bool get isTransfer => category == null;

  bool get isBillPayment => category != null;
}
