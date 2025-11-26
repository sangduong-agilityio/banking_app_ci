import 'fragments.dart';

/// GraphQL queries for the transactions feature
/// 
/// Queries are read-only operations that fetch data from the server.
/// They follow the schema design in docs/graphql/GRAPHQL_SCHEMA.md
class TransactionQueries {
  TransactionQueries._();

  /// Fetches a single transaction by ID
  static const String getTransaction = '''
    query GetTransaction(\$id: ID!) {
      transaction(id: \$id) {
        ...TransactionWithRelations
      }
    }
    ${TransactionFragments.transactionWithRelations}
  ''';

  /// Fetches paginated transactions with filtering
  /// 
  /// Variables:
  /// - filter: TransactionFilter (optional)
  /// - first: Int (optional, default 20)
  /// - after: String (cursor for pagination)
  /// - orderBy: TransactionOrderBy (optional)
  static String getTransactions({int limit = 20, int offset = 0, Map<String, dynamic>? where, String? orderBy}) {
    String whereStr = '';
    if (where != null && where.isNotEmpty) {
      // Convert Dart Map to GraphQL object string
      whereStr = ', where: ' + _mapToGraphQLObject(where);
    }
    return '''
      query GetTransactions {
        transactionsCollection(
          limit: $limit,
          offset: $offset$whereStr${orderBy != null ? ', orderBy: $orderBy' : ''}
        ) {
          edges {
            node {
              ...TransactionCore
            }
            cursor
          }
          pageInfo {
            ...PageInfoFields
          }
          totalCount
        }
      }
      ${TransactionFragments.transactionCore}
      ${TransactionFragments.pageInfo}
    ''';
  }

  static String _mapToGraphQLObject(Map<String, dynamic> map) {
    List<String> entries = [];
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        entries.add('$key: ${_mapToGraphQLObject(value)}');
      } else if (value is String) {
        entries.add('$key: "${value}"');
      } else {
        entries.add('$key: $value');
      }
    });
    return '{${entries.join(', ')}}';
  }

  /// Fetches transactions for a specific date range
  static const String getTransactionsByDateRange = '''
    query GetTransactionsByDateRange(
      \$dateFrom: DateTime!
      \$dateTo: DateTime!
      \$first: Int
      \$after: String
    ) {
      transactions(
          transactionsCollection(
        pagination: { first: \$first, after: \$after }
        orderBy: { field: CREATED_AT, direction: DESC }
      ) {
        edges {
          node {
            ...TransactionCore
          }
          cursor
        }
        pageInfo {
          ...PageInfoFields
        }
        totalCount
      }
    }
    ${TransactionFragments.transactionCore}
    ${TransactionFragments.pageInfo}
  ''';

  /// Fetches transaction report with summary data
  /// 
  /// Variables:
  /// - dateRange: DateRangeInput (required)
  /// - accountId: String (optional)
  static const String getTransactionReport = '''
    query GetTransactionReport(
      \$from: DateTime!
      \$to: DateTime!
      \$accountId: String
    ) {
      transactionReport(
        dateRange: { from: \$from, to: \$to }
        accountId: \$accountId
      ) {
        currentBalance
        thisMonthIncome
        thisMonthExpense
        lastMonthIncome
        lastMonthExpense
        todayTransactions {
          ...TransactionCore
        }
        yesterdayTransactions {
          ...TransactionCore
        }
        recentTransactions {
          ...TransactionCore
        }
        chartData {
          ...ChartData
        }
      }
    }
    ${TransactionFragments.transactionCore}
    ${TransactionFragments.chartData}
  ''';

  /// Fetches balance history for charts
  /// 
  /// Variables:
  /// - months: Int (optional, default 12)
  /// - accountId: String (optional)
  static const String getBalanceHistory = '''
    query GetBalanceHistory(
      \$months: Int
      \$accountId: String
    ) {
      balanceHistory(
        months: \$months
        accountId: \$accountId
      ) {
        ...BalanceSummary
      }
    }
    ${TransactionFragments.balanceSummary}
  ''';

  /// Fetches transactions by status
  static const String getTransactionsByStatus = '''
    query GetTransactionsByStatus(
      \$status: TransactionStatus!
      \$first: Int
      \$after: String
    ) {
      transactions(
          transactionsCollection(
        pagination: { first: \$first, after: \$after }
        orderBy: { field: CREATED_AT, direction: DESC }
      ) {
        edges {
          node {
            ...TransactionCore
          }
          cursor
        }
        pageInfo {
          ...PageInfoFields
        }
        totalCount
      }
    }
    ${TransactionFragments.transactionCore}
    ${TransactionFragments.pageInfo}
  ''';

  /// Fetches transactions by type (transfer type)
  static const String getTransactionsByType = '''
    query GetTransactionsByType(
      \$type: TransferType!
      \$first: Int
      \$after: String
    ) {
      transactions(
          transactionsCollection(
        pagination: { first: \$first, after: \$after }
        orderBy: { field: CREATED_AT, direction: DESC }
      ) {
        edges {
          node {
            ...TransactionCore
          }
          cursor
        }
        pageInfo {
          ...PageInfoFields
        }
        totalCount
      }
    }
    ${TransactionFragments.transactionCore}
    ${TransactionFragments.pageInfo}
  ''';

  /// Searches transactions by query string
  static const String searchTransactions = '''
    query SearchTransactions(
      \$query: String!
      \$first: Int
      \$after: String
    ) {
      transactions(
          transactionsCollection(
        pagination: { first: \$first, after: \$after }
        orderBy: { field: CREATED_AT, direction: DESC }
      ) {
        edges {
          node {
            ...TransactionCore
          }
          cursor
        }
        pageInfo {
          ...PageInfoFields
        }
        totalCount
      }
    }
    ${TransactionFragments.transactionCore}
    ${TransactionFragments.pageInfo}
  ''';
}
