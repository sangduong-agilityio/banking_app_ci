import 'fragments.dart';

/// GraphQL subscriptions for real-time updates
/// 
/// Subscriptions allow the client to receive real-time updates
/// when data changes on the server.
class TransactionSubscriptions {
  TransactionSubscriptions._();

  /// Listens for transaction status changes
  /// 
  /// Variables:
  /// - userId: String (required)
  static const String onTransactionStatusChanged = '''
    subscription OnTransactionStatusChanged(\$userId: String!) {
      transactionStatusChanged(userId: \$userId) {
        ...TransactionCore
      }
    }
    ${TransactionFragments.transactionCore}
  ''';

  /// Listens for new transactions
  /// 
  /// Variables:
  /// - userId: String (required)
  static const String onNewTransaction = '''
    subscription OnNewTransaction(\$userId: String!) {
      newTransaction(userId: \$userId) {
        ...TransactionCore
      }
    }
    ${TransactionFragments.transactionCore}
  ''';

  /// Listens for balance updates on a specific account
  /// 
  /// Variables:
  /// - accountId: String (required)
  static const String onBalanceUpdated = '''
    subscription OnBalanceUpdated(\$accountId: String!) {
      balanceUpdated(accountId: \$accountId) {
        id
        accountNumber
        balance
        currency
      }
    }
  ''';
}
