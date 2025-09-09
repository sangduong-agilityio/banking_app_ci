import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_model.freezed.dart';
part 'exchange_model.g.dart';

@freezed
class ExchangeModel with _$ExchangeModel {
  const factory ExchangeModel({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
    required double toAmount,
    required double rate,
  }) = _ExchangeModel;
  factory ExchangeModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeModelFromJson(json);
}
