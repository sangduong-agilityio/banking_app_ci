import 'package:banking_app/features/transfer/widgets/beneficiary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/transfer_widget_builder.dart';

void main() {
  BAWidgetTest(
    description: 'BeneficiaryCard Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display child widget',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(
                onTap: () {},
                child: const Text('Test Child'),
              ),
            ),
            verifications: [BAFindsTextVerification(text: 'Test Child')],
          ),
          BAWidgetTestScenario(
            description: 'should have default dimensions',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<BeneficiaryCard>(
                    find.byType(BeneficiaryCard),
                  );
                  expect(card.width, 100);
                  expect(card.height, 120);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should use custom dimensions',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(
                width: 150,
                height: 200,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<BeneficiaryCard>(
                    find.byType(BeneficiaryCard),
                  );
                  expect(card.width, 150);
                  expect(card.height, 200);
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
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<BeneficiaryCard>(
                    find.byType(BeneficiaryCard),
                  );
                  expect(card.isSelected, isFalse);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should show selected state',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(
                isSelected: true,
                onTap: () {},
                child: const SizedBox(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final card = tester.widget<BeneficiaryCard>(
                    find.byType(BeneficiaryCard),
                  );
                  expect(card.isSelected, isTrue);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should have AnimatedContainer for state animation',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AnimatedContainer)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'User Interactions',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should trigger onTap callback',
            buildWidget: () {
              return createTestWidget(
                child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
              );
            },
            interactions: [
              BATapInteraction(finder: find.byType(BeneficiaryCard)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(BeneficiaryCard), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should be wrapped in GestureDetector',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
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
            description: 'should have rounded corners',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final container = tester.widget<AnimatedContainer>(
                    find.byType(AnimatedContainer),
                  );
                  final decoration = container.decoration as BoxDecoration;
                  final borderRadius = decoration.borderRadius as BorderRadius;
                  expect(borderRadius.topLeft.x, 16);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should have border',
            buildWidget: () => createTestWidget(
              child: BeneficiaryCard(onTap: () {}, child: const SizedBox()),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final container = tester.widget<AnimatedContainer>(
                    find.byType(AnimatedContainer),
                  );
                  final decoration = container.decoration as BoxDecoration;
                  expect(decoration.border, isNotNull);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
