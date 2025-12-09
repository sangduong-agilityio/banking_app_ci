enum TransactionStatus { pending, completed, failed }

class Transaction {
  final String id;
  final double amount;
  final String recipientName;
  final DateTime timestamp;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.amount,
    required this.recipientName,
    required this.timestamp,
    required this.status,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    String? recipientName,
    DateTime? timestamp,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipientName: recipientName ?? this.recipientName,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
