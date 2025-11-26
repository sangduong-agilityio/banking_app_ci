/// GraphQL fragments for reusable field selections
/// 
/// Fragments help avoid code duplication and ensure consistent
/// field selection across queries and mutations.
class TransactionFragments {
  TransactionFragments._();

  /// Core transaction fields used in list views
  static const String transactionCore = '''
    fragment TransactionCore on Transaction {
      id
      userId
      type
      amount
      status
      recipientName
      recipientAccount
      description
      transactionFee
      referenceNumber
      category
      createdAt
      completedAt
    }
  ''';

  /// Extended transaction fields with relations
  static const String transactionWithRelations = '''
    fragment TransactionWithRelations on Transaction {
      ...TransactionCore
      fromAccount {
        id
        accountNumber
        accountType
        balance
        currency
      }
      fromCard {
        id
        cardNumber
        cardType
        balance
      }
      toBeneficiary {
        id
        name
        accountNumber
        bankName
      }
    }
    $transactionCore
  ''';

  /// Balance summary fields
  static const String balanceSummary = '''
    fragment BalanceSummary on BalanceSummary {
      id
      year
      month
      totalIncome
      totalExpense
      endingBalance
      transactionCount
      recordedAt
    }
  ''';

  /// Chart data fields
  static const String chartData = '''
    fragment ChartData on ChartDataPoint {
      month
      balance
      income
      expense
      isCurrentMonth
    }
  ''';

  /// Page info for pagination
  static const String pageInfo = '''
    fragment PageInfoFields on PageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
  ''';
}
