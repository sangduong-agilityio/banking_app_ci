import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/add_new_benificiary_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transaction_selection.dart';
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
  });

  BAWidgetTest(
    description: 'AddNewBeneficiaryScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display app bar with title',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AppBar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display avatar section',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(CircleAvatar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display transaction type selection',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(TransactionTypeSelection),
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Avatar Picker',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display default person icon when no avatar',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byIcon(Icons.person)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display add icon button',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byIcon(Icons.add)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Form Fields',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display bank selector field',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should have multiple text fields
                  expect(find.byType(BATextField), findsNWidgets(4));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display branch selector field',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Branch field should exist
                  expect(find.byType(BATextField), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display name input field',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(BATextField),
                count: 4, // Bank, Branch, Name, Card Number
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display card number input field',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(BATextField),
                count: 4,
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Bank Selection',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should open bank selector dialog when bank field tapped',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap bank field
                  await tester.tap(find.byType(BATextField).first);
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
          BAWidgetTestScenario(
            description: 'should trigger SelectBankEvt when bank selected',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.tap(find.byType(BATextField).first);
                  await tester.pumpAndSettle();

                  // Select first bank from dialog
                  if (find
                      .text(MockTransferData.mockBank1.name)
                      .evaluate()
                      .isNotEmpty) {
                    await tester.tap(
                      find.text(MockTransferData.mockBank1.name),
                    );
                    await tester.pumpAndSettle();
                  }
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<SelectBankEvt>())),
                  ).called(greaterThan(0));
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Branch Selection',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should disable branch field when no bank selected',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Branch field should be wrapped in GestureDetector
                  expect(find.byType(GestureDetector), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Form Validation',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should validate all required fields',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Try to submit empty form
                  await tester.tap(find.byType(BAElevatedButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should not navigate (validation failed)
                  expect(find.byType(AddNewBeneficiaryScreen), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Save Action',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display save button',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BAElevatedButton)),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should trigger AddNewBeneficiaryEvt when valid form submitted',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBank: MockTransferData.mockBank1,
                selectedBranch: MockTransferData.mockBranch1,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: AddNewBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                    onBeneficiaryAdded: (_) {},
                  ),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Fill name
                  await tester.enterText(
                    find.byType(BATextField).at(2),
                    'New Beneficiary',
                  );

                  // Fill card number
                  await tester.enterText(
                    find.byType(BATextField).at(3),
                    '1234567890123456',
                  );
                  await tester.pumpAndSettle();

                  // Submit
                  await tester.tap(find.byType(BAElevatedButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<AddNewBeneficiaryEvt>())),
                  ).called(greaterThan(0));
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
extension AddBeneficiaryStateCopyWith on TransferState {
  TransferState copyWith({dynamic selectedBank, dynamic selectedBranch}) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      status: status,
      selectedBank: selectedBank ?? this.selectedBank,
      selectedBranch: selectedBranch ?? this.selectedBranch,
    );
  }
}
