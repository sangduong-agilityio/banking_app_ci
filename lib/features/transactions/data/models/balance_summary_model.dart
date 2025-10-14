import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_summary_model.freezed.dart';
part 'balance_summary_model.g.dart';

@freezed
class BalanceSummaryModel with _$BalanceSummaryModel {
  const factory BalanceSummaryModel({
    required String id,
    required String userId,
    required int year,
    required int month,
    required double totalIncome,
    required double totalExpense,
    required double endingBalance,
    required int transactionCount,
    required DateTime recordedAt,
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
