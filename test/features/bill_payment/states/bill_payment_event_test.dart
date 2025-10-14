import 'package:banking_app/features/bill_payment/presentation/blocs/bill_payment_event.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../mocks/mock_bill_payment_data.dart';

void main() {
  BAUnitTest(
    description: 'BillPaymentEvt Tests',
    features: [
      BAUTFeature(
        description: 'BillPaymentInitializeEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object?>>(
            description: '''
              Scenario: Test BillPaymentInitializeEvt Props
              Given a BillPaymentInitializeEvt
              When accessing props
              Then the props should contain the type
            ''',
            when: () async =>
                BillPaymentInitializeEvt(MockBillPaymentData.mockBillType),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockBillPaymentData.mockBillType);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectBillEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: '''
              Scenario: Test SelectBillEvt Props
              Given a SelectBillEvt
              When accessing props
              Then the props should contain the bill
            ''',
            when: () async => SelectBillEvt(MockBillPaymentData.mockBill),
            act: (event) => event.props,
            expect: (result) {
              expect(result, contains(MockBillPaymentData.mockBill));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectAccountEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: 'Should contain account in props',
            when: () async => SelectAccountEvt(MockBillPaymentData.mockAccount),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockBillPaymentData.mockAccount);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectCardEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: 'Should contain card in props',
            when: () async => SelectCardEvt(MockBillPaymentData.mockCard),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], MockBillPaymentData.mockCard);
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SendOtpEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: 'Should contain billId in props',
            when: () async => const SendOtpEvt(billId: 'BILL123'),
            act: (event) => event.props,
            expect: (result) {
              expect(result, hasLength(1));
              expect(result[0], 'BILL123');
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'SelectCompanyEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: '''
              Scenario: Test SelectCompanyEvt Props
              Given a SelectCompanyEvt
              When accessing props
              Then the props should contain the company
            ''',
            when: () async => SelectCompanyEvt(MockBillPaymentData.mockCompany),
            act: (event) => event.props,
            expect: (result) {
              expect(result, contains(MockBillPaymentData.mockCompany));
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'UpdateBillDetailsEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object?>>(
            description: '''
              Scenario: Test UpdateBillDetailsEvt Props
              Given an UpdateBillDetailsEvt
              When accessing props
              Then the props should contain all provided details
            ''',
            when: () async => UpdateBillDetailsEvt(
              amount: 200.0,
              fee: 5.0,
              billCode: 'BILL123',
              phoneNumber: '1234567890',
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(
                result,
                containsAll([200.0, 5.0, 'BILL123', '1234567890']),
              );
            },
          ),
        ],
      ),
      BAUTFeature(
        description: 'PayBillEvt',
        scenarios: [
          BAUTScenario<BillPaymentEvt, List<Object>>(
            description: '''
              Scenario: Test PayBillEvt Props
              Given a PayBillEvt
              When accessing props
              Then the props should contain the bill and paymentMethodId
            ''',
            when: () async => PayBillEvt(
              bill: MockBillPaymentData.mockBill,
              paymentMethodId: 'PAY123',
            ),
            act: (event) => event.props,
            expect: (result) {
              expect(
                result,
                containsAll([MockBillPaymentData.mockBill, 'PAY123']),
              );
            },
          ),
        ],
      ),
    ],
  ).test();
}
