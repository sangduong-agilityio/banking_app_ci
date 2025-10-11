import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String userId,
    required String id,
    required String accountNumber,
    required double availableBalance,
    required String branch,
    required String accountType,
    DateTime? fromDate,
    DateTime? toDate,
    double? interestRate,
    required String bankId,
    String? term,
    @Default(AccountStatus.active) AccountStatus? status,
  }) = _AccountModel;
  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

enum AccountStatus { active, frozen, expired }
