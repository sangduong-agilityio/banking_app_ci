import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/directory_beneficiary_screen.dart';
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

  tearDown(() {
    cleanupServiceLocator();
  });

  BAWidgetTest(
    description: 'DirectoryBeneficiaryScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display app bar with title',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: DirectoryBeneficiaryScreen(
                  banks: MockTransferData.mockBanks,
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AppBar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display search field',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: DirectoryBeneficiaryScreen(
                  banks: MockTransferData.mockBanks,
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(TextField)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display list of banks',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: DirectoryBeneficiaryScreen(
                  banks: MockTransferData.mockBanks,
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  for (var bank in MockTransferData.mockBanks) {
                    expect(find.text(bank.name), findsOneWidget);
                  }
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display no banks message when list is empty',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const DirectoryBeneficiaryScreen(banks: []),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.text('No banks available'), findsOneWidget);
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
            description: 'should call onTap when a bank is tapped',
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: DirectoryBeneficiaryScreen(
                  banks: MockTransferData.mockBanks,
                ),
              );
            },
            interactions: [
              BATapInteraction(
                finder: find.text(MockTransferData.mockBanks[0].name),
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(
                      SelectBankEvt(MockTransferData.mockBanks[0]),
                    ),
                  ).called(1);
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
              final state = createInitialTransferState(
                status: const TransferStatusLoading(),
              );
              setupMockBloc(mockBloc, state);
              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: DirectoryBeneficiaryScreen(
                  banks: MockTransferData.mockBanks,
                ),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
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
            buildWidget: () {
              final state = createInitialTransferState();
              setupMockBloc(mockBloc, state);
              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: DirectoryBeneficiaryScreen(
                    banks: MockTransferData.mockBanks,
                  ),
                ),
              );
            },
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
  );
}
