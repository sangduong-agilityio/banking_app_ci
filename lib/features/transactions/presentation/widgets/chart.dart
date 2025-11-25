import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// A chart that displays the user's balance history.
class BABalanceChart extends StatelessWidget {
  const BABalanceChart({super.key, required this.data});

  final List<BalanceSummaryModel> data;

  @override
  Widget build(BuildContext context) {
    final sortedData = [...data]
      ..sort((a, b) {
        final yearCompare = a.year.compareTo(b.year);
        if (yearCompare != 0) return yearCompare;
        return a.month.compareTo(b.month);
      });

    final maxRange = sortedData.fold<double>(
      0,
      (max, item) => (item.totalIncome + item.endingBalance).abs() > max
          ? (item.totalIncome + item.endingBalance).abs()
          : max,
    );

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
      borderWidth: 0,
      primaryXAxis: _buildXAxis(),
      primaryYAxis: _buildYAxis(maxRange),
      series: _getChartSeries(sortedData),
    );
  }

  /// Builds the X-axis of the chart.
  CategoryAxis _buildXAxis() {
    return CategoryAxis(
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
    );
  }

  /// Builds the Y-axis of the chart.
  NumericAxis _buildYAxis(double maxRange) {
    return NumericAxis(
      minimum: -maxRange * 1.1,
      maximum: maxRange * 1.1,
      axisLine: const AxisLine(width: 0),
      labelStyle: const TextStyle(fontSize: 0),
      majorTickLines: const MajorTickLines(size: 0),
      majorGridLines: MajorGridLines(
        width: 1,
        color: Colors.grey.withAlpha(50),
        dashArray: const [5, 5],
      ),
      interval: maxRange * 0.3,
    );
  }

  /// Returns the series to be displayed in the chart.
  List<CartesianSeries> _getChartSeries(List<BalanceSummaryModel> sortedData) {
    return <CartesianSeries>[
      StackedColumnSeries<BalanceSummaryModel, String>(
        dataSource: sortedData,
        width: 0.15,
        spacing: 0.15,
        xValueMapper: (d, _) => '${d.month}/${d.year}',
        yValueMapper: (d, _) => -d.totalExpense,
        color: const Color(0xFFFF4267),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      StackedColumnSeries<BalanceSummaryModel, String>(
        dataSource: sortedData,
        width: 0.15,
        spacing: 0.15,
        xValueMapper: (d, _) => '${d.month}/${d.year}',
        yValueMapper: (d, _) => d.totalIncome,
        color: const Color(0xFFFBB8FF),
      ),
      StackedColumnSeries<BalanceSummaryModel, String>(
        dataSource: sortedData,
        width: 0.15,
        spacing: 0.15,
        xValueMapper: (d, _) => '${d.month}/${d.year}',
        yValueMapper: (d, _) => d.endingBalance,
        color: const Color(0xFF3629B7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
    ];
  }
}
