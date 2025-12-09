import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:banking_app/features/setting/data/models/transaction.dart';
import 'package:banking_app/features/setting/presentation/blocs/optimistic_state.dart';

class OptimisticCubit extends Cubit<OptimisticState> {
  OptimisticCubit() : super(const OptimisticState());

  /// Simulate transfer with optimistic update
  /// [forceSuccess] - true to force success, false to force failure, null for random (50/50)
  Future<void> transferMoney(
    double amount,
    String recipientName, {
    bool? forceSuccess,
  }) async {
    // Save current state for rollback
    final previousBalance = state.balance;
    final previousTransactions = state.transactions;

    // Create pending transaction
    final pendingTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      recipientName: recipientName,
      timestamp: DateTime.now(),
      status: TransactionStatus.pending,
    );

    // Optimistic update: update UI immediately
    emit(
      state.copyWith(
        balance: previousBalance - amount,
        transactions: [pendingTransaction, ...previousTransactions],
        previousBalance: previousBalance,
        previousTransactions: previousTransactions,
        status: OptimisticStatus.loading,
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Determine success or failure
    final isSuccess = forceSuccess ?? (DateTime.now().millisecond % 2 == 0);

    if (isSuccess) {
      // API succeeded: confirm the transaction
      final confirmedTransaction = pendingTransaction.copyWith(
        status: TransactionStatus.completed,
      );

      final updatedTransactions = state.transactions.map((tx) {
        return tx.id == pendingTransaction.id ? confirmedTransaction : tx;
      }).toList();

      emit(
        state.copyWith(
          transactions: updatedTransactions,
          status: OptimisticStatus.success,
          errorMessage: null,
        ),
      );
    } else {
      // API failed: rollback to previous state
      final failureReasons = [
        'Network connection lost',
        'Recipient not found',
        'Insufficient balance',
        'Transfer limit exceeded',
        'Server temporarily unavailable',
        'Invalid account details',
      ];

      final reason =
          failureReasons[DateTime.now().microsecond % failureReasons.length];

      emit(
        state.copyWith(
          balance: previousBalance,
          transactions: previousTransactions,
          status: OptimisticStatus.failure,
          errorMessage:
              'Transfer failed: $reason\n\nYour balance has been restored.',
        ),
      );
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const OptimisticState());
  }
}
