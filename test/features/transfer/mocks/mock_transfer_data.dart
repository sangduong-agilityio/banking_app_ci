import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';

/// Mock data for transfer feature tests
class MockTransferData {
  // Mock Accounts
  static final mockAccount1 = AccountModel(
    id: '1',
    accountNumber: '1234567890',
    accountType: 'Savings',
    availableBalance: 10000,
    userId: 'user1',
    branch: 'Main Branch',
    bankId: 'bank1',
  );

  static final mockAccount2 = AccountModel(
    id: '2',
    accountNumber: '0987654321',
    accountType: 'Current',
    availableBalance: 5000,
    userId: 'user1',
    branch: 'Downtown Branch',
    bankId: 'bank1',
  );

  static final mockAccounts = [mockAccount1, mockAccount2];

  // Mock Cards
  static final mockCard1 = CardModel(
    id: '1',
    cardNumber: '4111111111111111',
    cardType: CardType.visa,
    availableBalance: 5000,
    userId: 'user1',
    bankId: 'bank1',
    cardHolderName: 'John Doe',
    cardTier: 'Gold',
  );

  static final mockCard2 = CardModel(
    id: '2',
    cardNumber: '5555555555554444',
    cardType: CardType.discover,
    availableBalance: 3000,
    userId: 'user1',
    bankId: 'bank1',
    cardHolderName: 'John Doe',
    cardTier: 'Platinum',
  );

  static final mockCards = [mockCard1, mockCard2];

  // Mock Banks
  static final mockBank1 = BankModel(
    id: 'bank1',
    name: 'ABC Bank',
    code: 'ABC',
  );

  static final mockBank2 = BankModel(
    id: 'bank2',
    name: 'XYZ Bank',
    code: 'XYZ',
  );

  static final mockBanks = [mockBank1, mockBank2];

  // Mock Branches
  static final mockBranch1 = BranchModel(
    id: 'branch1',
    name: 'Main Branch',
    bankId: 'bank1',
  );

  static final mockBranch2 = BranchModel(
    id: 'branch2',
    name: 'Downtown Branch',
    bankId: 'bank1',
  );

  static final mockBranches = [mockBranch1, mockBranch2];

  // Mock Beneficiaries
  static final mockBeneficiary1 = BeneficiaryModel(
    id: '1',
    name: 'John Doe',
    accountNumber: '9876543210',
    bankId: 'bank1',
    bankName: 'ABC Bank',
    branch: 'Main Branch',
    avatarUrl: null,
  );

  static final mockBeneficiary2 = BeneficiaryModel(
    id: '2',
    name: 'Jane Smith',
    accountNumber: '1122334455',
    bankId: 'bank2',
    bankName: 'XYZ Bank',
    branch: 'Downtown Branch',
    avatarUrl: null,
  );

  static final mockBeneficiary3 = BeneficiaryModel(
    id: '3',
    name: 'Bob Johnson',
    accountNumber: '5544332211',
    bankId: 'bank1',
  );

  static final mockBeneficiaries = [
    mockBeneficiary1,
    mockBeneficiary2,
    mockBeneficiary3,
  ];
}
