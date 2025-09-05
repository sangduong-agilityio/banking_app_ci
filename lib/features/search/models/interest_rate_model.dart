import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_rate_model.freezed.dart';
part 'interest_rate_model.g.dart';

@freezed
class InterestRateModel with _$InterestRateModel {
  const factory InterestRateModel({
    required String type,
    required String period,
    required String rate,
  }) = _InterestRate;
  factory InterestRateModel.fromJson(Map<String, dynamic> json) =>
      _$InterestRateModelFromJson(json);
}
