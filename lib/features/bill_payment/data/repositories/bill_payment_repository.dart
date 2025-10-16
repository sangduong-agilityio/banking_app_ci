import 'dart:math';
import 'package:banking_app/features/bill_payment/data/models/company_model.dart';
import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/features/bill_payment/data/models/bill_payment_model.dart';

/// Abstract repository for handling bill payment operations.
abstract class BillPaymentRepository {
  /// Fetches a list of the user's past bill payments.
  Future<List<BillPaymentModel>> fetchBills();

  /// Fetches a list of the user's bank accounts.
  Future<List<AccountModel>> fetchAccounts();

  /// Fetches a list of the user's credit/debit cards.
  Future<List<CardModel>> fetchCards();

  /// Fetches a list of companies for a specific bill type (e.g., electricity, water).
  Future<List<CompanyModel>> fetchCompanies(BillType type);

  /// Sends a One-Time Password (OTP) to the user's registered email for a specific bill.
  Future<String> sendOtpEmail(String billId);

  /// Initiates a bill payment by creating a pending transaction.
  Future<BillPaymentModel> payBill({
    required BillPaymentModel bill,
    String? fromAccountId,
    String? fromCardId,
  });

  /// Confirms and completes a bill payment using an OTP or biometric authentication.
  Future<bool> confirmPayTheBill(String billId, String otpCode);
}

const String _biometricAuth = 'BIOMETRIC_AUTH';

/// Implementation of the [BillPaymentRepository] that uses Supabase for data persistence.
class BillPaymentRepositoryImpl implements BillPaymentRepository {
  final SupabaseClient _client;

  BillPaymentRepositoryImpl({required SupabaseClient client})
    : _client = client;

  /// Gets the current authenticated user, throwing an exception if not found.
  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user;
  }

  @override
  Future<List<AccountModel>> fetchAccounts() async {
    final response = await _client
        .from('accounts')
        .select()
        .eq('userId', _currentUser.id);
    return (response as List)
        .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    final response = await _client
        .from('cards')
        .select()
        .eq('userId', _currentUser.id);
    return (response as List)
        .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BillPaymentModel>> fetchBills() async {
    final response = await _client
        .from('bill_payments')
        .select('''
          *,
          user:userId(username),
          company:companyId(*),
          fromAccount:fromAccountId(*),
          fromCard:fromCardId(*)
        ''')
        .eq('userId', _currentUser.id)
        .order('createdAt', ascending: false);

    return (response as List<dynamic>)
        .map((json) => BillPaymentModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CompanyModel>> fetchCompanies(BillType type) async {
    final response = await _client
        .from('companies')
        .select('*')
        .eq('billType', type.name);

    return (response as List<dynamic>)
        .map((json) => CompanyModel.fromJson(json))
        .toList();
  }

  @override
  Future<String> sendOtpEmail(String billId) async {
    final otpCode = _generateOtp();
    final expiresAt = DateTime.now()
        .add(const Duration(minutes: 5))
        .toIso8601String();

    await _client.from('bill_payment_otps').upsert({
      'billId': billId,
      'otpCode': otpCode,
      'expiresAt': expiresAt,
      'userId': _currentUser.id,
      'isUsed': false,
    });
    print('OTP sent to: ${_currentUser.email}');
    print('OTP Code: $otpCode');

    return otpCode;
  }

  @override
  Future<bool> confirmPayTheBill(String billId, String otpCode) async {
    // Verify OTP (skip for biometric)
    if (otpCode != _biometricAuth) {
      final isValid = await _verifyOtp(billId, otpCode);
      if (!isValid) return false;
    }

    // Get bill and transaction info
    final bill = await _client
        .from('bill_payments')
        .select('id, transactionId')
        .eq('id', billId)
        .maybeSingle();

    if (bill == null || bill['transactionId'] == null) {
      throw Exception('Bill or Transaction not found');
    }

    // Update transaction to completed
    await _client
        .from('transactions')
        .update({
          'status': TransactionStatus.completed.name,
          'completedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', bill['transactionId']);

    // Mark OTP as used
    if (otpCode != _biometricAuth) {
      await _client
          .from('bill_payment_otps')
          .update({'isUsed': true})
          .eq('billId', billId)
          .eq('otpCode', otpCode);
    }

    return true;
  }

  @override
  Future<BillPaymentModel> payBill({
    required BillPaymentModel bill,
    String? fromAccountId,
    String? fromCardId,
  }) async {
    // Validate inputs
    _validateBillAmount(bill.amount);
    _validatePaymentMethod(fromAccountId, fromCardId);

    final totalAmount = _calculateTotal(bill);

    // Check sufficient balance
    await _checkBalance(fromAccountId, fromCardId, totalAmount);

    // Create transaction
    final transactionId = await _createTransaction(
      bill: bill,
      totalAmount: totalAmount,
      fromAccountId: fromAccountId,
      fromCardId: fromCardId,
    );

    /// Create bill payment record
    final billPayment = await _createBillPayment(
      bill: bill,
      transactionId: transactionId,
      fromAccountId: fromAccountId,
      fromCardId: fromCardId,
    );

    return billPayment;
  }

  /// Helper Methods

  /// Generates a random 6-digit OTP.
  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Verifies the provided OTP against the database.
  Future<bool> _verifyOtp(String billId, String otpCode) async {
    final response = await _client
        .from('bill_payment_otps')
        .select()
        .eq('billId', billId)
        .eq('otpCode', otpCode)
        .eq('isUsed', false)
        .gte('expiresAt', DateTime.now().toIso8601String())
        .maybeSingle();

    return response != null;
  }

  /// Validates that the bill amount is greater than zero.
  void _validateBillAmount(double? amount) {
    if (amount == null || amount <= 0) {
      throw Exception('Invalid bill amount');
    }
  }

  /// Validates that a payment method (account or card) has been selected.
  void _validatePaymentMethod(String? fromAccountId, String? fromCardId) {
    if (fromAccountId == null && fromCardId == null) {
      throw Exception('Please select a payment method');
    }
  }

  /// Calculates the total amount including tax and fee.
  double _calculateTotal(BillPaymentModel bill) {
    return (bill.amount ?? 0.0) + (bill.tax ?? 0.0) + (bill.fee ?? 0.0);
  }

  /// Checks if the selected account or card has sufficient balance.
  Future<void> _checkBalance(
    String? fromAccountId,
    String? fromCardId,
    double totalAmount,
  ) async {
    if (fromAccountId != null) {
      final acc = await _client
          .from('accounts')
          .select('availableBalance')
          .eq('id', fromAccountId)
          .single();

      final available = (acc['availableBalance'] as num).toDouble();
      if (available < totalAmount) {
        throw Exception('Insufficient funds in account');
      }
    } else if (fromCardId != null) {
      final card = await _client
          .from('cards')
          .select('availableBalance')
          .eq('id', fromCardId)
          .single();

      final available = (card['availableBalance'] as num).toDouble();
      if (available < totalAmount) {
        throw Exception('Insufficient funds on card');
      }
    }
  }

  /// Creates a new transaction record in the database.
  Future<String> _createTransaction({
    required BillPaymentModel bill,
    required double totalAmount,
    String? fromAccountId,
    String? fromCardId,
  }) async {
    final txnInsert = await _client
        .from('transactions')
        .insert({
          'userId': _currentUser.id,
          'type': TransferType.cardNumber.name,
          'amount': -totalAmount,
          'fromAccountId': fromAccountId,
          'fromCardId': fromCardId,
          'recipientName': bill.company?.name,
          'recipientAccount': bill.billCode,
          'transactionFee': bill.fee ?? 0.0,
          'status': TransactionStatus.pending.name,
          'category': bill.billType?.name,
          'referenceNumber': 'TXN${DateTime.now().millisecondsSinceEpoch}',
          'createdAt': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return txnInsert['id'] as String;
  }

  /// Creates a new bill payment record in the database.
  Future<BillPaymentModel> _createBillPayment({
    required BillPaymentModel bill,
    required String transactionId,
    String? fromAccountId,
    String? fromCardId,
  }) async {
    final billInsert = await _client
        .from('bill_payments')
        .insert({
          'userId': _currentUser.id,
          'companyId': bill.companyId ?? bill.company?.id,
          'billType': bill.billType?.name,
          'billCode': bill.billCode,
          'phoneNumber': bill.phoneNumber,
          'address': bill.address,
          'amount': bill.amount,
          'fee': bill.fee ?? 0.0,
          'tax': bill.tax ?? 0.0,
          'transactionId': transactionId,
          'fromAccountId': fromAccountId,
          'fromCardId': fromCardId,
          'startDate': bill.startDate?.toIso8601String(),
          'endDate': bill.endDate?.toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
        })
        .select('''
      *,
      company:companyId(*),
      fromAccount:fromAccountId(*),
      fromCard:fromCardId(*)
    ''')
        .single();

    return BillPaymentModel.fromJson(billInsert);
  }
}
