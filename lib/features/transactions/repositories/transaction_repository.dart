import 'package:banking_app/features/home/models/card_model.dart';
import 'package:banking_app/features/transactions/models/transaction_model.dart';
import 'package:banking_app/features/transactions/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/models/transaction_report_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TransactionReportRepository {
  Future<List<CardModel>> fetchCards();
  Future<TransactionReportModel> fetchTransactionReports({int? offset});
  Future<List<TransactionModel>> fetchMoreTransactions({required int offset});
  Future<void> recordBalanceHistory({
    required String userId,
    required String accountId,
    required double balance,
  });
}

class TransactionReportRepositoryImpl implements TransactionReportRepository {
  final SupabaseClient _client;

  TransactionReportRepositoryImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<CardModel>> fetchCards() async {
    final currentUser = _client.auth.currentUser;

    final response = await _client
        .from('cards')
        .select()
        .eq('userId', currentUser?.id ?? '');

    return (response as List<dynamic>)
        .map((json) => CardModel.fromJson(json))
        .toList();
  }

  @override
  Future<TransactionReportModel> fetchTransactionReports({int? offset}) async {
    final currentUser = _client.auth.currentUser;

    final recentDate = DateTime.now().subtract(const Duration(days: 90));

    final recentResponse = await _client
        .from('transactions')
        .select()
        .eq('userId', currentUser?.id ?? '')
        .gte('createdAt', recentDate.toIso8601String())
        .order('createdAt', ascending: false);

    final recentTransactions = (recentResponse as List<dynamic>)
        .map((json) => TransactionModel.fromJson(json))
        .toList();

    final balanceResponse = await _client
        .from('balance_history')
        .select()
        .eq('userId', currentUser?.id ?? '')
        .order('recordedAt', ascending: false)
        .limit(12);

    final balanceHistory = (balanceResponse as List<dynamic>)
        .map((json) => BalanceSummaryModel.fromJson(json))
        .toList();

    final now = DateTime.now();
    final today = _normalizeDate(now);
    final yesterday = _normalizeDate(now.subtract(const Duration(days: 1)));

    final todayTransactions = _filterTransactionsByDate(
      recentTransactions,
      today,
    );
    final yesterdayTransactions = _filterTransactionsByDate(
      recentTransactions,
      yesterday,
    );

    final currentBalance = balanceHistory.isNotEmpty
        ? balanceHistory.first.endingBalance
        : _calculateCurrentBalance(recentTransactions);

    final thisMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    return TransactionReportModel(
      todayTransactions: todayTransactions,
      yesterdayTransactions: yesterdayTransactions,
      recentTransactions: recentTransactions,
      balanceHistory: balanceHistory,
      currentBalance: currentBalance,
      thisMonthIncome: _calculateIncome(recentTransactions, thisMonth),
      thisMonthExpense: _calculateExpense(recentTransactions, thisMonth),
      lastMonthIncome: _calculateIncome(recentTransactions, lastMonth),
      lastMonthExpense: _calculateExpense(recentTransactions, lastMonth),
    );
  }

  @override
  Future<List<TransactionModel>> fetchMoreTransactions({
    required int offset,
  }) async {
    final currentUser = _client.auth.currentUser;

    final response = await _client
        .from('transactions')
        .select()
        .eq('userId', currentUser?.id ?? '')
        .order('createdAt', ascending: false)
        .range(offset, offset + 19);

    return (response as List<dynamic>)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> recordBalanceHistory({
    required String userId,
    required String accountId,
    required double balance,
  }) async {
    final now = DateTime.now();
    await _client.from('balance_history').insert({
      'userId': userId,
      'accountId': accountId,
      'endingBalance': balance,
      'year': now.year,
      'month': now.month,
      'recordedAt': now.toIso8601String(),
    });
  }

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  List<TransactionModel> _filterTransactionsByDate(
    List<TransactionModel> transactions,
    DateTime reference,
  ) {
    return transactions.where((transaction) {
      if (transaction.createdAt == null) return false;
      return _normalizeDate(transaction.createdAt!) == reference;
    }).toList();
  }

  double _calculateCurrentBalance(List<TransactionModel> transactions) {
    double balance = 0.0;
    for (final transaction in transactions) {
      if (transaction.type == TransferType.billPayment) {
        balance -= transaction.amount.abs();
      } else {
        balance += transaction.amount;
      }
    }
    return balance;
  }

  double _calculateIncome(List<TransactionModel> transactions, DateTime month) {
    return transactions
        .where(
          (transaction) =>
              transaction.amount > 0 &&
              transaction.createdAt != null &&
              transaction.createdAt?.year == month.year &&
              transaction.createdAt?.month == month.month,
        )
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double _calculateExpense(
    List<TransactionModel> transactions,
    DateTime month,
  ) {
    return transactions
        .where(
          (transaction) =>
              transaction.amount < 0 &&
              transaction.createdAt != null &&
              transaction.createdAt?.year == month.year &&
              transaction.createdAt?.month == month.month,
        )
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }
}
