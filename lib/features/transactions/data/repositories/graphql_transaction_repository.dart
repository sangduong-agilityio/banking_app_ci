import 'package:banking_app/core/data/services/graphql/graphql_client.dart';
import 'package:banking_app/core/error_handling/graphql_exceptions.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_report_model.dart';
import 'package:banking_app/features/transactions/data/graphql/queries.dart';
import 'package:banking_app/features/transactions/data/graphql/mutations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// Input model for creating a transaction
class CreateTransactionInput {
  final TransferType type;
  final double amount;
  final String? fromAccountId;
  final String? fromCardId;
  final String toBeneficiaryId;
  final String? description;
  final TransactionCategory? category;

  const CreateTransactionInput({
    required this.type,
    required this.amount,
    this.fromAccountId,
    this.fromCardId,
    required this.toBeneficiaryId,
    this.description,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name.toUpperCase(),
        'amount': amount,
        if (fromAccountId != null) 'fromAccountId': fromAccountId,
        if (fromCardId != null) 'fromCardId': fromCardId,
        'toBeneficiaryId': toBeneficiaryId,
        if (description != null) 'description': description,
        if (category != null) 'category': category!.name.toUpperCase(),
      };
}

/// Filter options for querying transactions
class TransactionFilter {
  final TransactionStatus? status;
  final TransferType? type;
  final TransactionCategory? category;
  final double? minAmount;
  final double? maxAmount;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchQuery;

  const TransactionFilter({
    this.status,
    this.type,
    this.category,
    this.minAmount,
    this.maxAmount,
    this.dateFrom,
    this.dateTo,
    this.searchQuery,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (status != null) map['status'] = status!.name.toUpperCase();
    if (type != null) map['type'] = type!.name.toUpperCase();
    if (category != null) map['category'] = category!.name.toUpperCase();
    if (minAmount != null) map['minAmount'] = minAmount;
    if (maxAmount != null) map['maxAmount'] = maxAmount;
    if (dateFrom != null) map['dateFrom'] = dateFrom!.toIso8601String();
    if (dateTo != null) map['dateTo'] = dateTo!.toIso8601String();
    if (searchQuery != null) map['searchQuery'] = searchQuery;
    return map;
  }

  bool get isEmpty =>
      status == null &&
      type == null &&
      category == null &&
      minAmount == null &&
      maxAmount == null &&
      dateFrom == null &&
      dateTo == null &&
      searchQuery == null;
}

/// Paginated response wrapper
class PaginatedTransactions {
  final List<TransactionModel> transactions;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? startCursor;
  final String? endCursor;
  final int totalCount;

  const PaginatedTransactions({
    required this.transactions,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
    required this.totalCount,
  });

  factory PaginatedTransactions.fromGraphQL(Map<String, dynamic> data) {
    final connection = data['transactionsCollection'] as Map<String, dynamic>;
    final edges = connection['edges'] as List<dynamic>;
    final pageInfo = connection['pageInfo'] as Map<String, dynamic>;

    return PaginatedTransactions(
      transactions: edges
          .map((e) => TransactionModel.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>))
          .toList(),
      hasNextPage: pageInfo['hasNextPage'] as bool,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool,
      startCursor: pageInfo['startCursor'] as String?,
      endCursor: pageInfo['endCursor'] as String?,
      totalCount: connection['totalCount'] as int,
    );
  }
}

/// Abstract repository interface for GraphQL transaction operations
abstract class GraphQLTransactionRepository {
  /// Fetches a single transaction by ID
  Future<TransactionModel?> getTransaction(String id);

  /// Fetches paginated transactions with optional filtering
  Future<PaginatedTransactions> getTransactions({
    TransactionFilter? filter,
    int? first,
    String? after,
    String? orderByField,
    bool descending = true,
  });

  /// Fetches transaction report for a date range
  Future<TransactionReportModel> getTransactionReport({
    required DateTime from,
    required DateTime to,
    String? accountId,
  });

  /// Fetches balance history
  Future<List<BalanceSummaryModel>> getBalanceHistory({
    int months = 12,
    String? accountId,
  });

  /// Creates a new transaction
  Future<TransactionModel> createTransaction(CreateTransactionInput input);

  /// Updates transaction status
  Future<TransactionModel> updateTransactionStatus(
    String id,
    TransactionStatus status,
  );

  /// Cancels a pending transaction
  Future<TransactionModel> cancelTransaction(String id);

  /// Records balance history
  Future<BalanceSummaryModel> recordBalanceHistory({
    required String accountId,
    required double balance,
  });

  /// Searches transactions by query string
  Future<PaginatedTransactions> searchTransactions(
    String query, {
    int? first,
    String? after,
  });
}

/// Implementation of [GraphQLTransactionRepository]
class GraphQLTransactionRepositoryImpl implements GraphQLTransactionRepository {
  final BankingGraphQLClient _client;

  GraphQLTransactionRepositoryImpl({required BankingGraphQLClient client})
      : _client = client;

  @override
  Future<TransactionModel?> getTransaction(String id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(TransactionQueries.getTransaction),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final data = result.dataForKey('transaction');
    if (data == null) return null;

    return TransactionModel.fromJson(data);
  }

  @override
  Future<PaginatedTransactions> getTransactions({
    TransactionFilter? filter,
    int? first,
    String? after,
    String? orderByField,
    bool descending = true,
  }) async {
    final query = TransactionQueries.getTransactions(
      limit: first ?? 20,
      offset: 0,
      orderBy: orderByField,
      where: filter != null && !filter.isEmpty ? filter.toJson() : null,
    );
    final result = await _client.query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    if (result.data == null) {
      throw const GraphQLQueryException(
        message: 'Failed to fetch transactions',
        code: 'FETCH_ERROR',
      );
    }

    return PaginatedTransactions.fromGraphQL(result.data!);
  }

  @override
  Future<TransactionReportModel> getTransactionReport({
    required DateTime from,
    required DateTime to,
    String? accountId,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(TransactionQueries.getTransactionReport),
        variables: {
          'from': from.toIso8601String(),
          'to': to.toIso8601String(),
          if (accountId != null) 'accountId': accountId,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    final data = result.dataForKey('transactionReport');
    if (data == null) {
      throw const GraphQLQueryException(
        message: 'Failed to fetch transaction report',
        code: 'FETCH_ERROR',
      );
    }

    return _parseTransactionReport(data);
  }

  @override
  Future<List<BalanceSummaryModel>> getBalanceHistory({
    int months = 12,
    String? accountId,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(TransactionQueries.getBalanceHistory),
        variables: {
          'months': months,
          if (accountId != null) 'accountId': accountId,
        },
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );

    final data = result.listForKey('balanceHistory');
    if (data == null) {
      return [];
    }

    return data.map((json) => BalanceSummaryModel.fromJson(json)).toList();
  }

  @override
  Future<TransactionModel> createTransaction(
      CreateTransactionInput input) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(TransactionMutations.createTransaction),
        variables: {'input': input.toJson()},
      ),
    );

    final data = result.dataForKey('createTransaction');
    if (data == null) {
      throw const GraphQLMutationException(
        message: 'Failed to create transaction',
        code: 'MUTATION_ERROR',
      );
    }

    // Handle union type result
    final typename = data['__typename'] as String?;
    if (typename == 'TransactionError') {
      throw GraphQLTransactionException.fromCode(
        data['code'] as String,
        data['message'] as String?,
      );
    }

    return TransactionModel.fromJson(
      data['transaction'] as Map<String, dynamic>,
    );
  }

  @override
  Future<TransactionModel> updateTransactionStatus(
    String id,
    TransactionStatus status,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(TransactionMutations.updateTransactionStatus),
        variables: {
          'id': id,
          'status': status.name.toUpperCase(),
        },
      ),
    );

    final data = result.dataForKey('updateTransactionStatus');
    if (data == null) {
      throw const GraphQLMutationException(
        message: 'Failed to update transaction status',
        code: 'MUTATION_ERROR',
      );
    }

    // Handle union type result
    final typename = data['__typename'] as String?;
    if (typename == 'TransactionError') {
      throw GraphQLTransactionException.fromCode(
        data['code'] as String,
        data['message'] as String?,
      );
    }

    return TransactionModel.fromJson(
      data['transaction'] as Map<String, dynamic>,
    );
  }

  @override
  Future<TransactionModel> cancelTransaction(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(TransactionMutations.cancelTransaction),
        variables: {'id': id},
      ),
    );

    final data = result.dataForKey('updateTransactionStatus');
    if (data == null) {
      throw const GraphQLMutationException(
        message: 'Failed to cancel transaction',
        code: 'MUTATION_ERROR',
      );
    }

    // Handle union type result
    final typename = data['__typename'] as String?;
    if (typename == 'TransactionError') {
      throw GraphQLTransactionException.fromCode(
        data['code'] as String,
        data['message'] as String?,
      );
    }

    return TransactionModel.fromJson(
      data['transaction'] as Map<String, dynamic>,
    );
  }

  @override
  Future<BalanceSummaryModel> recordBalanceHistory({
    required String accountId,
    required double balance,
  }) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(TransactionMutations.recordBalanceHistory),
        variables: {
          'input': {
            'accountId': accountId,
            'balance': balance,
          },
        },
      ),
    );

    final data = result.dataForKey('recordBalanceHistory');
    if (data == null) {
      throw const GraphQLMutationException(
        message: 'Failed to record balance history',
        code: 'MUTATION_ERROR',
      );
    }

    // Handle union type result
    final typename = data['__typename'] as String?;
    if (typename == 'BalanceHistoryError') {
      throw GraphQLMutationException(
        message: data['message'] as String,
        code: data['code'] as String,
      );
    }

    return BalanceSummaryModel.fromJson(
      data['balanceSummary'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PaginatedTransactions> searchTransactions(
    String query, {
    int? first,
    String? after,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(TransactionQueries.searchTransactions),
        variables: {
          'query': query,
          if (first != null) 'first': first,
          if (after != null) 'after': after,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.data == null) {
      throw const GraphQLQueryException(
        message: 'Failed to search transactions',
        code: 'SEARCH_ERROR',
      );
    }

    return PaginatedTransactions.fromGraphQL(result.data!);
  }

  /// Parses the transaction report from GraphQL response
  TransactionReportModel _parseTransactionReport(Map<String, dynamic> data) {
    // Parse today's transactions
    final todayTransactions = (data['todayTransactions'] as List<dynamic>?)
            ?.map((json) =>
                TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];

    // Parse yesterday's transactions
    final yesterdayTransactions =
        (data['yesterdayTransactions'] as List<dynamic>?)
                ?.map((json) =>
                    TransactionModel.fromJson(json as Map<String, dynamic>))
                .toList() ??
            [];

    // Parse recent transactions
    final recentTransactions = (data['recentTransactions'] as List<dynamic>?)
            ?.map((json) =>
                TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList() ??
        [];

    // Parse chart data into balance history
    final chartData = (data['chartData'] as List<dynamic>?)
            ?.map((json) => _parseChartDataToBalanceSummary(
                json as Map<String, dynamic>))
            .toList() ??
        [];

    return TransactionReportModel(
      todayTransactions: todayTransactions,
      yesterdayTransactions: yesterdayTransactions,
      recentTransactions: recentTransactions,
      balanceHistory: chartData,
      currentBalance: (data['currentBalance'] as num?)?.toDouble() ?? 0.0,
      thisMonthIncome: (data['thisMonthIncome'] as num?)?.toDouble(),
      thisMonthExpense: (data['thisMonthExpense'] as num?)?.toDouble(),
      lastMonthIncome: (data['lastMonthIncome'] as num?)?.toDouble(),
      lastMonthExpense: (data['lastMonthExpense'] as num?)?.toDouble(),
    );
  }

  /// Converts chart data point to BalanceSummaryModel
  BalanceSummaryModel _parseChartDataToBalanceSummary(
      Map<String, dynamic> json) {
    final now = DateTime.now();
    final monthName = json['month'] as String;
    final monthNumber = _getMonthNumber(monthName);

    return BalanceSummaryModel(
      id: '${now.year}-$monthNumber',
      userId: '', // Will be filled by context
      year: now.year,
      month: monthNumber,
      totalIncome: (json['income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['expense'] as num?)?.toDouble() ?? 0.0,
      endingBalance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactionCount: 0,
      recordedAt: DateTime(now.year, monthNumber),
    );
  }

  int _getMonthNumber(String monthName) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final index = months.indexOf(monthName);
    return index >= 0 ? index + 1 : 1;
  }
}
