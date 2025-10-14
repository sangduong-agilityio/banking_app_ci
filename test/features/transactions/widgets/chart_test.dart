import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/presentation/widgets/chart.dart';
import 'package:flutter/material.dart';
import '../../../helpers/utils.dart';

void main() {
  BalanceSummaryModel balance({
    required int year,
    required int month,
    required double income,
    required double expense,
    required double ending,
  }) {
    return BalanceSummaryModel(
      id: '$year-$month',
      userId: 'user',
      year: year,
      month: month,
      totalIncome: income,
      totalExpense: expense,
      endingBalance: ending,
      transactionCount: 1,
      recordedAt: DateTime(year, month, 1),
    );
  }

  BAWidgetTest(
    description: 'BABalanceChart',
    features: [
      BAWidgetTestFeature(
        description: 'Rendering & labels',
        scenarios: [
          BAWidgetTestScenario(
            description: 'renders with non-empty data and shows month labels',
            buildWidget: () => SizedBox(
              height: 300,
              child: BABalanceChart(
                data: [
                  balance(
                    year: 2024,
                    month: 3,
                    income: 1000,
                    expense: 400,
                    ending: 600,
                  ),
                  balance(
                    year: 2024,
                    month: 4,
                    income: 1500,
                    expense: 500,
                    ending: 1000,
                  ),
                ],
              ),
            ),
            verifications: const [
              BAFindsTextVerification(text: 'Mar'),
              BAFindsTextVerification(text: 'Apr'),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Sorting',
        scenarios: [
          BAWidgetTestScenario(
            description: 'sorts by year then month ascending',
            buildWidget: () => SizedBox(
              height: 300,
              child: BABalanceChart(
                data: [
                  balance(
                    year: 2023,
                    month: 12,
                    income: 100,
                    expense: 50,
                    ending: 50,
                  ),
                  balance(
                    year: 2023,
                    month: 11,
                    income: 100,
                    expense: 30,
                    ending: 70,
                  ),
                  balance(
                    year: 2024,
                    month: 1,
                    income: 120,
                    expense: 20,
                    ending: 100,
                  ),
                ],
              ),
            ),
            verifications: const [
              BAFindsTextVerification(text: 'Nov'),
              BAFindsTextVerification(text: 'Dec'),
              BAFindsTextVerification(text: 'Jan'),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
