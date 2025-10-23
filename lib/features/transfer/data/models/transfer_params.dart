class TransferParams {
  final String? fromAccount;
  final String? toAccount;
  final double? amount;
  final String? description;
  final String? beneficiaryId;
  final String? bankId;

  const TransferParams({
    this.fromAccount,
    this.toAccount,
    this.amount,
    this.description,
    this.beneficiaryId,
    this.bankId,
  });

  factory TransferParams.fromJson(Map<String, dynamic> json) {
    return TransferParams(
      fromAccount: json['fromAccount'] as String?,
      toAccount: json['toAccount'] as String?,
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      description: json['description'] as String?,
      beneficiaryId: json['beneficiaryId'] as String?,
      bankId: json['bankId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'fromAccount': fromAccount,
    'toAccount': toAccount,
    'amount': amount,
    'description': description,
    'beneficiaryId': beneficiaryId,
    'bankId': bankId,
  };
}