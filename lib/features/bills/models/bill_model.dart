import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_model.freezed.dart';
part 'bill_model.g.dart';

@freezed
class BillModel with _$BillModel {
  const factory BillModel({
    required String id,
    required String userId,
    required BillType billType,
    required String providerName,
    required String accountNumber,
    double? amount,
    DateTime? dueDate,
    required bool isRecurring,
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BillModel;

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);
}

enum BillType { water, internet, electric, gas, phone, other }
