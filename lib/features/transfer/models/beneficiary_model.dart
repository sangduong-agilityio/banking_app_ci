import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'beneficiary_model.freezed.dart';
part 'beneficiary_model.g.dart';

@freezed
class BeneficiaryModel with _$BeneficiaryModel {
  const factory BeneficiaryModel({
    required String? id,
    required String name,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'bank_id') String? bankId,
    String? bankName,
    String? branch,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    TransferType? transferType,
  }) = _BeneficiaryModel;

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryModelFromJson(json);
}
