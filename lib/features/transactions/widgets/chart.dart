import 'package:banking_app/features/transactions/models/balance_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BABalanceChart extends StatelessWidget {
  final List<BalanceSummaryModel> data;
  final double barWidth;

  const BABalanceChart({super.key, required this.data, this.barWidth = 0.25});

  @override
  Widget build(BuildContext context) {
    final sortedData = [...data]
      ..sort((a, b) {
        final yearCompare = a.year.compareTo(b.year);
        if (yearCompare != 0) return yearCompare;
        return a.month.compareTo(b.month);
      });

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        isInversed: false,
        axisLine: const AxisLine(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.grey,
        ),
        axisLabelFormatter: (AxisLabelRenderDetails args) {
          final parts = args.text.split('/');
          final month = int.tryParse(parts.first) ?? 1;

          const monthNames = [
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
          return ChartAxisLabel(monthNames[month - 1], args.textStyle);
        },
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
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
          width: barWidth,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.totalExpense,
          color: const Color(0xFFFF4267),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
          width: barWidth,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.totalIncome,
          color: const Color(0xFFFBB8FF),
        ),
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
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
