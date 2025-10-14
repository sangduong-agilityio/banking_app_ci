import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_report_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// An abstract class that defines the methods for fetching transaction reports and related data.
abstract class TransactionReportRepository {
  /// Fetches the list of cards for the current user.
  Future<List<CardModel>> fetchCards();

  /// Fetches the transaction report for the current user.
  Future<TransactionReportModel> fetchTransactionReports({int? offset});

  /// Fetches more transactions for the current user with pagination.
  Future<List<TransactionModel>> fetchMoreTransactions({required int offset});

  /// Records the balance history for a user's account.
  Future<void> recordBalanceHistory({
    required String userId,
    required String accountId,
    required double balance,
  });
}

/// The implementation of [TransactionReportRepository] that uses Supabase as the backend.
class TransactionReportRepositoryImpl implements TransactionReportRepository {
  static const _pageSize = 20;
  final SupabaseClient _client;

  /// Creates a new instance of [TransactionReportRepositoryImpl].
  TransactionReportRepositoryImpl({required SupabaseClient client})
    : _client = client;

  /// A utility to ensure the user is logged in.
  User get _currentUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user;
  }

  @override
  Future<List<CardModel>> fetchCards() async {
    try {
      final response = await _client
          .from('cards')
          .select()
          .eq('userId', _currentUser.id);

      return (response as List<dynamic>)
          .map((json) => CardModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch cards: $e');
    }
  }

  @override
  Future<TransactionReportModel> fetchTransactionReports({int? offset}) async {
    final now = DateTime.now();
    final recentDate = now.subtract(const Duration(days: 90));

    final recentTransactions = await _fetchRecentTransactions(recentDate);
    final balanceHistory = await _fetchBalanceHistory();

    return _createTransactionReport(now, recentTransactions, balanceHistory);
  }

  @override
  Future<List<TransactionModel>> fetchMoreTransactions({
    required int offset,
  }) async {
    final response = await _client
        .from('transactions')
        .select()
        .eq('userId', _currentUser.id)
        .order('createdAt', ascending: false)
        .range(offset, offset + _pageSize - 1);

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

  // Helpers

  TransactionReportModel _createTransactionReport(
    DateTime now,
    List<TransactionModel> recentTransactions,
    List<BalanceSummaryModel> balanceHistory,
  ) {
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

  /// Fetches recent transactions from the last 90 days.
  Future<List<TransactionModel>> _fetchRecentTransactions(
    DateTime recentDate,
  ) async {
    final response = await _client
        .from('transactions')
        .select('''
      *,
      bill_payment:bill_payments!transactionId(
        *,
        company:companyId(*)
      )
    ''')
        .eq('userId', _currentUser.id)
        .gte('createdAt', recentDate.toIso8601String())
        .order('createdAt', ascending: false);

    return (response as List<dynamic>)
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }

  /// Fetches balance history for the last 12 months.
  Future<List<BalanceSummaryModel>> _fetchBalanceHistory() async {
    final response = await _client
        .from('balance_history')
        .select()
        .eq('userId', _currentUser.id)
        .order('recordedAt', ascending: false)
        .limit(12);

    return (response as List<dynamic>)
        .map((json) => BalanceSummaryModel.fromJson(json))
        .toList();
  }

  /// Normalizes a DateTime to the start of the day.
  DateTime _normalizeDate(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, dateTime.day);

  /// Filters a list of transactions by a specific date.
  List<TransactionModel> _filterTransactionsByDate(
    List<TransactionModel> transactions,
    DateTime reference,
  ) {
    return transactions.where((tx) {
      if (tx.createdAt == null) return false;
      return _normalizeDate(tx.createdAt!) == reference;
    }).toList();
  }

  /// Calculates the current balance from a list of transactions.
  double _calculateCurrentBalance(List<TransactionModel> transactions) {
    return transactions.fold(
      0.0,
      (balance, transaction) => balance + transaction.amount,
    );
  }

  /// Calculates the total income for a specific month.
  double _calculateIncome(List<TransactionModel> transactions, DateTime month) {
    return transactions
        .where(
          (transaction) =>
              transaction.amount > 0 &&
              transaction.createdAt != null &&
              transaction.createdAt?.year == month.year &&
              transaction.createdAt?.month == month.month,
        )
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Calculates the total expense for a specific month.
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
        .fold(0.0, (sum, tx) => sum + tx.amount.abs());
  }
}
