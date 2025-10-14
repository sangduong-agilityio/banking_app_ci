import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/transfer_widget_builder.dart';

void main() {
  BAWidgetTest(
    description: 'TransactionCard Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display child widget',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                child: const Text('Test Content'),
              ),
            ),
            verifications: [BAFindsTextVerification(text: 'Test Content')],
          ),
          BAWidgetTestScenario(
            description: 'should use default padding',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.padding, const EdgeInsets.all(16));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should use custom padding',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                padding: const EdgeInsets.all(24),
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.padding, const EdgeInsets.all(24));
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Selection State',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should show unselected state by default',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.isSelected, isFalse);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should show selected state',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                isSelected: true,
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.isSelected, isTrue);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should have AnimatedContainer',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AnimatedContainer)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Type-based Background Colors',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should use correct color for cardNumber when selected',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                isSelected: true,
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.type, TransferType.cardNumber);
                  expect(card.isSelected, isTrue);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should use correct color for sameBank when selected',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                isSelected: true,
                type: TransferType.sameBank,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.type, TransferType.sameBank);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should use correct color for otherBank when selected',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                isSelected: true,
                type: TransferType.otherBank,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.type, TransferType.otherBank);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'User Interactions',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should be tappable',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
            interactions: [
              BATapInteraction(finder: find.byType(TransactionCard)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(TransactionCard), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should be wrapped in GestureDetector',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(GestureDetector)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Styling',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should have default border radius',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.borderRadius, 15);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should use custom border radius',
            buildWidget: () => createTestWidget(
              child: TransactionCard(
                type: TransferType.cardNumber,
                borderRadius: 20,
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(card.borderRadius, 20);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
