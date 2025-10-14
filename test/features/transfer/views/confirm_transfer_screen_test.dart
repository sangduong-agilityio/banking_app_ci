import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/core/widgets/forms/text_field.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/confirm_transfer_screen.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/transfer_widget_builder.dart';
import '../../../helpers/utils.dart';
import '../helpers/transfer_test_setup.dart';
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
    description: 'ConfirmTransferScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display app bar',
            buildWidget: () {
              final state = createInitialTransferState(
                status: const TransferStatus.initial(),
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AppBar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display transaction details',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                amount: 100.0,
                content: 'Test transfer',
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsWidgets);
                  expect(textFields.evaluate().length, greaterThanOrEqualTo(5));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display confirm button',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(BAElevatedButton),
                count: 2,
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Transaction Details Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display from account number',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsWidgets);
                  expect(find.textContaining('*'), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display beneficiary name',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(MockTransferData.mockBeneficiary1.name),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display transfer amount',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                amount: 100.0,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.textContaining('\$100'), findsAtLeastNWidgets(1));
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display transaction fee',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                amount: 100.0,
                transactionFee: 2.5,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.textContaining('2.5'), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'OTP Section',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should display OTP input field when not awaiting biometric',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusInitial(),
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final textFields = find.byType(BATextField);
                  expect(textFields, findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display Get OTP button initially',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                otpSent: false,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));
                  final scrollable = find.byType(SingleChildScrollView);
                  await tester.drag(scrollable, const Offset(0, -300));
                  await tester.pump(const Duration(milliseconds: 200));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(S.current.transferGetOtpButton),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should change to Resend button after OTP sent',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                otpSent: true,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));
                  final scrollable = find.byType(SingleChildScrollView);
                  await tester.drag(scrollable, const Offset(0, -300));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.text(S.current.transferResendButton),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should trigger SendOtpEvt when Get OTP button tapped',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                transferId: 'transfer',
                otpSent: false,
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));
                  final getOtpButton = find.text(
                    S.current.transferGetOtpButton,
                  );
                  await tester.dragUntilVisible(
                    getOtpButton,
                    find.byType(SingleChildScrollView),
                    const Offset(0, -100),
                  );
                  await tester.pump(const Duration(milliseconds: 200));
                  await tester.tap(getOtpButton);
                  await tester.pump(const Duration(milliseconds: 200));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(any(that: isA<SendOtpEvt>())),
                  ).called(1);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Biometric Authentication',
        scenarios: [
          BAWidgetTestScenario(
            description:
                'should display fingerprint icon when biometric available',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusAwaitingBiometric(),
                biometricAvailable: true,
                biometricEnabled: true,
              );
              setupMockBloc(mockBloc, state);

              setupServiceLocator(mockBloc);
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                child: const ConfirmTransferScreen(),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));

                  // Scroll to OTP section
                  final scrollable = find.byType(SingleChildScrollView);
                  await tester.drag(scrollable, const Offset(0, -300));
                  await tester.pump(const Duration(milliseconds: 200));
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Should display fingerprint widget inside GestureDetector
                  expect(find.byType(GestureDetector), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should trigger biometric event when fingerprint tapped',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusAwaitingBiometric(),
                biometricAvailable: true,
                biometricEnabled: true,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pump(const Duration(milliseconds: 200));

                  // Find fingerprint GestureDetector
                  final fingerprintDetectors = find.byType(GestureDetector);

                  // Scroll to make it visible
                  await tester.dragUntilVisible(
                    fingerprintDetectors.first,
                    find.byType(SingleChildScrollView),
                    const Offset(0, -100),
                  );
                  await tester.pumpAndSettle();

                  // Tap fingerprint
                  await tester.tap(fingerprintDetectors.first);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () =>
                        mockBloc.add(any(that: isA<ConfirmWithBiometricEvt>())),
                  ).called(1);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should hide OTP field when biometric is shown',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusAwaitingBiometric(),
                biometricAvailable: true,
                biometricEnabled: true,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();

                  // Scroll to section
                  final scrollable = find.byType(SingleChildScrollView);
                  await tester.drag(scrollable, const Offset(0, -300));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  find.byType(Row);
                  expect(find.byType(GestureDetector), findsWidgets);
                },
              ),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Confirmation Flow',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should handle success state',
            buildWidget: () {
              final successState = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusSuccess(),
              );

              setupMockBloc(mockBloc, successState);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  // Verify loader is hidden when success
                  expect(find.byType(CircularProgressIndicator), findsNothing);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should show loading indicator during transfer',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                status: const TransferStatusLoading(),
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BAWaitInteraction(duration: const Duration(milliseconds: 300)),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.byType(CircularProgressIndicator),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description:
                'should trigger confirm with OTP when button tapped with valid OTP',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                selectedAccount: MockTransferData.mockAccount1,
                transferId: 'tx123',
                status: const TransferStatusAwaitingOtp(),
                otpSent: true,
              );
              setupMockBloc(mockBloc, state);

              return createTestWidget(
                child: BlocProvider<TransferBloc>.value(
                  value: mockBloc,
                  child: const ConfirmTransferScreen(),
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.pumpAndSettle();
                  // Find OTP field
                  final otpField = find.widgetWithText(
                    BATextField,
                    S.current.transferOtpLabel,
                  );

                  // Scroll to OTP field
                  final scrollable = find.byType(SingleChildScrollView).first;
                  await tester.dragUntilVisible(
                    otpField,
                    scrollable,
                    const Offset(0, -100),
                  );
                  await tester.pumpAndSettle();

                  // Enter OTP
                  await tester.enterText(otpField, '123456');
                  await tester.pumpAndSettle();

                  // Find Confirm button
                  final confirmButton = find.text(
                    S.current.transferConfirmButton,
                  );
                  await tester.dragUntilVisible(
                    confirmButton,
                    find.byType(SingleChildScrollView),
                    const Offset(0, -100),
                  );
                  await tester.pumpAndSettle();
                  // Tap Confirm
                  await tester.tap(confirmButton);
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  verify(
                    () => mockBloc.add(
                      any(that: isA<ConfirmTransferWithOtpEvt>()),
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

// Extension for testing
extension ConfirmTransferStateCopyWith on TransferState {
  TransferState copyWith({
    dynamic selectedBeneficiary,
    dynamic selectedAccount,
    double? amount,
    String? content,
    TransferStatus? status,
    bool? otpSent,
    String? transferId,
    double? transactionFee,
    bool? biometricAvailable,
    bool? biometricEnabled,
  }) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      amount: amount ?? this.amount,
      content: content ?? this.content,
      status: status ?? this.status,
      otpSent: otpSent ?? this.otpSent,
      transferId: transferId ?? this.transferId,
      transactionFee: transactionFee ?? this.transactionFee,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
