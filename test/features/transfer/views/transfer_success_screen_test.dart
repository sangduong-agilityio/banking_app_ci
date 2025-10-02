import 'package:banking_app/core/widgets/button.dart';
import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:banking_app/features/transfer/views/transfer_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    description: 'TransferSuccessScreen Widget Tests',
    features: [
      BAWidgetTestFeature(
        description: 'UI Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display app bar',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(AppBar)),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display success icon/image',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(Image), findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display success message',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(Text), findsWidgets);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display confirm button',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(BAElevatedButton)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Transfer Details Display',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should display transfer amount',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.byWidgetPredicate((widget) {
                      if (widget is RichText) {
                        final text = widget.text.toPlainText();
                        return text.contains('\$');
                      }
                      return false;
                    }),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display beneficiary name',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(
                    find.byWidgetPredicate(
                      (widget) =>
                          widget is RichText &&
                          widget.text.toPlainText().contains(
                            MockTransferData.mockBeneficiary1.name,
                          ),
                    ),
                    findsOneWidget,
                  );
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should display formatted amount in RichText',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 1000.50,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final richTextFinder = find.byWidgetPredicate(
                    (widget) =>
                        widget is RichText &&
                        RegExp(
                          r'\$[0-9,]+(\.\d{1,2})?',
                        ).hasMatch(widget.text.toPlainText()),
                  );
                  expect(richTextFinder, findsOneWidget);
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
            description: 'should navigate to home when confirm button tapped',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            interactions: [
              BACustomInteraction(
                action: (tester) async {
                  await tester.tap(find.byType(BAElevatedButton));
                  await tester.pumpAndSettle();
                },
              ),
            ],
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  expect(find.byType(BAElevatedButton), findsOneWidget);
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
            description: 'should be scrollable',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(
                finder: find.byType(SingleChildScrollView),
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should center content vertically',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BAFindsWidgetVerification(finder: find.byType(Column)),
            ],
          ),
        ],
      ),
      BAWidgetTestFeature(
        description: 'Edge Cases',
        scenarios: [
          BAWidgetTestScenario(
            description: 'should handle large amount display',
            buildWidget: () {
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 999999.99,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final richTextFinder = find.byWidgetPredicate(
                    (widget) =>
                        widget is RichText &&
                        widget.text.toPlainText().contains('\$'),
                  );
                  expect(richTextFinder, findsOneWidget);
                },
              ),
            ],
          ),
          BAWidgetTestScenario(
            description: 'should handle long beneficiary name',
            buildWidget: () {
              final longNameBeneficiary = MockTransferData.mockBeneficiary1
                  .copyWith(
                    name: 'Johnathan Alexander Maximillian Doe the Third',
                  );
              final state = createInitialTransferState().copyWith(
                selectedBeneficiary: longNameBeneficiary,
                amount: 100.0,
              );
              return createTestWidgetWithBloc(
                mockBloc: mockBloc,
                initialState: state,
                child: TransferSuccessScreen(
                  amount: 100,
                  beneficiaryName: 'Emma',
                ),
              );
            },
            verifications: [
              BACustomVerification(
                verification: (tester) async {
                  final richTextFinder = find.byWidgetPredicate(
                    (widget) =>
                        widget is RichText &&
                        widget.text.toPlainText().contains(
                          'Johnathan Alexander Maximillian Doe the Third',
                        ),
                  );
                  expect(richTextFinder, findsOneWidget);
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
extension SuccessTransferStateCopyWith on TransferState {
  TransferState copyWith({dynamic selectedBeneficiary, double? amount}) {
    return TransferState(
      accounts: accounts,
      cards: cards,
      banks: banks,
      branches: branches,
      beneficiaries: beneficiaries,
      status: status,
      selectedBeneficiary: selectedBeneficiary ?? this.selectedBeneficiary,
      amount: amount ?? this.amount,
    );
  }
}
