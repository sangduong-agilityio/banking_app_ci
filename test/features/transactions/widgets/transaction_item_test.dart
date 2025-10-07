import 'package:banking_app/features/transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/utils.dart';

void main() {
  const groupName = 'TransactionItem';

  BAWidgetTest(
    description: groupName,
    features: [
      BAWidgetTestFeature(
        description: 'Rendering',
        scenarios: [
          BAWidgetTestScenario(
            description: 'renders title, subtitle and amount when provided',
            buildWidget: () => const TransactionItem(
              title: 'Transfer',
              subtitle: 'completed',
              amount: '+\$120',
            ),
            verifications: const [
              BAFindsTextVerification(text: 'Transfer'),
              BAFindsTextVerification(text: 'completed'),
              BAFindsTextVerification(text: '+\$120'),
            ],
          ),
          BAWidgetTestScenario(
            description: 'hides title and subtitle when empty',
            buildWidget: () =>
                const TransactionItem(title: '', subtitle: '', amount: '-\$45'),
            verifications: [
              BADoesNotFindVerification(finder: find.text('')),
              const BAFindsTextVerification(text: '-\$45'),
            ],
          ),
          BAWidgetTestScenario(
            description: 'shows icon container with size and radius',
            buildWidget: () =>
                const TransactionItem(icon: Icon(Icons.flash_on)),
            verifications: [
              const BACustomVerification(verification: _verifyIconContainer),
            ],
          ),
        ],
      ),
    ],
  ).test();
}

Future<void> _verifyIconContainer(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final containers = tester
      .widgetList<Container>(find.byType(Container))
      .toList();
  expect(containers.length, greaterThan(1));
  final Container iconContainer = containers[1];
  final BoxDecoration? decoration = iconContainer.decoration as BoxDecoration?;
  expect(iconContainer.constraints?.maxWidth ?? 48, 48);
  expect(iconContainer.constraints?.maxHeight ?? 48, 48);
  expect(decoration?.borderRadius, isNotNull);
}
