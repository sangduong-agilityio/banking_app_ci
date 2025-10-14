import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

/// Represents a currency with its code and name.
///
/// This model is used to store information about a currency, such as its
/// three-letter code (e.g., \"USD\") and its full name (e.g., \"United States Dollar\").
@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({required String code, required String name}) =
      _CurrencyModel;
  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);
}
