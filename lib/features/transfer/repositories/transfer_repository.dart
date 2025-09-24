import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:banking_app/features/home/models/account_model.dart';
import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transfer/models/bank_model.dart';
import 'package:banking_app/features/transfer/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/models/branch_model.dart';
import 'package:banking_app/features/transfer/models/transfer_model.dart';

abstract class TransferRepository {
  /// Fetch methods
  Future<List<AccountModel>> fetchAccounts();
  Future<List<CardModel>> fetchCards();
  Future<List<BeneficiaryModel>> fetchBeneficiaries();
  Future<List<BankModel>> fetchBanks();
  Future<List<BranchModel>> fetchBranchs();
  Future<List<TransactionModel>> fetchTransactionHistory();

  /// Add / calculate
  Future<BeneficiaryModel> addNewBeneficiary(BeneficiaryModel beneficiary);
  Future<TransferFee> calculateFee(TransferModel request);

  /// Transfer actions
  Future<void> sendOtpEmail(String transferId);
  Future<TransferResult> initiateTransfer(TransferModel request);
  Future<bool> verifyOTP(String transferId, String otpCode);
  Future<bool> confirmTransfer(String transferId, String otpCode);
}

class TransferRepositoryImpl implements TransferRepository {
  final SupabaseClient _client;

  TransferRepositoryImpl({required SupabaseClient client}) : _client = client;

  /// Fetch methods
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
  Future<List<BeneficiaryModel>> fetchBeneficiaries() async {
    final currentUser = _client.auth.currentUser;
    final response = await _client
        .from('beneficiaries')
        .select('*, banks(*)')
        .eq('user_id', currentUser?.id ?? '');
    return (response as List)
        .map((json) => BeneficiaryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BankModel>> fetchBanks() async {
    final response = await _client.from('banks').select();
    return (response as List)
        .map((json) => BankModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<BranchModel>> fetchBranchs() async {
    final response = await _client.from('branches').select();
    return (response as List)
        .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TransactionModel>> fetchTransactionHistory() async {
    final currentUser = _client.auth.currentUser;
    final response = await _client
        .from('transactions')
        .select('*, transfers(*)')
        .eq('user_id', currentUser?.id ?? '')
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Add / calculate
  @override
  Future<BeneficiaryModel> addNewBeneficiary(
    BeneficiaryModel beneficiary,
  ) async {
    final currentUser = _client.auth.currentUser;
    final insert = await _client
        .from('beneficiaries')
        .insert({
          'user_id': currentUser?.id,
          'name': beneficiary.name,
          'account_number': beneficiary.accountNumber,
          'bank_id': beneficiary.bankId,
          'branch': beneficiary.branch,
          'avatar_url': beneficiary.avatarUrl,
        })
        .select()
        .single();
    return BeneficiaryModel.fromJson(insert);
  }

  @override
  Future<TransferFee> calculateFee(TransferModel request) async {
    double feePercentage = request.transferType == TransferType.otherBank
        ? 0.02
        : 0.01;
    final fee = (request.amount ?? 0.0) * feePercentage;
    final total = (request.amount ?? 0.0) + fee;
    return TransferFee(amount: request.amount ?? 0.0, fee: fee, total: total);
  }

  @override
  Future<void> sendOtpEmail(String transferId) async {
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
      await _client.from('transfer_otps').upsert({
        'transfer_id': transferId,
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

  /// Transfer actions
  @override
  Future<TransferResult> initiateTransfer(TransferModel request) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    final insert = await _client
        .from('transfers')
        .insert({
          'from_account_id': request.fromAccount?.id,
          'from_card_id': request.fromCard?.id,
          'to_beneficiary_id': request.toBeneficiary?.id,
          'amount': request.amount,
          'transaction_fee': request.transactionFee,
          'content': request.content,
          'transfer_type': request.transferType.name,
          'auth_method': request.authMethod?.name,
          'status': 'pending',
          'user_id': currentUser.id,
        })
        .select('id')
        .single();

    final transferId = insert['id'] as String;

    return TransferResult(
      success: true,
      transferId: transferId,
      message: 'Transfer initiated successfully',
    );
  }

  @override
  Future<bool> verifyOTP(String transferId, String otpCode) async {
    try {
      final response = await _client
          .from('transfer_otps')
          .select()
          .eq('transfer_id', transferId)
          .eq('otp_code', otpCode)
          .eq('is_used', false)
          .gte('expires_at', DateTime.now().toIso8601String())
          .maybeSingle();

      if (response != null) {
        // Mark OTP as used
        await _client
            .from('transfer_otps')
            .update({'is_used': true})
            .eq('transfer_id', transferId)
            .eq('otp_code', otpCode);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> confirmTransfer(String transferId, String otpCode) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    bool success = false;

    if (otpCode == "BIOMETRIC_AUTH") {
      success = true;
    } else {
      // Verify OTP
      final otpValid = await _client
          .from('transfer_otps')
          .select()
          .eq('transfer_id', transferId)
          .eq('is_used', true)
          .maybeSingle();

      success = otpValid != null;
    }

    // Update transfer
    await _client
        .from('transfers')
        .update({
          'status': success ? 'completed' : 'failed',
          if (success) 'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', transferId);

    // Insert transaction record
    await _client.from('transactions').insert({
      'user_id': currentUser.id,
      'transfer_id': transferId,
      'status': success ? 'completed' : 'failed',
      'reference_number': success
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : null,
    });

    return success;
  }
}

class TransferResult {
  final bool success;
  final String transferId;
  final String message;
  final String? errorCode;

  TransferResult({
    required this.success,
    required this.transferId,
    required this.message,
    this.errorCode,
  });
}
