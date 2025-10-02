import 'package:banking_app/features/transactions/models/balance_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BABalanceChart extends StatelessWidget {
  final List<BalanceSummaryModel> data;

  const BABalanceChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sortedData = [...data]
      ..sort((a, b) {
        final yearCompare = a.year.compareTo(b.year);
        if (yearCompare != 0) return yearCompare;
        return a.month.compareTo(b.month);
      });

    double maxPositive = 0;
    double maxNegative = 0;

    for (var item in sortedData) {
      final positive = item.totalIncome + item.endingBalance;
      final negative = -item.totalExpense;
      if (positive > maxPositive) maxPositive = positive;
      if (negative < maxNegative) maxNegative = negative;
    }

    final maxRange = maxPositive > maxNegative.abs()
        ? maxPositive
        : maxNegative.abs();

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
      borderWidth: 0,
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        plotOffset: 20,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey.shade400,
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
        minimum: -maxRange * 1.1,
        maximum: maxRange * 1.1,
        axisLine: const AxisLine(width: 0),
        labelStyle: const TextStyle(fontSize: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.grey.withOpacity(0.1),
          dashArray: const [5, 5],
        ),
        interval: maxRange * 0.3,
      ),

      series: <CartesianSeries>[
        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
          width: 0.15,
          spacing: 0.15,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => -d.totalExpense,
          color: const Color(0xFFFF4267),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        ),

        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
          width: 0.15,
          spacing: 0.15,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.totalIncome,
          color: const Color(0xFFFBB8FF),
        ),

        StackedColumnSeries<BalanceSummaryModel, String>(
          dataSource: sortedData,
          width: 0.15,
          spacing: 0.15,
          xValueMapper: (d, _) => "${d.month}/${d.year}",
          yValueMapper: (d, _) => d.endingBalance,
          color: const Color(0xFF3629B7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }
}
