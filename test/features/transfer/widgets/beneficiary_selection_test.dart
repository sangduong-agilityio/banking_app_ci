import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/add_new_benificiary_screen.dart';
import 'package:banking_app/features/transfer/presentation/views/directory_beneficiary_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/beneficiary_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/beneficiary_card.dart';
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
    description: 'BeneficiarySelection Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display header with title',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find header text
                  expect(find.byType(Text), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display "Find" button',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(TextButton)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display horizontal scrollable list',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final listView = tester.widget<ListView>(
                    find.byType(ListView),
                  );
                  expect(listView.scrollDirection, Axis.horizontal);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Add Beneficiary Card',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display add card as first item',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find BeneficiaryCard widgets
                  final cards = find.byType(BeneficiaryCard);
                  // Should have add card + beneficiaries
                  expect(
                    cards,
                    findsNWidgets(
                      MockTransferData.mockBeneficiaries.length + 1,
                    ),
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display add icon in first card',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byIcon(Icons.add)),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should navigate to AddNewBeneficiaryScreen when add card tapped',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap first card (add card)
                  final addCard = find.byType(BeneficiaryCard).first;
                  await tester.tap(addCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should navigate to AddNewBeneficiaryScreen
                  expect(find.byType(AddNewBeneficiaryScreen), findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Beneficiary List Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display all beneficiaries',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find beneficiary names
                  expect(
                    find.text(MockTransferData.mockBeneficiary1.name),
                    findsOneWidget,
                  );
                  expect(
                    find.text(MockTransferData.mockBeneficiary2.name),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display CircleAvatar for each beneficiary',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find avatars (add card has 1, each beneficiary has 1)
                  final avatars = find.byType(CircleAvatar);
                  expect(
                    avatars,
                    findsNWidgets(
                      MockTransferData.mockBeneficiaries.length + 1,
                    ),
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display person icon for null avatar',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byIcon(Icons.person),
                count: MockTransferData.mockBeneficiaries.length,
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Selection State',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should highlight selected beneficiary',
            buildWidget: () {
              final state =
                  createInitialTransferState(
                    beneficiaries: MockTransferData.mockBeneficiaries,
                  ).copyWith(
                    selectedBeneficiary: MockTransferData.mockBeneficiary1,
                  );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: BeneficiarySelection(
                    onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                    state: state,
                  ),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find selected card
                  final cards = tester.widgetList<BeneficiaryCard>(
                    find.byType(BeneficiaryCard),
                  );
                  // Second card should be selected (first is add card)
                  expect(cards.elementAt(1).isSelected, isTrue);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should trigger SelectBeneficiaryEvt when beneficiary tapped',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap second card (first beneficiary)
                  final beneficiaryCard = find.byType(BeneficiaryCard).at(1);
                  await tester.tap(beneficiaryCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<SelectBeneficiaryEvt>())),
                  ).called(1);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Navigation',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should navigate to DirectoryBeneficiaryScreen when Find button tapped',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: BeneficiarySelection(
                  onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                  state: createInitialTransferState(),
                ),
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap Find button
                  await tester.tap(find.byType(TextButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.byType(DirectoryBeneficiaryScreen),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Empty State',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should handle empty beneficiaries list',
            buildWidget: () {
              final state = createInitialTransferState(beneficiaries: []);
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: BeneficiarySelection(
                    onBeneficiarySelected: (BeneficiaryModel beneficiary) {},
                    state: state,
                  ),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should only show add card
                  final cards = find.byType(BeneficiaryCard);
                  expect(cards, findsOneWidget);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}

// Extension to add copyWith for testing
extension TransferStateTestCopyWith on TransferState {
  TransferState copyWith({dynamic selectedBeneficiary}) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      status: status,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
    );
  }
}
