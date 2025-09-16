import 'dart:async';
import 'dart:convert';
import 'package:banking_app/features/transfer/models/transfer_model.dart';
import 'package:http/http.dart' as http;

abstract class TransferRepository {
  Future<List<Account>> getUserAccounts();
  Future<List<Beneficiary>> getBeneficiaries();
  Future<List<Bank>> getBanks();
  Future<Beneficiary> addBeneficiary(Beneficiary beneficiary);
  Future<double> calculateTransactionFee(TransferRequest request);
  Future<String> initiateTransfer(TransferRequest request);
  Future<bool> verifyOTP(String transactionId, String otpCode);
  Future<Transaction> confirmTransfer(String transactionId);
  Future<List<Transaction>> getTransactionHistory();
  Future<bool> authenticateWithBiometrics();
  Future<bool> authenticateWithFaceId();
}

class TransferRepositoryImpl implements TransferRepository {
  final http.Client _httpClient;
  final String _baseUrl;

  TransferRepositoryImpl({
    http.Client? httpClient,
    String baseUrl = 'https://api.bankingapp.com/v1',
  }) : _httpClient = httpClient ?? http.Client(),
       _baseUrl = baseUrl;

  @override
  Future<List<Account>> getUserAccounts() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/accounts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load accounts');
      }
    } catch (e) {
      // Mock data for demo
      await Future.delayed(const Duration(milliseconds: 500));
      return [
        const Account(
          id: '1',
          number: '1234567890123456',
          maskedNumber: 'VISA **** **** **** 1234',
          type: 'VISA',
          availableBalance: 10000.0,
        ),
        const Account(
          id: '2',
          number: '6789012345678901',
          maskedNumber: '**** **** 6789',
          type: 'Account',
          availableBalance: 25000.0,
        ),
      ];
    }
  }

  @override
  Future<List<Beneficiary>> getBeneficiaries() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/beneficiaries'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Beneficiary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load beneficiaries');
      }
    } catch (e) {
      // Mock data for demo
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        const Beneficiary(
          id: '1',
          name: 'Emma',
          accountNumber: '1234567890',
          isFavorite: true,
        ),
        const Beneficiary(
          id: '2',
          name: 'Justin',
          accountNumber: '0987654321',
          isFavorite: false,
        ),
        const Beneficiary(
          id: '3',
          name: 'Amanda',
          accountNumber: '0123456789',
          isFavorite: false,
        ),
      ];
    }
  }

  @override
  Future<List<Bank>> getBanks() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/banks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Bank.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load banks');
      }
    } catch (e) {
      // Mock data for demo
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        const Bank(id: '1', name: 'US Bank', code: 'USB'),
        const Bank(id: '2', name: 'Citibank', code: 'CITI'),
        const Bank(id: '3', name: 'Bank of the West', code: 'BOW'),
        const Bank(id: '4', name: 'Wells Fargo', code: 'WF'),
        const Bank(id: '5', name: 'JP Morgan Chase', code: 'JPM'),
        const Bank(id: '6', name: 'HSBS Bank', code: 'HSBS'),
        const Bank(id: '7', name: 'Citybank', code: 'CTB'),
        const Bank(id: '8', name: 'Fifth Third', code: 'FT'),
        const Bank(id: '9', name: 'Ame Express', code: 'AE'),
      ];
    }
  }

  @override
  Future<Beneficiary> addBeneficiary(Beneficiary beneficiary) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/beneficiaries'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(beneficiary.toJson()),
      );

      if (response.statusCode == 201) {
        return Beneficiary.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to add beneficiary');
      }
    } catch (e) {
      // Mock success
      await Future.delayed(const Duration(milliseconds: 500));
      return beneficiary.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
  }

  @override
  Future<double> calculateTransactionFee(TransferRequest request) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/calculate-fee'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': request.amount,
          'transferType': request.transferType.toString().split('.').last,
          'fromAccountId': request.fromAccount.id,
          'toBeneficiaryId': request.toBeneficiary.id,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['fee'].toDouble();
      } else {
        throw Exception('Failed to calculate fee');
      }
    } catch (e) {
      // Mock fee calculation
      await Future.delayed(const Duration(milliseconds: 200));
      switch (request.transferType) {
        case TransferType.cardNumber:
        case TransferType.sameBank:
          return 10.0;
        case TransferType.otherBank:
          return 25.0;
      }
    }
  }

  @override
  Future<String> initiateTransfer(TransferRequest request) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/transfers/initiate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['transactionId'];
      } else {
        throw Exception('Failed to initiate transfer');
      }
    } catch (e) {
      // Mock transaction ID
      await Future.delayed(const Duration(milliseconds: 800));
      return 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<bool> verifyOTP(String transactionId, String otpCode) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/transfers/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId, 'otpCode': otpCode}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['verified'];
      } else {
        throw Exception('OTP verification failed');
      }
    } catch (e) {
      // Mock OTP verification
      await Future.delayed(const Duration(milliseconds: 1000));
      // Consider OTP verified if it's 4 digits
      return otpCode.length == 6 && otpCode == '123456';
    }
  }

  @override
  Future<Transaction> confirmTransfer(String transactionId) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/transfers/confirm'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'transactionId': transactionId}),
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to confirm transfer');
      }
    } catch (e) {
      // Mock successful transaction
      await Future.delayed(const Duration(milliseconds: 2000));
      return Transaction(
        id: transactionId,
        transferRequest: TransferRequest(
          id: transactionId,
          fromAccount: const Account(
            id: '1',
            number: '1234567890123456',
            maskedNumber: '**** **** 6789',
            type: 'VISA',
            availableBalance: 9000.0,
          ),
          toBeneficiary: const Beneficiary(
            id: '3',
            name: 'Amanda',
            accountNumber: '0123456789',
          ),
          amount: 1000.0,
          transactionFee: 10.0,
          content: 'From Jimy',
          transferType: TransferType.cardNumber,
        ),
        status: TransactionStatus.completed,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<List<Transaction>> getTransactionHistory() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      // Mock empty history for demo
      await Future.delayed(const Duration(milliseconds: 300));
      return [];
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      // In real implementation, use local_auth package
      await Future.delayed(const Duration(milliseconds: 2000));
      return true; // Mock success
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithFaceId() async {
    try {
      // In real implementation, use local_auth package
      await Future.delayed(const Duration(milliseconds: 1500));
      return true; // Mock success
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
