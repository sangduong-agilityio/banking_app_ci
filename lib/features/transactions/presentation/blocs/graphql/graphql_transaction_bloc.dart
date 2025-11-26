import 'dart:async';
import 'package:banking_app/core/common/bloc/base_bloc.dart';
import 'package:banking_app/core/error_handling/graphql_exceptions.dart';
import 'package:banking_app/features/transactions/data/repositories/graphql_transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'graphql_transaction_event.dart';
import 'graphql_transaction_state.dart';

/// BLoC for managing GraphQL transaction operations
/// 
/// This BLoC handles:
/// - Loading transactions with pagination
/// - Filtering and searching transactions
/// - Loading transaction reports
/// - Creating and updating transactions
/// - Real-time updates via subscriptions
class GraphQLTransactionBloc
    extends BaseBloc<GraphQLTransactionEvent, GraphQLTransactionState> {
  final GraphQLTransactionRepository _repository;

  /// Debounce timer for search
  Timer? _searchDebounce;

  /// Default page size for pagination
  static const int _defaultPageSize = 20;

  GraphQLTransactionBloc({required GraphQLTransactionRepository repository})
      : _repository = repository,
        super(const GraphQLTransactionState()) {
    // Query events
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<LoadTransactionReportEvent>(_onLoadTransactionReport);
    on<LoadBalanceHistoryEvent>(_onLoadBalanceHistory);
    on<GetTransactionEvent>(_onGetTransaction);
    
    // Search events
    on<SearchTransactionsEvent>(_onSearchTransactions);
    on<ClearSearchEvent>(_onClearSearch);
    
    // Filter events
    on<ApplyFilterEvent>(_onApplyFilter);
    on<ClearFilterEvent>(_onClearFilter);
    
    // Mutation events
    on<CreateTransactionEvent>(_onCreateTransaction);
    on<UpdateTransactionStatusEvent>(_onUpdateTransactionStatus);
    on<CancelTransactionEvent>(_onCancelTransaction);
    
    // Refresh
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // ==================== QUERY HANDLERS ====================

  /// Handles loading transactions with optional filtering
  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    // If refreshing, clear existing data
    if (event.refresh) {
      emit(state.copyWith(
        status: const GraphQLTransactionStatus.loading(),
        transactions: [],
        clearNextCursor: true,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: const GraphQLTransactionStatus.loading(),
        clearError: true,
      ));
    }

    await executeWithErrorHandling(
      () async {
        final result = await _repository.getTransactions(
          filter: event.filter ?? state.currentFilter,
          first: event.pageSize,
          orderByField: 'CREATED_AT',
          descending: true,
        );

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.success(),
          transactions: result.transactions,
          totalCount: result.totalCount,
          nextCursor: result.endCursor,
          hasNextPage: result.hasNextPage,
          currentFilter: event.filter,
        ));
      },
      operationName: 'load_transactions',
      isCritical: false,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles loading more transactions (pagination)
  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    // Don't load more if already loading or no more pages
    if (state.isLoading || !state.hasNextPage || state.nextCursor == null) {
      return;
    }

    emit(state.copyWith(
      status: const GraphQLTransactionStatus.loadingMore(),
    ));

    await executeWithErrorHandling(
      () async {
        final result = await _repository.getTransactions(
          filter: state.currentFilter,
          first: _defaultPageSize,
          after: state.nextCursor,
          orderByField: 'CREATED_AT',
          descending: true,
        );

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.success(),
          transactions: [...state.transactions, ...result.transactions],
          totalCount: result.totalCount,
          nextCursor: result.endCursor,
          hasNextPage: result.hasNextPage,
        ));
      },
      operationName: 'load_more_transactions',
      isCritical: false,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles loading transaction report
  Future<void> _onLoadTransactionReport(
    LoadTransactionReportEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.loading(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final report = await _repository.getTransactionReport(
          from: event.from,
          to: event.to,
          accountId: event.accountId,
        );

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.success(),
          transactionReport: report,
        ));
      },
      operationName: 'load_transaction_report',
      isCritical: false,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles loading balance history
  Future<void> _onLoadBalanceHistory(
    LoadBalanceHistoryEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.loading(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final history = await _repository.getBalanceHistory(
          months: event.months,
          accountId: event.accountId,
        );

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.success(),
          balanceHistory: history,
        ));
      },
      operationName: 'load_balance_history',
      isCritical: false,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles getting a single transaction
  Future<void> _onGetTransaction(
    GetTransactionEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.loading(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final transaction = await _repository.getTransaction(event.id);

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.success(),
          selectedTransaction: transaction,
        ));
      },
      operationName: 'get_transaction',
      isCritical: false,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  // ==================== SEARCH HANDLERS ====================

  /// Handles searching transactions with debounce
  Future<void> _onSearchTransactions(
    SearchTransactionsEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    // Cancel previous debounce
    _searchDebounce?.cancel();

    // Don't search for empty queries
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(
        clearSearch: true,
        status: const GraphQLTransactionStatus.success(),
      ));
      return;
    }

    emit(state.copyWith(
      status: const GraphQLTransactionStatus.searching(),
      searchQuery: event.query,
    ));

    // Debounce the search
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      await executeWithErrorHandling(
        () async {
          final result = await _repository.searchTransactions(
            event.query,
            first: _defaultPageSize,
          );

          emit(state.copyWith(
            status: const GraphQLTransactionStatus.success(),
            searchResults: result.transactions,
          ));
        },
        operationName: 'search_transactions',
        isCritical: false,
      ).catchError((error) {
        _handleError(emit, error);
      });
    });
  }

  /// Handles clearing search
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) {
    _searchDebounce?.cancel();
    emit(state.copyWith(
      clearSearch: true,
      status: const GraphQLTransactionStatus.success(),
    ));
  }

  // ==================== FILTER HANDLERS ====================

  /// Handles applying a filter
  Future<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    // Reload transactions with the new filter
    add(LoadTransactionsEvent(
      filter: event.filter,
      refresh: true,
    ));
  }

  /// Handles clearing the filter
  Future<void> _onClearFilter(
    ClearFilterEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(clearFilter: true));
    add(const LoadTransactionsEvent(refresh: true));
  }

  // ==================== MUTATION HANDLERS ====================

  /// Handles creating a new transaction
  Future<void> _onCreateTransaction(
    CreateTransactionEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.mutating(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final transaction = await _repository.createTransaction(event.input);

        // Add the new transaction to the list
        emit(state.copyWith(
          status: const GraphQLTransactionStatus.mutationSuccess(),
          transactions: [transaction, ...state.transactions],
          totalCount: state.totalCount + 1,
          lastMutationResult: transaction,
        ));
      },
      operationName: 'create_transaction',
      isCritical: true,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles updating transaction status
  Future<void> _onUpdateTransactionStatus(
    UpdateTransactionStatusEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.mutating(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final transaction = await _repository.updateTransactionStatus(
          event.id,
          event.status,
        );

        // Update the transaction in the list
        final updatedTransactions = state.transactions.map((t) {
          return t.id == event.id ? transaction : t;
        }).toList();

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.mutationSuccess(),
          transactions: updatedTransactions,
          lastMutationResult: transaction,
          selectedTransaction:
              state.selectedTransaction?.id == event.id ? transaction : null,
        ));
      },
      operationName: 'update_transaction_status',
      isCritical: true,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  /// Handles canceling a transaction
  Future<void> _onCancelTransaction(
    CancelTransactionEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    emit(state.copyWith(
      status: const GraphQLTransactionStatus.mutating(),
      clearError: true,
    ));

    await executeWithErrorHandling(
      () async {
        final transaction = await _repository.cancelTransaction(event.id);

        // Update the transaction in the list
        final updatedTransactions = state.transactions.map((t) {
          return t.id == event.id ? transaction : t;
        }).toList();

        emit(state.copyWith(
          status: const GraphQLTransactionStatus.mutationSuccess(),
          transactions: updatedTransactions,
          lastMutationResult: transaction,
        ));
      },
      operationName: 'cancel_transaction',
      isCritical: true,
    ).catchError((error) {
      _handleError(emit, error);
    });
  }

  // ==================== REFRESH HANDLER ====================

  /// Handles refreshing transactions
  Future<void> _onRefreshTransactions(
    RefreshTransactionsEvent event,
    Emitter<GraphQLTransactionState> emit,
  ) async {
    add(const LoadTransactionsEvent(refresh: true));
  }

  // ==================== ERROR HANDLING ====================

  /// Handles errors and updates state
  void _handleError(Emitter<GraphQLTransactionState> emit, Object error) {
    String message;
    String? code;

    if (error is GraphQLException) {
      message = '[GraphQLException] Code: ${error.code}\nMessage: ${error.message}';
      code = error.code;
    } else if (error is Exception) {
      message = '[Exception] ${error.toString()}';
    } else {
      message = '[Unknown error] ${error.toString()}';
    }

    // Optionally, add stack trace if available
    // message += '\nStackTrace: ${StackTrace.current}';

    emit(state.copyWith(
      status: const GraphQLTransactionStatus.failure(),
      errorMessage: message,
      errorCode: code,
    ));
  }
}
