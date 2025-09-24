import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'available_balance') required double availableBalance,
    required String branch,
    @JsonKey(name: 'account_type') required String accountType,
    @JsonKey(name: 'from_date') DateTime? fromDate,
    @JsonKey(name: 'to_date') DateTime? toDate,
    @JsonKey(name: 'interest_rate') double? interestRate,
    @JsonKey(name: 'bank_id') required String bankId,
    String? term,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}
