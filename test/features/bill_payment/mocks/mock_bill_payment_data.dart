import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/data/models/company_model.dart';
import 'package:banking_app/features/bill_payment/data/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BillPaymentRepositoryMock extends Mock implements BillPaymentRepository {}

// Mocks
class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder {}

// In your mock data
class MockBillPaymentData {
  static final mockBillType = BillType.electric;

  static final mockBill = BillPaymentModel(id: 'BILL001', amount: 100.0);

  static final mockCompany = CompanyModel(
    id: 'COMP001',
    name: 'Electricity Provider',
  );

  static final mockAccount = AccountModel(
    id: '1',
    accountNumber: '1234567890',
    accountType: 'Savings',
    availableBalance: 10000,
    userId: 'user1',
    branch: 'Main Branch',
    bankId: 'bank1',
  );

  static final mockCard = CardModel(
    currency: 'USD',
    id: 'card-1',
    cardNumber: '4111111111111111',
    cardHolderName: 'John Doe',
    availableBalance: 3000.0,
    userId: 'user1',
    cardType: CardType.visa,
    cardTier: 'Gold',
    bankId: 'bank1',
  );

  static final CardModel? mockCardOptional = null;
}
