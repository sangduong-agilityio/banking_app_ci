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
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'company_id') String? companyId,
    @JsonKey(name: 'bill_type', unknownEnumValue: BillType.electric)
    BillType? billType,
    @JsonKey(name: 'bill_code') String? billCode,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    String? address,
    double? amount,
    double? tax,
    double? fee,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'otp_code') String? otpCode,
    @JsonKey(name: 'company') CompanyModel? company,
    @JsonKey(name: 'fromAccount') AccountModel? fromAccount,
    @JsonKey(name: 'fromCard') CardModel? fromCard,
  }) = _BillPaymentModel;

  factory BillPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$BillPaymentModelFromJson(json);
}
