import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_report_model.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_event.dart';
import 'package:banking_app/features/transactions/presentation/blocs/transaction_state.dart';
import 'package:banking_app/features/transactions/presentation/views/transaction_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/utils.dart';
import '../helpers/transactions_widget_builder.dart';
import '../mocks/mock_transactions_bloc.dart';
import '../helpers/transactions_test_setup.dart';

void main() {
  late MockTransactionReportBloc mockBloc;

  setUpAll(() {
    setupTransactionBlocFallbacks();
  });

  setUp(() {
    mockBloc = MockTransactionReportBloc();
    setupMockTransactionBloc(mockBloc, createInitialTransactionState());
    setupTransactionServiceLocator(mockBloc);
  });

  tearDown(() {
    cleanupTransactionServiceLocator();
  });

  TransactionReportModel report() {
    final now = DateTime.now();
    TransactionModel transaction(String id, double amount) => TransactionModel(
      id: id,
      userId: 'user',
      type: TransferType.sameBank,
      amount: amount,
      status: TransactionStatus.completed,
      createdAt: now,
      category: TransactionCategory.internet,
    );

    return TransactionReportModel(
      todayTransactions: [transaction('today', 120), transaction('today', -45)],
      yesterdayTransactions: [transaction('year', -20)],
      recentTransactions: [
        transaction('recent', 10),
        transaction('recent', -5),
        transaction('recent', 0),
      ],
      balanceHistory: const [],
      currentBalance: 1234,
    );
  }

  BAWidgetTest(
    description: 'TransactionReportScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Components Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display title and sections when success',
            buildWidget: () {
              final state = createInitialTransactionState(
                status: const TransactionReportStatus.success(),
                report: report(),
              );
              setupMockTransactionBloc(mockBloc, state);
              return createTestWidget(child: const TransactionReportScreen());
            },
            interactions: const [
              BAWaitInteraction(duration: Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Title
                  expect(
                    find.text(S.current.transactionReportTitle),
                    findsOneWidget,
                  );
                  // Sections
                  expect(
                    find.text(S.current.transactionTodayTitle),
                    findsOneWidget,
                  );
                  expect(
                    find.text(S.current.transactionRecentTitle),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Loading State',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should show loader when loading',
            buildWidget: () {
              final state = createInitialTransactionState(
                status: const TransactionReportStatus.loading(),
                report: null,
              );
              setupMockTransactionBloc(mockBloc, state);
              return createTestWidget(child: const TransactionReportScreen());
            },
            interactions: const [
              BAWaitInteraction(duration: Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(CircularProgressIndicator), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Bloc Events',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should trigger initialize event on build',
            buildWidget: () =>
                createTestWidget(child: const TransactionReportScreen()),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pumpAndSettle();
                  verify(
                    () => mockBloc.add(
                      any(that: isA<TransactionReportInitializeEvt>()),
                    ),
                  ).called(1);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
