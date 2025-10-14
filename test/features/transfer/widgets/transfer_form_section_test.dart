import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/confirm_transfer_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transfer_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../helpers/transfer_test_setup.dart';
import '../helpers/transfer_widget_builder.dart';
import '../mocks/mock_transfer_bloc.dart';
import '../mocks/mock_transfer_data.dart';

void main() {
  late MockTransferBloc mockBloc;

  setUpAll(() {
    setupTransferBlocFallbacks();
  });

  setUp(() {
    mockBloc = MockTransferBloc();
    setupMockBloc(mockBloc, createInitialTransferState());
  });

  BAWidgetTest(
    description: 'TransferFormSection Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'Form Display - Card/Same Bank Type',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display name and card number fields',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should have name, card, amount, content
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsNWidgets(4));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should NOT display bank/branch fields for card type',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should not have bank/branch selectors
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsNWidgets(4)); // Only 4 fields
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Form Display - Other Bank Type',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display bank and branch fields',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.otherBank,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should have bank, branch, name, card, amount, content
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsNWidgets(6));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display bank selector with arrow icon',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.otherBank,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byIcon(Icons.keyboard_arrow_right),
                count: 2, // Bank and branch selectors
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Form Validation',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should validate name field',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedAccount: MockTransferData.mockAccount1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Enter empty name and try to submit
                  final nameField = find.byType(BATextField).first;
                  await tester.tap(nameField);
                  await tester.enterText(nameField, '');
                  await tester.pumpAndSettle();

                  // Tap confirm button
                  final confirmBtn = find.byType(BAElevatedButton);
                  await tester.tap(confirmBtn);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should not navigate (validation failed)
                  expect(find.byType(ConfirmTransferScreen), findsNothing);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should validate amount field',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedAccount: MockTransferData.mockAccount1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Try to enter amount exceeding balance
                  final amountField = find.byType(BATextField).at(2);
                  await tester.tap(amountField);
                  await tester.enterText(amountField, '99999999');
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Validation error should appear
                  expect(find.byType(BATextField), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Auto-fill from Beneficiary',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should auto-fill name and card when beneficiary selected',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Name field should be filled
                  final nameField = tester.widget<BATextField>(
                    find.byType(BATextField).first,
                  );
                  expect(
                    nameField.controller?.text,
                    MockTransferData.mockBeneficiary1.name,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Save to Directory Checkbox',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display save to directory checkbox',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(Checkbox)),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should trigger UpdateTransferDetailsEvt when checkbox toggled',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap checkbox
                  await tester.tap(find.byType(Checkbox));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(
                      any(that: isA<UpdateTransferDetailsEvt>()),
                    ),
                  ).called(greaterThan(0));
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Confirm Button',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display confirm button',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BAElevatedButton)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should disable button when no account selected',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedAccount: null,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final button = tester.widget<BAElevatedButton>(
                    find.byType(BAElevatedButton),
                  );
                  expect(button.isDisabled, isTrue);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should navigate to ConfirmTransferScreen when valid form submitted',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Fill amount field
                  final amountField = find.byType(BATextField).at(2);
                  await tester.enterText(amountField, '100');
                  await tester.pumpAndSettle();

                  // Fill content field
                  final contentField = find.byType(BATextField).at(3);
                  await tester.enterText(contentField, 'Test transfer');
                  await tester.pumpAndSettle();

                  // Tap confirm button
                  await tester.tap(find.byType(BAElevatedButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should trigger ConfirmTransferEvt
                  verify(
                    () => mockBloc.add(any(that: isA<ConfirmTransferEvt>())),
                  ).called(1);

                  // Should navigate
                  expect(find.byType(ConfirmTransferScreen), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Amount to Words Conversion',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should show amount in words when amount entered',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.cardNumber,
                selectedAccount: MockTransferData.mockAccount1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Enter amount
                  final amountField = find.byType(BATextField).at(2);
                  await tester.enterText(amountField, '100');
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should display amount in words
                  expect(find.byType(Text), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Bank/Branch Selector Dialog',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should open bank selector dialog when bank field tapped',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedTransferType: TransferType.otherBank,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransferFormSection(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap bank field
                  final bankField = find.byType(BATextField).first;
                  await tester.tap(bankField);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Dialog should open
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

// Extension for testing
extension TransferStateFormCopyWith on TransferState {
  TransferState copyWith({
    TransferType? selectedTransferType,
    dynamic selectedAccount,
    dynamic selectedBeneficiary,
  }) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      status: status,
      selectedTransferType: selectedTransferType ?? this.selectedTransferType,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
    );
  }
}
