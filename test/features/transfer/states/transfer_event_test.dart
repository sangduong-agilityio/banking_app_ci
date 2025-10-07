import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/states/transfer_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../mocks/mock_transfer_data.dart';

void main() {
  BAUnitTest(
    description: 'TransferEvt Tests',
    features: [
      BAUTFeature(
        description: 'TransferInitializeEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: '''
              Scenario: Test TransferInitializeEvt Props
              Given a TransferInitializeEvt
              When accessing props
              Then the props should be empty
            ''',
            when: () async => TransferInitializeEvt(),
            act: (event) => event.props,
            expect: (result) {
              expect(result, isEmpty);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'BeneficiariesInitializeEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: '''
              Scenario: Test BeneficiariesInitializeEvt Props
              Given a BeneficiariesInitializeEvt
              When accessing props
              Then the props should contain beneficiaries and banks
            ''',
            when: () async => BeneficiariesInitializeEvt(
              beneficiaries: [MockTransferData.mockBeneficiary1],
              banks: [BankModel(id: '1', name: 'Bank A')],
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(2));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectAccountEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: '''
              Scenario: Test SelectAccountEvt Props
              Given a SelectAccountEvt
              When accessing props
              Then the props should contain the account
            ''',
            when: () async => SelectAccountEvt(MockTransferData.mockAccount1),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectCardEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: '''
              Scenario: Test SelectCardEvt Props
              Given a SelectCardEvt
              When accessing props
              Then the props should contain the card
            ''',
            when: () async => SelectCardEvt(MockTransferData.mockCard1),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockTransferData.mockCard1);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectTransferTypeEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: '''
              Scenario: Test SelectTransferTypeEvt Props
              Given a SelectTransferTypeEvt
              When accessing props
              Then the props should contain the transfer type
            ''',
            when: () async => SelectTransferTypeEvt(TransferType.cardNumber),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], TransferType.cardNumber);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectBankEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: '''
              Scenario: Test SelectBankEvt Props
              Given a SelectBankEvt
              When accessing props
              Then the props should contain the bank
            ''',
            when: () async => SelectBankEvt(MockTransferData.mockBank1),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockTransferData.mockBank1);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectBranchEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: '''
              Scenario: Test SelectBranchEvt Props
              Given a SelectBranchEvt
              When accessing props
              Then the props should contain the branch
            ''',
            when: () async => SelectBranchEvt(MockTransferData.mockBranch1),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockTransferData.mockBranch1);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'UpdateTransferDetailsEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: '''
              Scenario: Test UpdateTransferDetailsEvt Props
              Given an UpdateTransferDetailsEvt
              When accessing props
              Then the props should contain all provided details
            ''',
            when: () async => UpdateTransferDetailsEvt(
              amount: 100.0,
              content: 'Payment',
              name: 'John Doe',
              saveToDirectory: true,
              cardNumber: '1234',
              bank: BankModel(id: '1', name: 'Bank A'),
              branch: MockTransferData.mockBranch1,
              avatarUrl: 'http://example.com/avatar.png',
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(
                result,
                containsAll([
                  100.0,
                  'Payment',
                  'John Doe',
                  true,
                  '1234',
                  isA<BankModel>(),
                  isA<BranchModel>(),
                  'http://example.com/avatar.png',
                ]),
              );
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'FillTransferDetailsEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object>>(
            description: 'Should contain amount and content in props',
            when: () async =>
                const FillTransferDetailsEvt(amount: 200.0, content: 'Test'),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(2));
              expect(result[0], 200.0);
              expect(result[1], 'Test');
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SearchBeneficiaryEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should contain query in props',
            when: () async => const SearchBeneficiaryEvt('John'),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], 'John');
            },
          ),
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should handle empty query',
            when: () async => const SearchBeneficiaryEvt(''),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], '');
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'ConfirmTransferEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should contain beneficiary in props',
            when: () async => ConfirmTransferEvt(
              beneficiary: MockTransferData.mockBeneficiary1,
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockTransferData.mockBeneficiary1);
            },
          ),
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should handle null beneficiary',
            when: () async => const ConfirmTransferEvt(),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], isNull);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SendOtpEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should contain transferId in props',
            when: () async => const SendOtpEvt(transferId: 'TRF123'),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], 'TRF123');
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'ConfirmTransferWithOtpEvt',
        scenarios: [
          BAUTScenario<TransferEvt, List<Object?>>(
            description: 'Should contain otpCode and transferId in props',
            when: () async => const ConfirmTransferWithOtpEvt(
              otpCode: '123456',
              transferId: 'TRF123',
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(2));
              expect(result[0], '123456');
              expect(result[1], 'TRF123');
            },
          ),
        ],
      ),
    ],
  ).test();
}
