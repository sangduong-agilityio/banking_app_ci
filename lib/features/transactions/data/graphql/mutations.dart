import 'fragments.dart';

/// GraphQL mutations for the transactions feature
/// 
/// Mutations are operations that modify data on the server.
/// They follow the schema design in docs/graphql/GRAPHQL_SCHEMA.md
class TransactionMutations {
  TransactionMutations._();

  /// Creates a new transaction
  /// 
  /// Variables:
  /// - input: CreateTransactionInput (required)
  ///   - type: TransferType (required)
  ///   - amount: Decimal (required)
  ///   - fromAccountId: String (optional)
  ///   - fromCardId: String (optional)
  ///   - toBeneficiaryId: String (required)
  ///   - description: String (optional)
  ///   - category: TransactionCategory (optional)
  static const String createTransaction = '''
    mutation CreateTransaction(\$input: CreateTransactionInput!) {
      createTransaction(input: \$input) {
        __typename
        ... on TransactionSuccess {
          transaction {
            ...TransactionCore
          }
        }
        ... on TransactionError {
          code
          message
          field
        }
      }
    }
    ${TransactionFragments.transactionCore}
  ''';

  /// Updates a transaction's status
  /// 
  /// Variables:
  /// - id: ID (required)
  /// - status: TransactionStatus (required)
  static const String updateTransactionStatus = '''
    mutation UpdateTransactionStatus(
      \$id: ID!
      \$status: TransactionStatus!
    ) {
      updateTransactionStatus(id: \$id, status: \$status) {
        __typename
        ... on TransactionSuccess {
          transaction {
            id
            status
            completedAt
          }
        }
        ... on TransactionError {
          code
          message
          field
        }
      }
    }
  ''';

  /// Records balance history for reporting
  /// 
  /// Variables:
  /// - input: RecordBalanceInput (required)
  ///   - accountId: String (required)
  ///   - balance: Decimal (required)
  static const String recordBalanceHistory = '''
    mutation RecordBalanceHistory(\$input: RecordBalanceInput!) {
      recordBalanceHistory(input: \$input) {
        __typename
        ... on BalanceHistorySuccess {
          balanceSummary {
            ...BalanceSummary
          }
        }
        ... on BalanceHistoryError {
          code
          message
        }
      }
    }
    ${TransactionFragments.balanceSummary}
  ''';

  /// Cancels a pending transaction
  /// 
  /// Variables:
  /// - id: ID (required)
  static const String cancelTransaction = '''
    mutation CancelTransaction(\$id: ID!) {
      updateTransactionStatus(id: \$id, status: CANCELLED) {
        __typename
        ... on TransactionSuccess {
          transaction {
            id
            status
          }
        }
        ... on TransactionError {
          code
          message
        }
      }
    }
  ''';
}
