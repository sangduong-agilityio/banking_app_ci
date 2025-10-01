import 'dart:math';

import 'package:banking_app/features/bill_payment/models/company_model.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/features/bill_payment/models/bill_payment_model.dart';

abstract class BillPaymentRepository {
  Future<List<BillPaymentModel>> fetchBills();
  Future<List<AccountModel>> fetchAccounts();
  Future<List<CardModel>> fetchCards();
  Future<List<CompanyModel>> fetchCompanies(BillType type);
  Future<void> sendOtpEmail(String billId);
  Future<bool> verifyOTP(String billId, String otpCode);
  Future<BillPaymentModel> payBill({
    required BillPaymentModel bill,
    String? fromAccountId,
    String? fromCardId,
  });
  Future<bool> confirmPayTheBill(String billId, String otpCode);
}

class BillPaymentRepositoryImpl implements BillPaymentRepository {
  final SupabaseClient _client;

  BillPaymentRepositoryImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<AccountModel>> fetchAccounts() async {
    final currentUser = _client.auth.currentUser;
    final response = await _client
        .from('accounts')
        .select()
        .eq('userId', currentUser?.id ?? '');
    return (response as List)
        .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    final currentUser = _client.auth.currentUser;
    final response = await _client
        .from('cards')
        .select()
        .eq('userId', currentUser?.id ?? '');
    return (response as List)
        .map((json) => CardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BillPaymentModel>> fetchBills() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) return [];

    try {
      final response = await _client
          .from('bill_payments')
          .select('''
        *,
        company:companyId(*),
        fromAccount:fromAccountId(*),
        fromCard:fromCardId(*)
      ''')
          .eq('userId', currentUser.id)
          .order('createdAt', ascending: false);

      return (response as List<dynamic>)
          .map(
            (json) => BillPaymentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bills: ${e.toString()}');
    }
  }

  @override
  Future<List<CompanyModel>> fetchCompanies(BillType type) async {
    try {
      final response = await _client
          .from('companies')
          .select('*')
          .eq('billType', type.name);

      return (response as List<dynamic>)
          .map((json) => CompanyModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }

  @override
  Future<void> sendOtpEmail(String billId) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    // Generate a proper 6-digit OTP
    final random = Random();
    final otpCode = (100000 + random.nextInt(900000)).toString();

    final expiresAt = DateTime.now()
        .add(const Duration(minutes: 5))
        .toIso8601String();

    try {
      // Store OTP in database
      await _client.from('bill_payment_otps').upsert({
        'billId': billId,
        'otpCode': otpCode,
        'expiresAt': expiresAt,
        'userId': currentUser.id,
        'isUsed': false,
      });

      print('OTP $otpCode sent to ${currentUser.email ?? ''}');
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyOTP(String billId, String otpCode) async {
    try {
      final response = await _client
          .from('bill_payment_otps')
          .select()
          .eq('billId', billId)
          .eq('otpCode', otpCode)
          .eq('isUsed', false)
          .gte('expiresAt', DateTime.now().toIso8601String())
          .maybeSingle();

      if (response != null) {
        // Mark OTP as used
        await _client
            .from('bill_payment_otps')
            .update({'isUsed': true})
            .eq('billId', billId)
            .eq('otpCode', otpCode);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> confirmPayTheBill(String billId, String otpCode) async {
    bool success = false;

    try {
      if (otpCode == "BIOMETRIC_AUTH") {
        success = true;
      } else {
        final otpValid = await _client
            .from('bill_payment_otps')
            .select()
            .eq('billId', billId)
            .eq('otpCode', otpCode)
            .eq('isUsed', false)
            .maybeSingle();

        success = otpValid != null;
      }

      if (success) {
        final bill = await _client
            .from('bill_payments')
            .select(
              'transactionId, fromAccountId, fromCardId, amount, fee, tax',
            )
            .eq('id', billId)
            .maybeSingle();

        final transactionId = bill?['transactionId'];
        final double amount = ((bill?['amount'] ?? 0) as num).toDouble();
        final double fee = ((bill?['fee'] ?? 0) as num).toDouble();
        final double tax = ((bill?['tax'] ?? 0) as num).toDouble();
        final double total = double.parse(
          (amount + fee + tax).toStringAsFixed(2),
        );

        if (transactionId != null) {
          // Update transaction status → completed
          await _client
              .from('transactions')
              .update({'status': TransactionStatus.completed.name})
              .eq('id', transactionId);
        }

        // Deduct balance from selected source
        if (bill?['fromAccountId'] != null) {
          final accountId = bill?['fromAccountId'] as String;
          final acc = await _client
              .from('accounts')
              .select('availableBalance')
              .eq('id', accountId)
              .single();
          final available = (acc['availableBalance'] as num).toDouble();
          final newBalance = double.parse(
            (available - total).toStringAsFixed(2),
          );
          await _client
              .from('accounts')
              .update({'availableBalance': newBalance})
              .eq('id', accountId);
        } else if (bill?['fromCardId'] != null) {
          final cardId = bill?['fromCardId'] as String;
          final card = await _client
              .from('cards')
              .select('availableBalance')
              .eq('id', cardId)
              .single();
          final available = (card['availableBalance'] as num).toDouble();
          final newBalance = double.parse(
            (available - total).toStringAsFixed(2),
          );
          await _client
              .from('cards')
              .update({'availableBalance': newBalance})
              .eq('id', cardId);
        }

        // Mark OTP as used
        await _client
            .from('bill_payment_otps')
            .update({'isUsed': true})
            .eq('billId', billId)
            .eq('otpCode', otpCode);
      }

      return success;
    } catch (e) {
      throw Exception("Failed to confirm bill payment: $e");
    }
  }

  @override
  Future<BillPaymentModel> payBill({
    required BillPaymentModel bill,
    String? fromAccountId,
    String? fromCardId,
  }) async {
    final currentUser = _client.auth.currentUser;

    if (bill.amount == null || bill.amount! <= 0) {
      throw Exception('Invalid bill amount');
    }

    final totalAmount =
        (bill.amount ?? 0.0) + (bill.tax ?? 0.0) + (bill.fee ?? 0.0);

    // Insufficient funds check on the chosen source
    if (fromAccountId == null && fromCardId == null) {
      throw Exception('Please select a source to pay the bill');
    }
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

    try {
      final txnInsert = await _client
          .from('transactions')
          .insert({
            'userId': currentUser?.id,
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

      final transactionId = txnInsert['id'] as String;

      final billInsert = await _client
          .from('bill_payments')
          .insert({
            'userId': currentUser?.id,
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
            'startDate': bill.startDate?.toIso8601String(),
            'endDate': bill.endDate?.toIso8601String(),
            'fromCardId': fromCardId,
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
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }
}
