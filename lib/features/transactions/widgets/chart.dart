import 'package:banking_app/features/transactions/models/balance_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BABalanceChart extends StatelessWidget {
  final List<BalanceSummaryModel> data;
  final double barWidth;

  const BABalanceChart({super.key, required this.data, this.barWidth = 0.25});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        interval: 500,
      ),

      series: <CartesianSeries>[
        // Expense
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: data,
          width: barWidth,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.totalExpense,
          color: const Color(0xFFFF4267),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        // Income
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: data,
          width: barWidth,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.totalIncome,
          color: const Color(0xFFFBB8FF),
        ),
        // Balance
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: data,
          width: barWidth,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.endingBalance,
          color: const Color(0xFF3629B7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
