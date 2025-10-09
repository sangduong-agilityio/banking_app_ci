import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_model.freezed.dart';
part 'exchange_model.g.dart';

/// Represents the result of a currency exchange.
///
/// This model contains information about the source and target currencies,
/// the amount being converted, the resulting amount, and the exchange rate used.
@freezed
class ExchangeModel with _$ExchangeModel {
  const factory ExchangeModel({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
    required double toAmount,
    required double rate,
  }) = _ExchangeModel;

  /// Creates an [ExchangeModel] from a JSON object.
  factory ExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeModelFromJson(json);
}
