import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transfer/data/models/transfer_model.dart';
import 'package:banking_app/features/transfer/data/repositories/transfer_repository.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/utils.dart';
import '../mocks/mock_transfer_data.dart';

void main() {
  late TransferRepositoryMock transferRepo;
  late BiometricServiceMock biometricService;
  late TransferBloc transferBloc;

  setUpAll(() {
    registerFallbackValue(MockTransferData.mockBeneficiary1);
    registerFallbackValue(
      TransferModel(
        fromAccount: MockTransferData.mockAccount1,
        toBeneficiary: MockTransferData.mockBeneficiary1,
        amount: 100.0,
        transactionFee: 0,
        content: '',
        transferType: TransferType.cardNumber,
      ),
    );
    registerFallbackValue(MockTransferData.mockAccount1);
    registerFallbackValue(MockTransferData.mockCard1);
  });

  setUp(() {
    transferRepo = TransferRepositoryMock();
    biometricService = BiometricServiceMock();
    transferBloc = TransferBloc(
      transferRepo: transferRepo,
      biometricService: biometricService,
    );
  });

  tearDown(() {
    transferBloc.close();
  });

  BABlocTest(
    description: 'TransferBloc Tests',
    features: [
      /// TransferInitializeEvt Tests
      BABlocTestFeature(
        description: 'TransferInitializeEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Initialize transfer data successfully
              Given a TransferBloc instance
              When TransferInitializeEvt is added
              Then the state should contain the loaded data
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchBeneficiaries(),
              ).thenAnswer((_) async => MockTransferData.mockBeneficiaries);
              when(
                () => transferRepo.fetchBanks(),
              ).thenAnswer((_) async => MockTransferData.mockBanks);
              when(
                () => transferRepo.fetchBranches(),
              ).thenAnswer((_) async => MockTransferData.mockBranches);
              when(
                () => transferRepo.fetchAccounts(),
              ).thenAnswer((_) async => MockTransferData.mockAccounts);
              when(
                () => transferRepo.fetchCards(),
              ).thenAnswer((_) async => MockTransferData.mockCards);
              when(
                () => biometricService.canCheckBiometrics(),
              ).thenAnswer((_) async => true);
              when(
                () => biometricService.isBiometricEnabled(),
              ).thenAnswer((_) async => true);
            },
            build: () => transferBloc,
            act: (bloc) => bloc.add(TransferInitializeEvt()),
            expect: () => [
              const TransferState(status: TransferStatus.loading()),
              TransferState(
                status: const TransferStatus.initial(),
                beneficiaries: MockTransferData.mockBeneficiaries,
                banks: MockTransferData.mockBanks,
                branches: MockTransferData.mockBranches,
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                filteredBeneficiaries: MockTransferData.mockBeneficiaries,
                biometricAvailable: true,
                biometricEnabled: true,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Initialize transfer data with biometric unavailable
              Given a TransferBloc instance
              When TransferInitializeEvt is added and biometric is unavailable
              Then the state should reflect biometric unavailable
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchBeneficiaries(),
              ).thenAnswer((_) async => MockTransferData.mockBeneficiaries);
              when(
                () => transferRepo.fetchBanks(),
              ).thenAnswer((_) async => MockTransferData.mockBanks);
              when(
                () => transferRepo.fetchBranches(),
              ).thenAnswer((_) async => MockTransferData.mockBranches);
              when(
                () => transferRepo.fetchAccounts(),
              ).thenAnswer((_) async => MockTransferData.mockAccounts);
              when(
                () => transferRepo.fetchCards(),
              ).thenAnswer((_) async => MockTransferData.mockCards);
              when(
                () => biometricService.canCheckBiometrics(),
              ).thenAnswer((_) async => false);
              when(
                () => biometricService.isBiometricEnabled(),
              ).thenAnswer((_) async => false);
            },
            build: () => transferBloc,
            act: (bloc) => bloc.add(TransferInitializeEvt()),
            expect: () => [
              const TransferState(status: TransferStatus.loading()),
              TransferState(
                status: const TransferStatus.initial(),
                beneficiaries: MockTransferData.mockBeneficiaries,
                banks: MockTransferData.mockBanks,
                branches: MockTransferData.mockBranches,
                accounts: MockTransferData.mockAccounts,
                cards: MockTransferData.mockCards,
                filteredBeneficiaries: MockTransferData.mockBeneficiaries,
                biometricAvailable: false,
                biometricEnabled: false,
              ),
            ],
          ),
        ],
      ),

      /// BeneficiariesInitializeEvt Tests
      BABlocTestFeature(
        description: 'BeneficiariesInitializeEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Initialize beneficiaries from event
              Given a TransferBloc instance
              When BeneficiariesInitializeEvt is added
              Then the state should contain beneficiaries and banks
            ''',
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              BeneficiariesInitializeEvt(
                beneficiaries: MockTransferData.mockBeneficiaries,
                banks: MockTransferData.mockBanks,
              ),
            ),
            expect: () => [
              TransferState(
                beneficiaries: MockTransferData.mockBeneficiaries,
                banks: MockTransferData.mockBanks,
                filteredBeneficiaries: MockTransferData.mockBeneficiaries,
              ),
            ],
          ),
        ],
      ),

      /// SelectAccountEvt Tests
      BABlocTestFeature(
        description: 'SelectAccountEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select an account
              Given a TransferBloc instance
              When SelectAccountEvt is added
              Then the state should reflect the selected account
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchAccountTransactionLimit(any()),
              ).thenAnswer((_) async => 1000.0);
            },
            build: () => transferBloc,
            act: (bloc) =>
                bloc.add(SelectAccountEvt(MockTransferData.mockAccount1)),
            expect: () => [
              TransferState(
                selectedAccount: MockTransferData.mockAccount1,
                selectedCard: null,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select account clears previously selected card
              Given a TransferBloc with a selected card
              When SelectAccountEvt is added
              Then the card should be cleared
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchAccountTransactionLimit(any()),
              ).thenAnswer((_) async => 1000.0);
            },
            build: () => transferBloc,
            seed: () => TransferState(selectedCard: MockTransferData.mockCard1),
            act: (bloc) =>
                bloc.add(SelectAccountEvt(MockTransferData.mockAccount2)),
            expect: () => [
              TransferState(
                selectedAccount: MockTransferData.mockAccount2,
                selectedCard: null,
              ),
            ],
          ),
        ],
      ),

      /// SelectCardEvt Tests
      BABlocTestFeature(
        description: 'SelectCardEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select a card
              Given a TransferBloc instance
              When SelectCardEvt is added
              Then the state should reflect the selected card
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchCardTransactionLimit(any()),
              ).thenAnswer((_) async => 1000.0);
            },
            build: () => transferBloc,
            act: (bloc) => bloc.add(SelectCardEvt(MockTransferData.mockCard1)),
            expect: () => [
              TransferState(
                selectedCard: MockTransferData.mockCard1,
                selectedAccount: null,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select card clears previously selected account
              Given a TransferBloc with a selected account
              When SelectCardEvt is added
              Then the account should be cleared
            ''',
            setUp: () {
              when(
                () => transferRepo.fetchCardTransactionLimit(any()),
              ).thenAnswer((_) async => 1000.0);
            },
            build: () => transferBloc,
            seed: () =>
                TransferState(selectedAccount: MockTransferData.mockAccount1),
            act: (bloc) => bloc.add(SelectCardEvt(MockTransferData.mockCard2)),
            expect: () => [
              TransferState(
                selectedCard: MockTransferData.mockCard2,
                selectedAccount: null,
              ),
            ],
          ),
        ],
      ),

      /// SelectTransferTypeEvt Tests
      BABlocTestFeature(
        description: 'SelectTransferTypeEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select internal transfer type
              Given a TransferBloc instance
              When SelectTransferTypeEvt is added with internal type
              Then the state should reflect the selected type
            ''',
            build: () => transferBloc,
            act: (bloc) =>
                bloc.add(SelectTransferTypeEvt(TransferType.cardNumber)),
            expect: () => [
              const TransferState(
                selectedTransferType: TransferType.cardNumber,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select external transfer type
              Given a TransferBloc instance
              When SelectTransferTypeEvt is added with external type
              Then the state should reflect the selected type
            ''',
            build: () => transferBloc,
            act: (bloc) =>
                bloc.add(SelectTransferTypeEvt(TransferType.cardNumber)),
            expect: () => [
              const TransferState(
                selectedTransferType: TransferType.cardNumber,
              ),
            ],
          ),
        ],
      ),

      /// SelectBeneficiaryEvt Tests
      BABlocTestFeature(
        description: 'SelectBeneficiaryEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select a beneficiary
              Given a TransferBloc instance
              When SelectBeneficiaryEvt is added
              Then the state should reflect the selected beneficiary
            ''',
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              SelectBeneficiaryEvt(MockTransferData.mockBeneficiary1),
            ),
            expect: () => [
              TransferState(
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
              ),
            ],
          ),
        ],
      ),

      /// SelectBankEvt Tests
      BABlocTestFeature(
        description: 'SelectBankEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select a bank
              Given a TransferBloc instance
              When SelectBankEvt is added
              Then the state should reflect the selected bank
            ''',
            build: () => transferBloc,
            act: (bloc) => bloc.add(SelectBankEvt(MockTransferData.mockBank1)),
            expect: () => [
              TransferState(
                selectedBank: MockTransferData.mockBank1,
                selectedBranch: null,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select bank clears previously selected branch
              Given a TransferBloc with a selected branch
              When SelectBankEvt is added
              Then the branch should be cleared
            ''',

            build: () => transferBloc,
            seed: () => TransferState(
              beneficiaries: MockTransferData.mockBeneficiaries,
              filteredBeneficiaries: MockTransferData.mockBeneficiaries,
              selectedBank: MockTransferData.mockBank1,
              selectedBranch: MockTransferData.mockBranch1,
            ),
            act: (bloc) => bloc.add(SelectBankEvt(MockTransferData.mockBank2)),
            expect: () => [
              TransferState(
                beneficiaries: MockTransferData.mockBeneficiaries,
                filteredBeneficiaries: MockTransferData.mockBeneficiaries,
                selectedBank: MockTransferData.mockBank2,
                selectedBranch: null,
                sameBankBeneficiaries: const [],
                otherBankBeneficiaries: const [],
                viaCardBeneficiaries: const [],
              ),
            ],
          ),
        ],
      ),

      /// SelectBranchEvt Tests
      BABlocTestFeature(
        description: 'SelectBranchEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Select a branch
              Given a TransferBloc instance
              When SelectBranchEvt is added
              Then the state should reflect the selected branch
            ''',
            build: () => transferBloc,
            act: (bloc) =>
                bloc.add(SelectBranchEvt(MockTransferData.mockBranch1)),
            expect: () => [
              TransferState(selectedBranch: MockTransferData.mockBranch1),
            ],
          ),
        ],
      ),

      /// UpdateTransferDetailsEvt Tests
      BABlocTestFeature(
        description: 'UpdateTransferDetailsEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Update transfer details
              Given a TransferBloc instance
              When UpdateTransferDetailsEvt is added
              Then the state should reflect the updated details
            ''',
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              UpdateTransferDetailsEvt(
                amount: 200.0,
                content: 'Payment for services',
                name: 'John Doe',
              ),
            ),
            expect: () => [
              const TransferState(
                amount: 200.0,
                content: 'Payment for services',
                name: 'John Doe',
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Update only amount
              Given a TransferBloc instance with existing data
              When UpdateTransferDetailsEvt is added with only amount
              Then only amount should be updated
            ''',
            build: () => transferBloc,
            seed: () => const TransferState(
              content: 'Previous content',
              name: 'Previous name',
            ),
            act: (bloc) => bloc.add(UpdateTransferDetailsEvt(amount: 500.0)),
            expect: () => [
              const TransferState(
                amount: 500.0,
                content: 'Previous content',
                name: 'Previous name',
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Update with saveToDirectory flag
              Given a TransferBloc instance
              When UpdateTransferDetailsEvt is added with saveToDirectory
              Then the flag should be updated
            ''',
            build: () => transferBloc,
            act: (bloc) =>
                bloc.add(UpdateTransferDetailsEvt(saveToDirectory: true)),
            expect: () => [const TransferState(saveToDirectory: true)],
          ),
        ],
      ),

      /// FillTransferDetailsEvt Tests
      BABlocTestFeature(
        description: 'FillTransferDetailsEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Fill transfer details with amount and content
              Given a TransferBloc instance
              When FillTransferDetailsEvt is added
              Then the state should reflect filled details
            ''',
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              FillTransferDetailsEvt(
                amount: 1000.0,
                content: 'Monthly payment',
              ),
            ),
            expect: () => [
              const TransferState(amount: 1000.0, content: 'Monthly payment'),
            ],
          ),
        ],
      ),

      /// SearchBeneficiaryEvt Tests
      BABlocTestFeature(
        description: 'SearchBeneficiaryEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Search beneficiaries by name
              Given a TransferBloc with beneficiaries
              When SearchBeneficiaryEvt is added with a name query
              Then filtered beneficiaries should match the query
            ''',
            build: () => transferBloc,
            seed: () => TransferState(
              beneficiaries: MockTransferData.mockBeneficiaries,
            ),
            act: (bloc) => bloc.add(SearchBeneficiaryEvt('Jane')),
            expect: () => [
              TransferState(
                beneficiaries: MockTransferData.mockBeneficiaries,
                searchQuery: 'Jane',
                filteredBeneficiaries: [MockTransferData.mockBeneficiary2],
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Search beneficiaries by account number
              Given a TransferBloc with beneficiaries
              When SearchBeneficiaryEvt is added with account number
              Then filtered beneficiaries should match the query
            ''',
            build: () => transferBloc,
            seed: () => TransferState(
              beneficiaries: MockTransferData.mockBeneficiaries,
            ),
            act: (bloc) => bloc.add(SearchBeneficiaryEvt('9876543210')),
            expect: () => [
              TransferState(
                beneficiaries: MockTransferData.mockBeneficiaries,
                searchQuery: '9876543210',
                filteredBeneficiaries: [MockTransferData.mockBeneficiary1],
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Clear search with empty query
              Given a TransferBloc with filtered beneficiaries
              When SearchBeneficiaryEvt is added with empty query
              Then all beneficiaries should be shown
            ''',
            build: () => transferBloc,
            seed: () => TransferState(
              beneficiaries: MockTransferData.mockBeneficiaries,
              searchQuery: 'Previous',
              filteredBeneficiaries: [MockTransferData.mockBeneficiary1],
            ),
            act: (bloc) => bloc.add(SearchBeneficiaryEvt('')),
            expect: () => [
              TransferState(
                beneficiaries: MockTransferData.mockBeneficiaries,
                searchQuery: '',
                filteredBeneficiaries: MockTransferData.mockBeneficiaries,
              ),
            ],
          ),
        ],
      ),

      /// CalculateTransactionFeeEvt Tests
      BABlocTestFeature(
        description: 'CalculateTransactionFeeEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Calculate transaction fee successfully
              Given a TransferBloc with valid transfer details
              When CalculateTransactionFeeEvt is added
              Then the state should reflect the calculated fee
            ''',
            setUp: () {
              when(() => transferRepo.calculateFee(any())).thenAnswer(
                (_) async =>
                    TransferFee(amount: 100.0, fee: 10.0, total: 110.0),
              );
            },
            build: () => transferBloc,
            seed: () => TransferState(
              selectedAccount: MockTransferData.mockAccount1,
              selectedBeneficiary: MockTransferData.mockBeneficiary1,
              amount: 100.0,
            ),
            act: (bloc) => bloc.add(const CalculateTransactionFeeEvt(100.0)),
            expect: () => [
              TransferState(
                status: const TransferStatus.loading(),
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              ),
              TransferState(
                status: const TransferStatus.initial(),
                transactionFee: 10.0,
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 100.0,
              ),
            ],
          ),
        ],
      ),

      /// AddNewBeneficiaryEvt Tests
      BABlocTestFeature(
        description: 'AddNewBeneficiaryEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Add new beneficiary successfully
              Given a TransferBloc instance
              When AddNewBeneficiaryEvt is added
              Then the new beneficiary should be added to state
            ''',
            setUp: () {
              when(
                () => transferRepo.addNewBeneficiary(any()),
              ).thenAnswer((_) async => MockTransferData.mockBeneficiary3);
            },
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              AddNewBeneficiaryEvt(MockTransferData.mockBeneficiary3),
            ),
            expect: () => [
              const TransferState(status: TransferStatus.loading()),
              TransferState(
                status: const TransferStatus.success(),
                newBeneficiary: MockTransferData.mockBeneficiary3,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Add new beneficiary fails
              Given a TransferBloc instance
              When AddNewBeneficiaryEvt is added and repo throws error
              Then the state should reflect failure
            ''',
            setUp: () {
              when(
                () => transferRepo.addNewBeneficiary(any()),
              ).thenThrow(Exception('Network error'));
            },
            build: () => transferBloc,
            act: (bloc) => bloc.add(
              AddNewBeneficiaryEvt(MockTransferData.mockBeneficiary3),
            ),
            expect: () => [
              const TransferState(status: TransferStatus.loading()),
              const TransferState(
                status: TransferStatus.failure(),
                errorMessage: 'Failed to add beneficiary',
                otpSent: false,
              ),
            ],
          ),
        ],
      ),

      /// ConfirmTransferEvt Tests
      BABlocTestFeature(
        description: 'ConfirmTransferEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Confirm transfer successfully
              Given a TransferBloc with complete transfer details
              When ConfirmTransferEvt is added
              Then the transfer should be initiated
            ''',
            setUp: () {
              when(() => transferRepo.initiateTransfer(any())).thenAnswer(
                (_) async => TransferResult(
                  success: true,
                  transferId: 'TRF123',
                  message: 'Transfer initiated successfully',
                ),
              );
            },
            build: () => transferBloc,
            seed: () => TransferState(
              selectedAccount: MockTransferData.mockAccount1,
              selectedBeneficiary: MockTransferData.mockBeneficiary1,
              amount: 500.0,
              transactionFee: 10.0,
              content: 'Payment',
            ),
            act: (bloc) => bloc.add(ConfirmTransferEvt()),
            expect: () => [
              TransferState(
                status: const TransferStatus.loading(),
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 500.0,
                transactionFee: 10.0,
                content: 'Payment',
              ),
              TransferState(
                status: const TransferStatus.initial(),
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 500.0,
                transactionFee: 10.0,
                content: 'Payment',
                transferId: 'TRF123',
                otpSent: false,
                transaction: TransactionModel(
                  id: 'TRF123',
                  userId: 'user1',
                  amount: 500.0,
                  type: TransferType.cardNumber,
                ),
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Confirm transfer fails
              Given a TransferBloc with complete transfer details
              When ConfirmTransferEvt is added and repo throws error
              Then the state should reflect failure
            ''',
            setUp: () {
              when(
                () => transferRepo.initiateTransfer(any()),
              ).thenThrow(Exception('Insufficient balance'));
            },
            build: () => transferBloc,
            seed: () => TransferState(
              selectedAccount: MockTransferData.mockAccount1,
              selectedBeneficiary: MockTransferData.mockBeneficiary1,
              amount: 500.0,
            ),
            act: (bloc) => bloc.add(ConfirmTransferEvt()),
            expect: () => [
              TransferState(
                status: const TransferStatus.loading(),
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 500.0,
              ),
              TransferState(
                status: const TransferStatus.failure(),
                errorMessage: 'Transfer confirmation failed',
                selectedAccount: MockTransferData.mockAccount1,
                selectedBeneficiary: MockTransferData.mockBeneficiary1,
                amount: 500.0,
                otpSent: false,
              ),
            ],
          ),
        ],
      ),

      /// SendOtpEvt Tests
      BABlocTestFeature(
        description: 'SendOtpEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Send OTP successfully
              Given a TransferBloc with a transfer ID
              When SendOtpEvt is added
              Then OTP should be sent
            ''',
            setUp: () {
              when(
                () => transferRepo.sendOtpEmail(any()),
              ).thenAnswer((_) async => Future.value());
            },
            build: () => transferBloc,
            seed: () => const TransferState(transferId: 'TRF123'),
            act: (bloc) => bloc.add(SendOtpEvt(transferId: 'TRF123')),
            expect: () => [
              const TransferState(
                status: TransferStatus.loading(),
                transferId: 'TRF123',
              ),
              const TransferState(
                status: TransferStatus.awaitingOtp(),
                transferId: 'TRF123',
                otpSent: true,
              ),
            ],
          ),
        ],
      ),

      /// ConfirmTransferWithOtpEvt Tests
      BABlocTestFeature(
        description: 'ConfirmTransferWithOtpEvt',
        scenarios: [
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Confirm transfer with valid OTP
              Given a TransferBloc with OTP sent
              When ConfirmTransferWithOtpEvt is added with valid OTP
              Then the transfer should be confirmed
            ''',
            setUp: () {
              when(
                () => transferRepo.verifyOTP(any(), any()),
              ).thenAnswer((_) async => true);
              when(
                () => transferRepo.confirmTransfer(any(), any()),
              ).thenAnswer((_) async => true);
            },
            build: () => transferBloc,
            seed: () =>
                const TransferState(transferId: 'TRF123', otpSent: true),
            act: (bloc) => bloc.add(
              ConfirmTransferWithOtpEvt(
                transferId: '123456',
                otpCode: 'TRF123',
              ),
            ),
            expect: () => [
              const TransferState(
                status: TransferStatus.loading(),
                transferId: 'TRF123',
                otpSent: true,
              ),
              const TransferState(
                status: TransferStatus.success(),
                transferId: 'TRF123',
                otpSent: false,
                errorMessage: null,
              ),
            ],
          ),
          BABlocTestScenario<TransferBloc, TransferState>(
            description: '''
              Scenario: Confirm transfer with invalid OTP
              Given a TransferBloc with OTP sent
              When ConfirmTransferWithOtpEvt is added with invalid OTP
              Then the state should reflect failure
            ''',
            setUp: () {
              when(
                () => transferRepo.verifyOTP(any(), any()),
              ).thenAnswer((_) async => false);
            },
            build: () => transferBloc,
            seed: () =>
                const TransferState(transferId: 'TRF123', otpSent: true),
            act: (bloc) => bloc.add(
              ConfirmTransferWithOtpEvt(
                transferId: '123456',
                otpCode: 'WRONG123',
              ),
            ),
            expect: () => [
              const TransferState(
                status: TransferStatus.loading(),
                transferId: 'TRF123',
                otpSent: true,
              ),
              const TransferState(
                status: TransferStatus.failure(),
                transferId: 'TRF123',
                otpSent: true,
                errorMessage: 'Invalid OTP code',
              ),
            ],
          ),
        ],
      ),
    ],
  ).test();
}
