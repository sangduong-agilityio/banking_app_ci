import 'package:banking_app/core/widgets/dialog.dart';
import 'package:banking_app/features/transfer/widgets/account_and_card_selection.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../helpers/transfer_widget_builder.dart';
import '../mocks/mock_transfer_data.dart';

void main() {
  BAWidgetTest(
    description: 'AccountOrCardSelector Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'Initial Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display text field',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BATextField)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display dropdown icon',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byIcon(Icons.keyboard_arrow_down_rounded),
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should not show balance when nothing selected',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Balance text should not be visible
                  expect(
                    find.textContaining('Available Balance'),
                    findsNothing,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Selected Account Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display selected account number',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                selectedAccount: MockTransferData.mockAccount1,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textField = tester.widget<BATextField>(
                    find.byType(BATextField),
                  );
                  expect(
                    textField.controller?.text,
                    MockTransferData.mockAccount1.accountNumber,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display available balance for account',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                selectedAccount: MockTransferData.mockAccount1,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find balance text
                  final balanceText = find.textContaining('\$');
                  expect(balanceText, findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Selected Card Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display selected card number',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                selectedCard: MockTransferData.mockCard1,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textField = tester.widget<BATextField>(
                    find.byType(BATextField),
                  );
                  expect(
                    textField.controller?.text,
                    MockTransferData.mockCard1.cardNumber,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display available balance for card',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                selectedCard: MockTransferData.mockCard1,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final balanceText = find.textContaining('\$');
                  expect(balanceText, findsOneWidget);
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
            description: 'should open dialog when tapped',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.tap(find.byType(InkWell));
                  await tester.pumpAndSettle(const Duration(milliseconds: 500));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(Dialog), findsOneWidget);
                  expect(
                    find.byType(BASelectorDialog<dynamic>),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),

          BAWidgetTestScenario(
            description: 'should be wrapped in InkWell',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(InkWell)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'State Updates',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should update when selected account changes',
            buildWidget: () => createTestWidget(
              child: _StatefulAccountSelector(
                initialAccount: MockTransferData.mockAccount1,
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Initial account number shown
                  var textField = tester.widget<BATextField>(
                    find.byType(BATextField),
                  );
                  expect(
                    textField.controller?.text,
                    MockTransferData.mockAccount1.accountNumber,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Data Handling',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should handle empty accounts list',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: [],
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BATextField)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should handle empty cards list',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: [],
                onSelected: (_, __) {},
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BATextField)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should combine accounts and cards in dialog',
            buildWidget: () => createTestWidget(
              child: AccountOrCardSelector(
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                onSelected: (_, __) {},
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.tap(find.byType(BATextField));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Dialog should show all items
                  expect(find.byType(Dialog), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}

// Helper widget for testing state changes
class _StatefulAccountSelector extends StatefulWidget {
  final dynamic initialAccount;

  const _StatefulAccountSelector({required this.initialAccount});

  @override
  State<_StatefulAccountSelector> createState() =>
      _StatefulAccountSelectorState();
}

class _StatefulAccountSelectorState extends State<_StatefulAccountSelector> {
  late dynamic selectedAccount;

  @override
  void initState() {
    super.initState();
    selectedAccount = widget.initialAccount;
  }

  @override
  Widget build(BuildContext context) {
    return AccountOrCardSelector(
      accounts: MockTransferData.mockAccounts,
      cards: MockTransferData.mockCards,
      selectedAccount: selectedAccount,
      onSelected: (account, card) {
        setState(() {
          selectedAccount = account;
        });
      },
    );
  }
}
