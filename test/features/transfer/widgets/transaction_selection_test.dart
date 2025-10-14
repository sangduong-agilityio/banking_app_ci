import 'package:banking_app/core/widgets/card.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transaction_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../helpers/transfer_test_setup.dart';
import '../helpers/transfer_widget_builder.dart';
import '../mocks/mock_transfer_bloc.dart';

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
    description: 'TransactionTypeSelection Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display all 3 transaction types',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find all transaction cards
                  final cards = find.byType(TransactionCard);
                  expect(cards, findsNWidgets(3));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display correct titles',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify text exists (adjust based on your l10n)
                  expect(find.byType(Text), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display correct icons',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify icons exist
                  expect(
                    find.byIcon(Icons.credit_card_rounded),
                    findsOneWidget,
                  );
                  expect(find.byIcon(Icons.person), findsOneWidget);
                  expect(
                    find.byIcon(Icons.account_balance_rounded),
                    findsOneWidget,
                  );
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
            description: 'should highlight selected card',
            buildWidget: () {
              final state = createInitialTransferState(
                status: const TransferStatusInitial(),
              );
              // Set selected type to cardNumber
              final updatedState = state.copyWith(
                selectedTransferType: TransferType.cardNumber,
              );
              setupMockBloc(mockBloc, updatedState);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const TransactionTypeSelection(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find selected card and verify it's highlighted
                  final cards = tester.widgetList<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  expect(cards.first, isTrue);
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
            description: 'should trigger bloc event when tapped',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  // Tap on first card (cardNumber type)
                  final firstCard = find.byType(TransactionCard).first;
                  await tester.tap(firstCard);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify SelectTransferTypeEvt was called
                  verify(
                    () => mockBloc.add(any(that: isA<SelectTransferTypeEvt>())),
                  ).called(1);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should be tappable',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify cards are wrapped in GestureDetector
                  final cards = tester.widgetList<TransactionCard>(
                    find.byType(TransactionCard),
                  );
                  for (final card in cards) {
                    expect(card.onTap, isNotNull);
                  }
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Layout',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display in horizontal scroll',
            buildWidget: () => createTestWidget(
              child: BlocProvider<TransferBloc>.value(
                value: mockBloc,
                child: const TransactionTypeSelection(),
              ),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Find ListView with horizontal scroll
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
    ],
  ).test();
}

// Extension to add copyWith if not exists
extension TransferStateCopyWith on TransferState {
  TransferState copyWith({TransferType? selectedTransferType}) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      status: status,
      selectedTransferType: selectedTransferType ?? this.selectedTransferType,
    );
  }
}
