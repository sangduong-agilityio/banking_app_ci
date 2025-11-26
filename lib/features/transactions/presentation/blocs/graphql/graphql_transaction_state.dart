import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';
import 'package:banking_app/features/transactions/data/models/balance_summary_model.dart';
import 'package:banking_app/features/transactions/data/models/transaction_report_model.dart';
import 'package:banking_app/features/transactions/data/repositories/graphql_transaction_repository.dart';

part 'graphql_transaction_state.freezed.dart';

/// Status of GraphQL operations
@freezed
sealed class GraphQLTransactionStatus with _$GraphQLTransactionStatus {
  /// Initial state - no data loaded yet
  const factory GraphQLTransactionStatus.initial() =
      GraphQLTransactionStatusInitial;

  /// Data is being loaded
  const factory GraphQLTransactionStatus.loading() =
      GraphQLTransactionStatusLoading;

  /// Data loaded successfully
  const factory GraphQLTransactionStatus.success() =
      GraphQLTransactionStatusSuccess;

  /// Loading more data (pagination)
  const factory GraphQLTransactionStatus.loadingMore() =
      GraphQLTransactionStatusLoadingMore;

  /// An error occurred
  const factory GraphQLTransactionStatus.failure() =
      GraphQLTransactionStatusFailure;

  /// Mutation in progress (create, update, delete)
  const factory GraphQLTransactionStatus.mutating() =
      GraphQLTransactionStatusMutating;

  /// Mutation completed successfully
  const factory GraphQLTransactionStatus.mutationSuccess() =
      GraphQLTransactionStatusMutationSuccess;

  /// Searching
  const factory GraphQLTransactionStatus.searching() =
      GraphQLTransactionStatusSearching;
}

/// State for the GraphQL Transaction BLoC
class GraphQLTransactionState extends Equatable {
  /// Current operation status
  final GraphQLTransactionStatus status;

  /// List of transactions
  final List<TransactionModel> transactions;

  /// Total count of transactions (from server)
  final int totalCount;

  /// Pagination cursor for next page
  final String? nextCursor;

  /// Whether there are more pages to load
  final bool hasNextPage;

  /// Currently applied filter
  final TransactionFilter? currentFilter;

  /// Transaction report data
  final TransactionReportModel? transactionReport;

  /// Balance history for charts
  final List<BalanceSummaryModel> balanceHistory;

  /// Currently selected/viewed transaction
  final TransactionModel? selectedTransaction;

  /// Search query (if searching)
  final String? searchQuery;

  /// Search results
  final List<TransactionModel> searchResults;

  /// Error message (if any)
  final String? errorMessage;

  /// Error code (if any)
  final String? errorCode;

  /// Last successful mutation result
  final TransactionModel? lastMutationResult;

  const GraphQLTransactionState({
    this.status = const GraphQLTransactionStatus.initial(),
    this.transactions = const [],
    this.totalCount = 0,
    this.nextCursor,
    this.hasNextPage = false,
    this.currentFilter,
    this.transactionReport,
    this.balanceHistory = const [],
    this.selectedTransaction,
    this.searchQuery,
    this.searchResults = const [],
    this.errorMessage,
    this.errorCode,
    this.lastMutationResult,
  });

  /// Creates a copy with updated values
  GraphQLTransactionState copyWith({
    GraphQLTransactionStatus? status,
    List<TransactionModel>? transactions,
    int? totalCount,
    String? nextCursor,
    bool? hasNextPage,
    TransactionFilter? currentFilter,
    TransactionReportModel? transactionReport,
    List<BalanceSummaryModel>? balanceHistory,
    TransactionModel? selectedTransaction,
    String? searchQuery,
    List<TransactionModel>? searchResults,
    String? errorMessage,
    String? errorCode,
    TransactionModel? lastMutationResult,
    bool clearError = false,
    bool clearFilter = false,
    bool clearSearch = false,
    bool clearNextCursor = false,
    bool clearSelectedTransaction = false,
  }) {
    return GraphQLTransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      totalCount: totalCount ?? this.totalCount,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
      transactionReport: transactionReport ?? this.transactionReport,
      balanceHistory: balanceHistory ?? this.balanceHistory,
      selectedTransaction: clearSelectedTransaction
          ? null
          : (selectedTransaction ?? this.selectedTransaction),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      searchResults: clearSearch ? const [] : (searchResults ?? this.searchResults),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      lastMutationResult: lastMutationResult ?? this.lastMutationResult,
    );
  }

  /// Whether the state is in a loading state
  bool get isLoading =>
      status == const GraphQLTransactionStatus.loading() ||
      status == const GraphQLTransactionStatus.loadingMore() ||
      status == const GraphQLTransactionStatus.searching() ||
      status == const GraphQLTransactionStatus.mutating();

  /// Whether the state has an error
  bool get hasError => status == const GraphQLTransactionStatus.failure();

  /// Whether the state has data
  bool get hasData =>
      transactions.isNotEmpty ||
      transactionReport != null ||
      searchResults.isNotEmpty;

  /// Whether a filter is applied
  bool get hasFilter => currentFilter != null && !currentFilter!.isEmpty;

  /// Whether a search is active
  bool get isSearching => searchQuery != null && searchQuery!.isNotEmpty;

  /// Display transactions (search results or regular list)
  List<TransactionModel> get displayTransactions =>
      isSearching ? searchResults : transactions;

  @override
  List<Object?> get props => [
        status,
        transactions,
        totalCount,
        nextCursor,
        hasNextPage,
        currentFilter,
        transactionReport,
        balanceHistory,
        selectedTransaction,
        searchQuery,
        searchResults,
        errorMessage,
        errorCode,
        lastMutationResult,
      ];
}

/// Extension for convenient status checks
extension GraphQLTransactionStatusExtension on GraphQLTransactionStatus {
  /// Whether this status represents a loading state
  bool get isLoading => this == const GraphQLTransactionStatus.loading() ||
      this == const GraphQLTransactionStatus.loadingMore() ||
      this == const GraphQLTransactionStatus.searching() ||
      this == const GraphQLTransactionStatus.mutating();

  /// Whether this status represents a success state
  bool get isSuccess => this == const GraphQLTransactionStatus.success() ||
      this == const GraphQLTransactionStatus.mutationSuccess();

  /// Whether this status represents a failure state
  bool get isFailure => this == const GraphQLTransactionStatus.failure();

  /// User-friendly status message
  String get message {
    return switch (this) {
      GraphQLTransactionStatusInitial() => 'Ready to load',
      GraphQLTransactionStatusLoading() => 'Loading...',
      GraphQLTransactionStatusSuccess() => 'Loaded successfully',
      GraphQLTransactionStatusLoadingMore() => 'Loading more...',
      GraphQLTransactionStatusFailure() => 'An error occurred',
      GraphQLTransactionStatusMutating() => 'Processing...',
      GraphQLTransactionStatusMutationSuccess() => 'Success!',
      GraphQLTransactionStatusSearching() => 'Searching...',
    };
  }
}
