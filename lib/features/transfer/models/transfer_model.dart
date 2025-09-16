// models/transfer_models.dart

import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String number;
  final String maskedNumber;
  final String type; // 'VISA', 'MASTERCARD', etc.
  final double availableBalance;
  final bool isActive;

  const Account({
    required this.id,
    required this.number,
    required this.maskedNumber,
    required this.type,
    required this.availableBalance,
    this.isActive = true,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      maskedNumber: json['maskedNumber'] ?? '',
      type: json['type'] ?? '',
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'maskedNumber': maskedNumber,
    'type': type,
    'availableBalance': availableBalance,
    'isActive': isActive,
  };

  @override
  List<Object?> get props => [
    id,
    number,
    maskedNumber,
    type,
    availableBalance,
    isActive,
  ];
}

class Beneficiary extends Equatable {
  final String id;
  final String name;
  final String accountNumber;
  final String? avatarUrl;
  final Bank? bank;
  final String? branch;
  final bool isFavorite;

  const Beneficiary({
    required this.id,
    required this.name,
    required this.accountNumber,
    this.avatarUrl,
    this.bank,
    this.branch,
    this.isFavorite = false,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      avatarUrl: json['avatarUrl'],
      bank: json['bank'] != null ? Bank.fromJson(json['bank']) : null,
      branch: json['branch'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'accountNumber': accountNumber,
    'avatarUrl': avatarUrl,
    'bank': bank?.toJson(),
    'branch': branch,
    'isFavorite': isFavorite,
  };

  Beneficiary copyWith({
    String? id,
    String? name,
    String? accountNumber,
    String? avatarUrl,
    Bank? bank,
    String? branch,
    bool? isFavorite,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bank: bank ?? this.bank,
      branch: branch ?? this.branch,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    accountNumber,
    avatarUrl,
    bank,
    branch,
    isFavorite,
  ];
}

class Bank extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? logoUrl;

  const Bank({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'logoUrl': logoUrl,
  };

  @override
  List<Object?> get props => [id, name, code, logoUrl];
}

enum TransferType { cardNumber, sameBank, otherBank }

enum TransactionStatus { pending, processing, completed, failed, cancelled }

class TransferRequest {
  final String? id;
  final Account fromAccount;
  final Beneficiary toBeneficiary;
  final double amount;
  final double transactionFee;
  final String content;
  final TransferType transferType;
  final bool saveToDirectory;
  final String? otpCode;

  const TransferRequest({
    this.id,
    required this.fromAccount,
    required this.toBeneficiary,
    required this.amount,
    required this.transactionFee,
    required this.content,
    required this.transferType,
    this.saveToDirectory = false,
    this.otpCode,
  });

  factory TransferRequest.fromJson(Map<String, dynamic> json) {
    return TransferRequest(
      id: json['id'],
      fromAccount: Account.fromJson(json['fromAccount']),
      toBeneficiary: Beneficiary.fromJson(json['toBeneficiary']),
      amount: (json['amount'] ?? 0).toDouble(),
      transactionFee: (json['transactionFee'] ?? 0).toDouble(),
      content: json['content'] ?? '',
      transferType: TransferType.values.firstWhere(
        (e) => e.toString() == 'TransferType.${json['transferType']}',
        orElse: () => TransferType.cardNumber,
      ),
      saveToDirectory: json['saveToDirectory'] ?? false,
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromAccount': fromAccount.toJson(),
      'toBeneficiary': toBeneficiary.toJson(),
      'amount': amount,
      'transactionFee': transactionFee,
      'content': content,
      'transferType': transferType.toString().split('.').last,
      'saveToDirectory': saveToDirectory,
      'otpCode': otpCode,
    };
  }

  TransferRequest copyWith({
    String? id,
    Account? fromAccount,
    Beneficiary? toBeneficiary,
    double? amount,
    double? transactionFee,
    String? content,
    TransferType? transferType,
    bool? saveToDirectory,
    String? otpCode,
  }) {
    return TransferRequest(
      id: id ?? this.id,
      fromAccount: fromAccount ?? this.fromAccount,
      toBeneficiary: toBeneficiary ?? this.toBeneficiary,
      amount: amount ?? this.amount,
      transactionFee: transactionFee ?? this.transactionFee,
      content: content ?? this.content,
      transferType: transferType ?? this.transferType,
      saveToDirectory: saveToDirectory ?? this.saveToDirectory,
      otpCode: otpCode ?? this.otpCode,
    );
  }
}

class Transaction {
  final String id;
  final TransferRequest transferRequest;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const Transaction({
    required this.id,
    required this.transferRequest,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      transferRequest: TransferRequest.fromJson(json['transferRequest']),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == 'TransactionStatus.${json['status']}',
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      failureReason: json['failureReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transferRequest': transferRequest.toJson(),
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }
}
