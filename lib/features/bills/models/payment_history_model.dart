// Payment History Model
import 'package:banking_app/app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_history_model.freezed.dart';
part 'payment_history_model.g.dart';

@freezed
class PaymentHistoryModel with _$PaymentHistoryModel {
  const factory PaymentHistoryModel({
    required String id,
    required String billId,
    required String userId,
    required double amount,
    required DateTime paymentDate,
    required PaymentStatus status,
    required String providerName,
    String? transactionId,
  }) = _PaymentHistoryModel;

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryModelFromJson(json);
}

enum PaymentStatus {
  successful('Successful', BAAppColors.secondary),
  unsuccessfully('Unsuccessfully', BAAppColors.error),
  pending('Pending', BAAppColors.warning);

  final String displayName;
  final Color color;

  const PaymentStatus(this.displayName, this.color);
}
