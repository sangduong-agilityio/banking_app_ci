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
  Future<List<BeneficiaryModel>> fetchBeneficiaries() async {
    final currentUser = _client.auth.currentUser;
    final response = await _client
        .from('beneficiaries')
        .select('*, banks(*)')
        .eq('userId', currentUser?.id ?? '');
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
        .eq('userId', currentUser?.id ?? '')
        .order('createdAt', ascending: false);
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
          'userId': currentUser?.id,
          'name': beneficiary.name,
          'accountNumber': beneficiary.accountNumber,
          'bankId': beneficiary.bankId,
          'branch': beneficiary.branch,
          'avatarUrl': beneficiary.avatarUrl,
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

    final random = Random();
    final otpCode = (100000 + random.nextInt(900000)).toString();
    final expiresAt = DateTime.now()
        .add(const Duration(minutes: 5))
        .toIso8601String();

    try {
      // Delete any existing OTPs for this transfer
      await _client.from('transfer_otps').delete().eq('transferId', transferId);

      // Insert new OTP
      await _client.from('transfer_otps').insert({
        'transferId': transferId,
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

  /// Transfer actions
  @override
  Future<TransferResult> initiateTransfer(TransferModel request) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    // Insufficient funds check
    final double amount = (request.amount ?? 0) + (request.transactionFee ?? 0);
    if ((request.fromAccount?.id == null && request.fromCard?.id == null) ||
        amount <= 0) {
      throw Exception('Invalid transfer source or amount');
    }

    // Verify source balance
    if (request.fromAccount?.id != null) {
      final acc = await _client
          .from('accounts')
          .select('availableBalance')
          .eq('id', request.fromAccount!.id)
          .single();
      final available = (acc['availableBalance'] as num).toDouble();
      if (available < amount) {
        throw Exception('Insufficient funds in account');
      }
    } else if (request.fromCard?.id != null) {
      final card = await _client
          .from('cards')
          .select('availableBalance')
          .eq('id', request.fromCard!.id)
          .single();
      final available = (card['availableBalance'] as num).toDouble();
      if (available < amount) {
        throw Exception('Insufficient funds on card');
      }
    }

    final insert = await _client
        .from('transfers')
        .insert({
          'fromAccountId': request.fromAccount?.id,
          'fromCardId': request.fromCard?.id,
          'toBeneficiaryId': request.toBeneficiary?.id,
          'amount': request.amount,
          'transactionFee': request.transactionFee,
          'content': request.content,
          'transferType': request.transferType.name,
          'authMethod': request.authMethod?.name,
          'status': 'pending',
          'userId': currentUser.id,
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
          .eq('transferId', transferId)
          .eq('otpCode', otpCode)
          .eq('isUsed', false)
          .gte('expiresAt', DateTime.now().toIso8601String())
          .order('expiresAt', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response != null) {
        // Mark OTP as used
        await _client
            .from('transfer_otps')
            .update({'isUsed': true})
            .eq('transferId', transferId)
            .eq('otpCode', otpCode)
            .eq('isUsed', false);
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
    bool success = false;

    if (otpCode == "BIOMETRIC_AUTH") {
      success = true;
    } else {
      // Verify OTP
      final otpValid = await _client
          .from('transfer_otps')
          .select()
          .eq('transferId', transferId)
          .eq('isUsed', true)
          .maybeSingle();

      success = otpValid != null;
    }

    // Update transfer status
    await _client
        .from('transfers')
        .update({
          'status': success ? 'completed' : 'failed',
          if (success) 'completedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', transferId);

    if (success) {
      // Fetch transfer details
      final transfer = await _client
          .from('transfers')
          .select('fromAccountId, fromCardId, amount, transactionFee')
          .eq('id', transferId)
          .single();

      final double amount = ((transfer['amount'] ?? 0) as num).toDouble();
      final double fee = ((transfer['transactionFee'] ?? 0) as num).toDouble();
      final double total = double.parse((amount + fee).toStringAsFixed(2));

      final insertedTx = await _client
          .from('transactions')
          .insert({
            'userId': currentUser?.id,
            'type': 'transfer',
            'amount': -total,
            'status': 'completed',
            'referenceNumber': DateTime.now().millisecondsSinceEpoch.toString(),
            'createdAt': DateTime.now().toIso8601String(),
            'description': 'Transfer to beneficiary',
          })
          .select()
          .single();

      final transactionId = insertedTx['id'];

      await _client
          .from('transfers')
          .update({'transactionId': transactionId})
          .eq('id', transferId);

      if (transfer['fromAccountId'] != null) {
        final accountId = transfer['fromAccountId'] as String;
        final acc = await _client
            .from('accounts')
            .select('availableBalance')
            .eq('id', accountId)
            .single();

        final available = (acc['availableBalance'] as num).toDouble();
        final newBalance = double.parse((available - total).toStringAsFixed(2));

        await _client
            .from('accounts')
            .update({'availableBalance': newBalance})
            .eq('id', accountId);
      } else if (transfer['fromCardId'] != null) {
        final cardId = transfer['fromCardId'] as String;
        final card = await _client
            .from('cards')
            .select('availableBalance')
            .eq('id', cardId)
            .single();

        final available = (card['availableBalance'] as num).toDouble();
        final newBalance = double.parse((available - total).toStringAsFixed(2));

        await _client
            .from('cards')
            .update({'availableBalance': newBalance})
            .eq('id', cardId);
      }
    }

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
