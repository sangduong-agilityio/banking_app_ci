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
    required String address,
    required String phoneNumber,
    required String billCode,
    required String startDate,
    required String endDate,
    required double amount,
    required double tax,
    DateTime? dueDate,
    required bool isRecurring,
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BillModel;

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);
}

enum BillType { water, internet, electric }

extension BillTypeExtension on BillType {
  String get displayName {
    switch (this) {
      case BillType.water:
        return "Water bill";
      case BillType.internet:
        return "Internet bill";
      case BillType.electric:
        return "Electric bill";
    }
  }
}
