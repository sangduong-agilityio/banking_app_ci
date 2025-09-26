import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_summary_model.freezed.dart';
part 'balance_summary_model.g.dart';

@freezed
class BalanceSummaryModel with _$BalanceSummaryModel {
  const factory BalanceSummaryModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int year,
    required int month,
    @JsonKey(name: 'total_income') required double totalIncome,
    @JsonKey(name: 'total_expense') required double totalExpense,
    @JsonKey(name: 'ending_balance') required double endingBalance,
    @JsonKey(name: 'transaction_count') required int transactionCount,
    @JsonKey(name: 'recorded_at') required DateTime recordedAt,
  }) = _BalanceSummaryModel;

  factory BalanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceSummaryModelFromJson(json);
}

@freezed
class ChartData with _$ChartData {
  const factory ChartData({
    required String month,
    required double balance,
    required double income,
    required double expense,
    @Default(false) bool isCurrentMonth,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);
}
