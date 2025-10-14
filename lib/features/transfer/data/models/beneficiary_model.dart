import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'beneficiary_model.freezed.dart';
part 'beneficiary_model.g.dart';

/// Represents a beneficiary for a transfer.
@freezed
class BeneficiaryModel with _$BeneficiaryModel {
  const factory BeneficiaryModel({
    required String? id,
    required String name,
    required String accountNumber,
    String? bankId,
    String? bankName,
    String? branch,
    String? avatarUrl,
    TransferType? transferType,
  }) = _BeneficiaryModel;

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryModelFromJson(json);
}
