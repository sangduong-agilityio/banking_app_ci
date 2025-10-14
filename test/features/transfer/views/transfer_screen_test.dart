import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/transfer_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/account_and_card_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/beneficiary_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transaction_selection.dart';
import 'package:banking_app/features/transfer/presentation/widgets/transfer_form_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../helpers/utils.dart';
import '../helpers/transfer_widget_builder.dart';
import '../mocks/mock_transfer_bloc.dart';
import '../helpers/transfer_test_setup.dart';

void main() {
  late MockTransferBloc mockBloc;

  setUpAll(() {
    setupTransferBlocFallbacks();
  });

  setUp(() {
    mockBloc = MockTransferBloc();
    setupMockBloc(mockBloc, createInitialTransferState());
    setupServiceLocator(mockBloc);
  });

  tearDown(() {
    cleanupServiceLocator();
  });

  BAWidgetTest(
    description: 'TransferScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Components Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display all main sections',
            buildWidget: () => createTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const TransferScreen(),
            ),
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(AccountOrCardSelector),
              ),
              BAFindsWidgetVerification(
                finder: find.byType(TransactionTypeSelection),
              ),
              BAFindsWidgetVerification(
                finder: find.byType(BeneficiarySelection),
              ),
              BAFindsWidgetVerification(
                finder: find.byType(TransferFormSection),
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display app bar',
            buildWidget: () => createTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const TransferScreen(),
            ),
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AppBar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should be scrollable',
            buildWidget: () => createTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const TransferScreen(),
            ),
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(SingleChildScrollView),
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
              final state = createInitialTransferState(
                status: const TransferStatusLoading(),
              );
              setupMockBloc(mockBloc, state);
              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const TransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 200)),
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
            buildWidget: () => createTestWidgetWithBloc(
              mockBloc: mockBloc,
              child: const TransferScreen(),
            ),
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));
                  verify(
                    () => mockBloc.add(any(that: isA<TransferInitializeEvt>())),
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
