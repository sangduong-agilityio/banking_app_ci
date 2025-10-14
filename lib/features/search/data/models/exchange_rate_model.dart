import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate_model.freezed.dart';
part 'exchange_rate_model.g.dart';

/// Represents an exchange rate for a specific country.
///
/// This model contains information about the country, its flag, and the buy/sell
/// rates for its currency.
@freezed
class ExchangeRateModel with _$ExchangeRateModel {
  const factory ExchangeRateModel({
    required String country,
    required String flag,
    required String buy,
    required String sell,
  }) = _ExchangeRate;

  /// Creates an [ExchangeRateModel] from a JSON object.
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);
}
