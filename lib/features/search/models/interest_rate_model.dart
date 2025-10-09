import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest_rate_model.freezed.dart';
part 'interest_rate_model.g.dart';

/// Represents an interest rate for a specific type and period.
///
/// This model contains information about the type of interest rate (e.g., savings),
/// the period for which it is applicable (e.g., 1 month), and the rate itself.
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
