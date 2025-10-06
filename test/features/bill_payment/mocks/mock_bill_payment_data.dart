import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';
import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/bill_payment/repositories/bill_payment_repository.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:mocktail/mocktail.dart';

class BillPaymentRepositoryMock extends Mock implements BillPaymentRepository {}

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
  static final mockCard = null;
}
