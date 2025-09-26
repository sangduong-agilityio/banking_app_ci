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
        .eq('user_id', currentUser?.id ?? '');
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
        .eq('user_id', currentUser?.id ?? '');
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
        company:company_id(*),
        fromAccount:from_account_id(*),
        fromCard:from_card_id(*)
      ''')
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

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
          .eq('bill_type', type.name);

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
        'bill_id': billId,
        'otp_code': otpCode,
        'expires_at': expiresAt,
        'user_id': currentUser.id,
        'is_used': false,
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
          .eq('bill_id', billId)
          .eq('otp_code', otpCode)
          .eq('is_used', false)
          .gte('expires_at', DateTime.now().toIso8601String())
          .maybeSingle();

      if (response != null) {
        // Mark OTP as used
        await _client
            .from('bill_payment_otps')
            .update({'is_used': true})
            .eq('bill_id', billId)
            .eq('otp_code', otpCode);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> confirmPayTheBill(String billId, String otpCode) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    bool success = false;

    if (otpCode == "BIOMETRIC_AUTH") {
      success = true;
    } else {
      final otpValid = await _client
          .from('bill_payment_otps')
          .select()
          .eq('bill_id', billId)
          .eq('otp_code', otpCode)
          .eq('is_used', false)
          .maybeSingle();

      success = otpValid != null;
    }

    if (success) {
      // Mark OTP as used
      await _client
          .from('bill_payment_otps')
          .update({'is_used': true})
          .eq('bill_id', billId)
          .eq('otp_code', otpCode);
    }

    return success;
  }

  @override
  Future<BillPaymentModel> payBill({
    required BillPaymentModel bill,
    String? fromAccountId,
    String? fromCardId,
  }) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception("User not authenticated");

    if (bill.amount == null || bill.amount! <= 0) {
      throw Exception('Invalid bill amount');
    }

    final totalAmount =
        (bill.amount ?? 0.0) + (bill.tax ?? 0.0) + (bill.fee ?? 0.0);

    try {
      final txnInsert = await _client
          .from('transactions')
          .insert({
            'user_id': currentUser.id,
            'type': TransferType.billPayment.name,
            'amount': totalAmount,
            'from_account_id': fromAccountId,
            'from_card_id': fromCardId,
            'recipient_name': bill.company?.name,
            'recipient_account': bill.billCode,
            'transaction_fee': bill.fee ?? 0.0,
            'status': TransactionStatus.pending.name,
            'category': bill.billType?.name,
            'reference_number': 'TXN${DateTime.now().millisecondsSinceEpoch}',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final transactionId = txnInsert['id'] as String;

      final billInsert = await _client
          .from('bill_payments')
          .insert({
            'user_id': currentUser.id,
            'company_id': bill.companyId ?? bill.company?.id,
            'bill_type': bill.billType?.name,
            'bill_code': bill.billCode,
            'phone_number': bill.phoneNumber,
            'address': bill.address,
            'amount': bill.amount,
            'fee': bill.fee ?? 0.0,
            'tax': bill.tax ?? 0.0,
            'transaction_id': transactionId,
            'from_account_id': fromAccountId,
            'start_date': bill.startDate?.toIso8601String(),
            'end_date': bill.endDate?.toIso8601String(),
            'from_card_id': fromCardId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('''
        *,
        company:company_id(*),
        fromAccount:from_account_id(*),
        fromCard:from_card_id(*)
      ''')
          .single();

      return BillPaymentModel.fromJson(billInsert);
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }
}
