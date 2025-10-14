import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_report_model.freezed.dart';
part 'transaction_report_model.g.dart';

@freezed
class TransactionReportModel with _$TransactionReportModel {
  const factory TransactionReportModel({
    required List<TransactionModel> todayTransactions,
    required List<TransactionModel> yesterdayTransactions,
    required List<TransactionModel> recentTransactions,
    required List<BalanceSummaryModel> balanceHistory,
    required double currentBalance,
    double? thisMonthIncome,
    double? thisMonthExpense,
    double? lastMonthIncome,
    double? lastMonthExpense,
  }) = _TransactionReportModel;

  factory TransactionReportModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionReportModelFromJson(json);
}

/// Extension to convert balance history to chart data
extension TransactionReportChartData on TransactionReportModel {
  List<ChartData> get chartData {
    final Map<String, ChartData> monthlyData = {};

    for (final balance in balanceHistory) {
      final monthKey = '${balance.year}-${balance.month}';
      monthlyData[monthKey] = ChartData(
        month: _monthName(balance.month),
        balance: balance.endingBalance,
        income: balance.totalIncome,
        expense: balance.totalExpense,
        isCurrentMonth: _isCurrentMonth(balance.recordedAt),
      );
    }

    return monthlyData.values.toList()
      ..sort((a, b) => _monthNumber(a.month).compareTo(_monthNumber(b.month)));
  }

  bool _isCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  int _monthNumber(String monthName) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months.indexOf(monthName) + 1;
  }
}
