import 'package:banking_app/features/bill_payment/blocs/bill_payment_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';

void main() {
  BAUnitTest(
    description: 'BillPaymentState Tests',
    features: [
      BAUTFeature(
        description: 'BillPaymentState Properties',
        scenarios: [
          BillPaymentStatePropsScenario(),
          BillPaymentStateEqualityScenario(),
          BillPaymentStateCopyWithScenario(),
          BillPaymentStateDefaultValuesScenario(),
          BillPaymentStateCopyWithNullScenario(),
        ],
      ),
    ],
  ).test();
}

class BillPaymentStatePropsScenario
    extends BAUTScenario<BillPaymentState, List<Object?>> {
  BillPaymentStatePropsScenario()
    : super(
        description: '''
          Scenario: Test BillPaymentState properties
          Given a BillPaymentState instance
          When accessing props
          Then it should return the correct list of properties
          ''',
        when: () async => const BillPaymentState(),
        act: (state) => state.props,
        expect: (List<Object?> result) {
          expect(result, hasLength(21));
        },
      );
}

class BillPaymentStateEqualityScenario
    extends BAUTScenario<BillPaymentState, bool> {
  BillPaymentStateEqualityScenario()
    : super(
        description: '''
          Scenario: Test BillPaymentState equality
          Given two identical BillPaymentState instances
          When comparing them for equality
          Then they should be equal
          ''',
        when: () async => const BillPaymentState(),
        act: (state) => state == const BillPaymentState(),
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class BillPaymentStateCopyWithScenario
    extends BAUTScenario<BillPaymentState, BillPaymentState> {
  BillPaymentStateCopyWithScenario()
    : super(
        description: '''
          Scenario: Test BillPaymentState copyWith method
          Given a BillPaymentState instance
          When using copyWith to change properties
          Then the new instance should reflect those changes
          ''',
        when: () async => const BillPaymentState(),
        act: (state) => state.copyWith(
          amount: 100.0,
          billId: '123',
          fee: 2.0,
          otpSent: true,
          isOtpVerified: true,
          transactionId: 'txn_456',
          billCode: 'BILL001',
          phoneNumber: '555-1234',
        ),
        expect: (BillPaymentState result) {
          expect(result.amount, equals(100.0));
          expect(result.billId, equals('123'));
          expect(result.fee, equals(2.0));
          expect(result.otpSent, isTrue);
          expect(result.isOtpVerified, isTrue);
          expect(result.transactionId, equals('txn_456'));
          expect(result.billCode, equals('BILL001'));
          expect(result.phoneNumber, equals('555-1234'));
        },
      );
}

class BillPaymentStateDefaultValuesScenario
    extends BAUTScenario<BillPaymentState, BillPaymentState> {
  BillPaymentStateDefaultValuesScenario()
    : super(
        description: '''
          Scenario: Test BillPaymentState default values
          Given a default BillPaymentState instance
          When accessing its properties
          Then they should match the expected default values
          ''',
        when: () async => const BillPaymentState(),
        act: (state) => state,
        expect: (BillPaymentState result) {
          expect(result.status, equals(const BillPaymentStatus.initial()));
          expect(result.bills, isEmpty);
          expect(result.companies, isEmpty);
          expect(result.accounts, isEmpty);
          expect(result.cards, isEmpty);
          expect(result.selectedAccount, isNull);
          expect(result.selectedCard, isNull);
          expect(result.selectedCompany, isNull);
          expect(result.amount, isNull);
          expect(result.fee, isNull);
          expect(result.otpSent, isFalse);
          expect(result.billId, isNull);
          expect(result.isOtpVerified, isFalse);
          expect(result.transactionId, isNull);
          expect(result.selectedBill, isNull);
          expect(result.billCode, isNull);
          expect(result.phoneNumber, isNull);
          expect(result.clearAccount, isFalse);
          expect(result.clearCard, isFalse);
          expect(result.otpCode, isNull);
          expect(result.errorMessage, isNull);
        },
      );
}

class BillPaymentStateCopyWithNullScenario
    extends BAUTScenario<BillPaymentState, BillPaymentState> {
  BillPaymentStateCopyWithNullScenario()
    : super(
        description: '''
          Scenario: Test BillPaymentState copyWith with null values
          Given a BillPaymentState instance
          When using copyWith with null values
          Then the new instance should retain original property values
          ''',
        when: () async => const BillPaymentState(
          amount: 100.0,
          billId: '123',
          fee: 2.0,
          otpSent: true,
          isOtpVerified: true,
          transactionId: 'txn_456',
          billCode: 'BILL001',
          phoneNumber: '555-1234',
        ),
        act: (state) => state.copyWith(
          amount: null,
          billId: null,
          fee: null,
          otpSent: null,
          isOtpVerified: null,
          transactionId: null,
          billCode: null,
          phoneNumber: null,
        ),
        expect: (BillPaymentState result) {
          expect(result.amount, equals(100.0)); // Retains original value
          expect(result.billId, equals('123')); // Retains original value
          expect(result.fee, equals(2.0)); // Retains original value
          expect(result.otpSent, isTrue); // Retains original value
          expect(result.isOtpVerified, isTrue); // Retains original value
          expect(
            result.transactionId,
            equals('txn_456'),
          ); // Retains original value
          expect(result.billCode, equals('BILL001')); // Retains original value
          expect(
            result.phoneNumber,
            equals('555-1234'),
          ); // Retains original value
        },
      );
}
