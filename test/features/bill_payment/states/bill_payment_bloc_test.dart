import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_bloc.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_event.dart';
import 'package:banking_app/features/bill_payment/states/bill_payment_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../mocks/mock_bill_payment_data.dart';

void main() {
  late BillPaymentRepositoryMock repository;
  late BillPaymentBloc billPaymentBloc;

  setUpAll(() {
    registerFallbackValue(MockBillPaymentData.mockCompany);
    registerFallbackValue(MockBillPaymentData.mockBill);
    registerFallbackValue(MockBillPaymentData.mockAccount);
    registerFallbackValue(BillType.electric);
  });

  setUp(() {
    repository = BillPaymentRepositoryMock();
    billPaymentBloc = BillPaymentBloc(repository: repository);
  });

  tearDown(() {
    billPaymentBloc.close();
  });

  BABlocTest(
    description: 'BillPaymentBloc Tests',
    features: [
      /// BillPaymentInitializeEvt Tests
      BABlocTestFeature(
        description: 'BillPaymentInitializeEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Initialize bill payment data successfully
              Given a BillPaymentBloc instance
              When BillPaymentInitializeEvt is added
              Then the state should contain the loaded data
            ''',
            setUp: () {
              when(
                () => repository.fetchCompanies(any()),
              ).thenAnswer((_) async => [MockBillPaymentData.mockCompany]);
              when(
                () => repository.fetchBills(),
              ).thenAnswer((_) async => [MockBillPaymentData.mockBill]);
              when(
                () => repository.fetchAccounts(),
              ).thenAnswer((_) async => [MockBillPaymentData.mockAccount]);
              when(() => repository.fetchCards()).thenAnswer((_) async => []);
            },
            build: () => billPaymentBloc,
            act: (bloc) => bloc.add(
              BillPaymentInitializeEvt(MockBillPaymentData.mockBillType),
            ),
            expect: () => [
              const BillPaymentState(status: BillPaymentStatus.loading()),
              BillPaymentState(
                status: const BillPaymentStatus.loaded(),
                companies: [MockBillPaymentData.mockCompany],
                bills: [MockBillPaymentData.mockBill],
                accounts: [MockBillPaymentData.mockAccount],
                cards: [],
              ),
            ],
          ),
        ],
      ),

      /// SelectBillEvt Tests
      BABlocTestFeature(
        description: 'SelectBillEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Select a bill
              Given a BillPaymentBloc instance
              When SelectBillEvt is added
              Then the state should reflect the selected bill
            ''',
            build: () => billPaymentBloc,
            act: (bloc) =>
                bloc.add(SelectBillEvt(MockBillPaymentData.mockBill)),
            expect: () => [
              BillPaymentState(
                selectedBill: MockBillPaymentData.mockBill,
                selectedCompany: MockBillPaymentData.mockBill.company,
                amount: MockBillPaymentData.mockBill.amount,
              ),
              BillPaymentState(
                selectedBill: MockBillPaymentData.mockBill,
                selectedCompany: MockBillPaymentData.mockBill.company,
                amount: MockBillPaymentData.mockBill.amount,
                fee: 0.0,
              ),
            ],
          ),
        ],
      ),

      /// SelectCompanyEvt Tests
      BABlocTestFeature(
        description: 'SelectCompanyEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Select a company
              Given a BillPaymentBloc instance
              When SelectCompanyEvt is added
              Then the state should reflect the selected company
            ''',
            build: () => billPaymentBloc,
            act: (bloc) =>
                bloc.add(SelectCompanyEvt(MockBillPaymentData.mockCompany)),
            expect: () => [
              BillPaymentState(
                selectedCompany: MockBillPaymentData.mockCompany,
              ),
            ],
          ),
        ],
      ),

      /// UpdateBillDetailsEvt Tests
      BABlocTestFeature(
        description: 'UpdateBillDetailsEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Update bill details
              Given a BillPaymentBloc instance
              When UpdateBillDetailsEvt is added
              Then the state should reflect the updated details
            ''',
            build: () => billPaymentBloc,
            act: (bloc) => bloc.add(
              UpdateBillDetailsEvt(
                amount: 200.0,
                billCode: 'BILL123',
                phoneNumber: '1234567890',
              ),
            ),
            expect: () => [
              const BillPaymentState(
                amount: 200.0,
                billCode: 'BILL123',
                phoneNumber: '1234567890',
              ),
              const BillPaymentState(
                amount: 200.0,
                billCode: 'BILL123',
                phoneNumber: '1234567890',
                fee: 0.0,
              ),
            ],
          ),
        ],
      ),

      /// SendOtpEvt Tests
      BABlocTestFeature(
        description: 'SendOtpEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Send OTP successfully
              Given a BillPaymentBloc instance
              When SendOtpEvt is added
              Then the state should reflect OTP sent
            ''',
            setUp: () {
              when(
                () => repository.sendOtpEmail(any()),
              ).thenAnswer((_) async => Future.value('OTP_SENT'));
            },
            build: () => billPaymentBloc,
            act: (bloc) => bloc.add(SendOtpEvt(billId: 'BILL001')),
            expect: () => [
              const BillPaymentState(status: BillPaymentStatus.loading()),
              const BillPaymentState(
                status: BillPaymentStatus.awaitingOtp(),
                otpSent: true,
                transactionId: 'BILL001',
              ),
            ],
          ),
        ],
      ),

      /// ConfirmBillPaymentWithOtpEvt Tests
      BABlocTestFeature(
        description: 'ConfirmBillPaymentWithOtpEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Confirm bill payment with valid OTP
              Given a BillPaymentBloc instance
              When ConfirmBillPaymentWithOtpEvt is added with valid OTP
              Then the state should reflect success
            ''',
            setUp: () {
              when(
                () => repository.confirmPayTheBill(any(), any()),
              ).thenAnswer((_) async => true);
              when(
                () => repository.fetchBills(),
              ).thenAnswer((_) async => [MockBillPaymentData.mockBill]);
            },
            build: () => billPaymentBloc,
            act: (bloc) => bloc.add(
              ConfirmBillPaymentWithOtpEvt(
                billId: 'BILL001',
                otpCode: '123456',
              ),
            ),
            expect: () => [
              const BillPaymentState(status: BillPaymentStatus.loading()),
              BillPaymentState(
                status: const BillPaymentStatus.success(),
                isOtpVerified: true,
                bills: [MockBillPaymentData.mockBill],
              ),
            ],
          ),
        ],
      ),

      /// SelectAccountEvt Tests
      BABlocTestFeature(
        description: 'SelectAccountEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Select an account
              Given a BillPaymentBloc instance
              When SelectAccountEvt is added
              Then the state should reflect the selected account
            ''',
            build: () => billPaymentBloc,
            act: (bloc) =>
                bloc.add(SelectAccountEvt(MockBillPaymentData.mockAccount)),
            expect: () => [
              BillPaymentState(
                selectedAccount: MockBillPaymentData.mockAccount,
                clearCard: true,
              ),
              BillPaymentState(
                selectedAccount: MockBillPaymentData.mockAccount,
                clearCard: true,
                fee: 1.0, // Assuming 1% fee for account
              ),
            ],
          ),
        ],
      ),

      /// PayBillEvt Tests
      BABlocTestFeature(
        description: 'PayBillEvt',
        scenarios: [
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Pay bill successfully
              Given a BillPaymentBloc instance
              When PayBillEvt is added
              Then the state should reflect OTP sent and transaction details
            ''',
            setUp: () {
              when(
                () => repository.payBill(
                  bill: any(named: 'bill'),
                  fromAccountId: any(named: 'fromAccountId'),
                  fromCardId: any(named: 'fromCardId'),
                ),
              ).thenAnswer((_) async => MockBillPaymentData.mockBill);
              when(
                () => repository.sendOtpEmail(any()),
              ).thenAnswer((_) async => Future.value('OTP_SENT'));
            },
            build: () => billPaymentBloc,
            seed: () => BillPaymentState(
              selectedAccount: MockBillPaymentData.mockAccount,
            ),
            act: (bloc) => bloc.add(
              PayBillEvt(
                bill: MockBillPaymentData.mockBill,
                paymentMethodId: 'PAY123',
              ),
            ),
            expect: () => [
              BillPaymentState(
                status: BillPaymentStatus.loading(),
                selectedAccount: MockBillPaymentData.mockAccount,
              ),
              BillPaymentState(
                selectedBill: MockBillPaymentData.mockBill,
                status: const BillPaymentStatus.awaitingOtp(),
                otpSent: true,
                transactionId: MockBillPaymentData.mockBill.id,
                billId: MockBillPaymentData.mockBill.id,
                selectedAccount: null,
                selectedCard: null,
              ),
            ],
          ),
          BABlocTestScenario<BillPaymentBloc, BillPaymentState>(
            description: '''
              Scenario: Pay bill fails
              Given a BillPaymentBloc instance
              When PayBillEvt is added and repository throws an error
              Then the state should reflect failure
            ''',
            setUp: () {
              when(
                () => repository.payBill(
                  bill: any(named: 'bill'),
                  fromAccountId: any(named: 'fromAccountId'),
                  fromCardId: any(named: 'fromCardId'),
                ),
              ).thenThrow(Exception('Payment failed'));
            },
            build: () => billPaymentBloc,
            act: (bloc) => bloc.add(
              PayBillEvt(
                bill: MockBillPaymentData.mockBill,
                paymentMethodId: 'PAY123',
              ),
            ),
            expect: () => [
              const BillPaymentState(status: BillPaymentStatus.loading()),
              const BillPaymentState(
                status: BillPaymentStatus.failure(),
                errorMessage: 'Bill payment failed',
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
