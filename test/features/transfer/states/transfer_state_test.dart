import 'package:banking_app/features/transfer/states/transfer_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/utils.dart';
import '../mocks/mock_transfer_data.dart';

void main() {
  BAUnitTest(
    description: 'TransferState Tests',
    features: [
      BAUTFeature(
        description: 'TransferState Properties',
        scenarios: [
          TransferStatePropsScenario(),
          TransferStateEqualityScenario(),
          TransferStateCopyWithScenario(),
          TransferStateDefaultValuesScenario(),
          TransferStateCopyWithNullScenario(),
        ],
      ),
      BAUTFeature(
        description: 'TransferState Helper Getters',
        scenarios: [
          TransferStateCanUseBiometricsScenario(),
          TransferStateIsAuthenticatedScenario(),
          TransferStateCanConfirmTransferScenario(),
        ],
      ),
    ],
  ).test();
}

class TransferStatePropsScenario
    extends BAUTScenario<TransferState, List<Object?>> {
  TransferStatePropsScenario()
    : super(
        description: '''
          Scenario: Test TransferState properties
          Given a TransferState instance
          When accessing props
          Then it should return the correct list of properties
          ''',
        when: () async => const TransferState(),
        act: (state) => state.props,
        expect: (List<Object?> result) {
          expect(result, hasLength(32));
        },
      );
}

class TransferStateEqualityScenario extends BAUTScenario<TransferState, bool> {
  TransferStateEqualityScenario()
    : super(
        description: '''
          Scenario: Test TransferState equality
          Given two identical TransferState instances
          When comparing them for equality
          Then they should be equal
          ''',
        when: () async => const TransferState(),
        act: (state) => state == const TransferState(),
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class TransferStateCopyWithScenario
    extends BAUTScenario<TransferState, TransferState> {
  TransferStateCopyWithScenario()
    : super(
        description: '''
          Scenario: Test TransferState copyWith
          Given a TransferState instance
          When copying it with a new status
          Then it should return a new TransferState instance with the new status
          ''',
        when: () async => const TransferState(),
        act: (state) => state.copyWith(status: const TransferStatus.loading()),
        expect: (TransferState result) {
          expect(result.status, equals(const TransferStatus.loading()));
        },
      );
}

class TransferStateDefaultValuesScenario
    extends BAUTScenario<TransferState, TransferState> {
  TransferStateDefaultValuesScenario()
    : super(
        description: '''
          Scenario: Test TransferState default values
          Given a new TransferState instance
          When accessing its properties
          Then it should have default values
          ''',
        when: () async => const TransferState(),
        act: (state) => state,
        expect: (TransferState result) {
          expect(result.accounts, isEmpty);
          expect(result.cards, isEmpty);
          expect(result.beneficiaries, isEmpty);
          expect(result.banks, isEmpty);
          expect(result.branches, isEmpty);
          expect(result.amount, isNull);
          expect(result.content, isNull);
        },
      );
}

class TransferStateCopyWithNullScenario
    extends BAUTScenario<TransferState, TransferState> {
  TransferStateCopyWithNullScenario()
    : super(
        description: '''
          Scenario: Test TransferState copyWith with null values
          Given a TransferState instance
          When copying it with null values
          Then it should return a new TransferState instance with the same properties
          ''',
        when: () async => const TransferState(),
        act: (state) => state.copyWith(status: null),
        expect: (TransferState result) {
          expect(result.status, equals(const TransferStatus.initial()));
        },
      );
}

class TransferStateCanUseBiometricsScenario
    extends BAUTScenario<TransferState, bool> {
  TransferStateCanUseBiometricsScenario()
    : super(
        description: '''
          Scenario: Test TransferState canUseBiometrics
          Given a TransferState instance with biometric settings
          When checking canUseBiometrics
          Then it should return true if biometrics are available and enabled
          ''',
        when: () async => const TransferState(
          biometricAvailable: true,
          biometricEnabled: true,
        ),
        act: (state) => state.canUseBiometrics,
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class TransferStateIsAuthenticatedScenario
    extends BAUTScenario<TransferState, bool> {
  TransferStateIsAuthenticatedScenario()
    : super(
        description: '''
          Scenario: Test TransferState isAuthenticated
          Given a TransferState instance with biometric authentication
          When checking isAuthenticated
          Then it should return true if biometric authentication is successful
          ''',
        when: () async => const TransferState(biometricAuthenticated: true),
        act: (state) => state.isAuthenticated,
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}

class TransferStateCanConfirmTransferScenario
    extends BAUTScenario<TransferState, bool> {
  TransferStateCanConfirmTransferScenario()
    : super(
        description: '''
          Scenario: Test TransferState canConfirmTransfer
          Given a TransferState instance with valid transfer details
          When checking canConfirmTransfer
          Then it should return true if all required fields are filled
          ''',
        when: () async => TransferState(
          selectedAccount: MockTransferData.mockAccount1,
          selectedBeneficiary: MockTransferData.mockBeneficiary1,
          amount: 100.0,
        ),
        act: (state) => state.canConfirmTransfer,
        expect: (bool result) {
          expect(result, isTrue);
        },
      );
}
