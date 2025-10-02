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

  /// Utility: ensure user is logged in
  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user;
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    final response =
        await _client.from('cards').select().eq('userId', _currentUser.id)
            as List<dynamic>;

    return response.map((json) => CardModel.fromJson(json)).toList();
  }

  @override
  Future<TransactionReportModel> fetchTransactionReports({int? offset}) async {
    final now = DateTime.now();
    final recentDate = now.subtract(const Duration(days: 90));

    // Transactions in last 90 days
    final recentResponse =
        await _client
                .from('transactions')
                .select()
                .eq('userId', _currentUser.id)
                .gte('createdAt', recentDate.toIso8601String())
                .order('createdAt', ascending: false)
            as List<dynamic>;

    final recentTransactions = recentResponse
        .map((json) => TransactionModel.fromJson(json))
        .toList();

    // Balance history (last 12 months)
    final balanceResponse =
        await _client
                .from('balance_history')
                .select()
                .eq('userId', _currentUser.id)
                .order('recordedAt', ascending: false)
                .limit(12)
            as List<dynamic>;

    final balanceHistory = balanceResponse
        .map((json) => BalanceSummaryModel.fromJson(json))
        .toList();

    // Normalize dates
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

    // Current balance fallback: use history if available, else recalc
    final currentBalance = balanceHistory.isNotEmpty
        ? balanceHistory.first.endingBalance
        : _calculateCurrentBalance(recentTransactions);

    // Monthly aggregates
    final thisMonth = DateTime(now.year, now.month);
    final lastMonth = now.month == 1
        ? DateTime(now.year - 1, 12)
        : DateTime(now.year, now.month - 1);

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
    final response =
        await _client
                .from('transactions')
                .select()
                .eq('userId', _currentUser.id)
                .order('createdAt', ascending: false)
                .range(offset, offset + 19)
            as List<dynamic>;

    return response.map((json) => TransactionModel.fromJson(json)).toList();
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

  // Helpers

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  List<TransactionModel> _filterTransactionsByDate(
    List<TransactionModel> transactions,
    DateTime reference,
  ) {
    return transactions.where((tx) {
      if (tx.createdAt == null) return false;
      return _normalizeDate(tx.createdAt!) == reference;
    }).toList();
  }

  double _calculateCurrentBalance(List<TransactionModel> transactions) {
    double balance = 0.0;
    for (final tx in transactions) {
      balance += tx.amount;
    }
    return balance;
  }

  double _calculateIncome(List<TransactionModel> transactions, DateTime month) {
    return transactions
        .where(
          (tx) =>
              tx.amount > 0 &&
              tx.createdAt != null &&
              tx.createdAt!.year == month.year &&
              tx.createdAt!.month == month.month,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double _calculateExpense(
    List<TransactionModel> transactions,
    DateTime month,
  ) {
    return transactions
        .where(
          (tx) =>
              tx.amount < 0 &&
              tx.createdAt != null &&
              tx.createdAt!.year == month.year &&
              tx.createdAt!.month == month.month,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount.abs());
  }
}
