import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_payment_model.freezed.dart';
part 'bill_payment_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum BillType {
  @JsonValue("water")
  water,

  @JsonValue("internet")
  internet,

  @JsonValue("electric")
  electric,
}

extension BillTypeExtension on BillType {
  String get displayName {
    switch (this) {
      case BillType.water:
        return "Water Bill";
      case BillType.internet:
        return "Internet Bill";
      case BillType.electric:
        return "Electric Bill";
    }
  }
}

@freezed
class BillPaymentModel with _$BillPaymentModel {
  const factory BillPaymentModel({
    String? id,
    String? userId,
    String? companyId,
    @Default(BillType.electric) BillType? billType,
    String? billCode,
    String? phoneNumber,
    String? address,
    double? amount,
    double? tax,
    double? fee,
    DateTime? startDate,
    DateTime? endDate,
    String? otpCode,
    CompanyModel? company,
    AccountModel? fromAccount,
    CardModel? fromCard,
    String? transactionId,
  }) = _BillPaymentModel;

  factory BillPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$BillPaymentModelFromJson(json);
}
