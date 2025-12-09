import 'package:banking_app/features/setting/data/models/transaction.dart';

enum OptimisticStatus { initial, loading, success, failure }

final class OptimisticState {
  const OptimisticState({
    this.balance = 1000000.0,
    this.transactions = const [],
    this.previousBalance,
    this.previousTransactions,
    this.status = OptimisticStatus.initial,
    this.errorMessage,
  });

  final double balance;
  final List<Transaction> transactions;
  final double? previousBalance;
  final List<Transaction>? previousTransactions;
  final OptimisticStatus status;
  final String? errorMessage;

  OptimisticState copyWith({
    double? balance,
    List<Transaction>? transactions,
    double? previousBalance,
    List<Transaction>? previousTransactions,
    OptimisticStatus? status,
    String? errorMessage,
  }) {
    return OptimisticState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      previousBalance: previousBalance ?? this.previousBalance,
      previousTransactions: previousTransactions ?? this.previousTransactions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
