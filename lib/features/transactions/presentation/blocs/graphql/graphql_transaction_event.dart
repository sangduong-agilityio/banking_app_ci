import 'package:equatable/equatable.dart';
import 'package:banking_app/features/transactions/data/repositories/graphql_transaction_repository.dart';
import 'package:banking_app/features/transactions/data/models/transaction_model.dart';

/// Base class for all GraphQL transaction events
sealed class GraphQLTransactionEvent extends Equatable {
  const GraphQLTransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load transactions with optional filtering
class LoadTransactionsEvent extends GraphQLTransactionEvent {
  final TransactionFilter? filter;
  final int pageSize;
  final bool refresh;

  const LoadTransactionsEvent({
    this.filter,
    this.pageSize = 20,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [filter, pageSize, refresh];
}

/// Event to load more transactions (pagination)
class LoadMoreTransactionsEvent extends GraphQLTransactionEvent {
  const LoadMoreTransactionsEvent();
}

/// Event to load transaction report
class LoadTransactionReportEvent extends GraphQLTransactionEvent {
  final DateTime from;
  final DateTime to;
  final String? accountId;

  const LoadTransactionReportEvent({
    required this.from,
    required this.to,
    this.accountId,
  });

  @override
  List<Object?> get props => [from, to, accountId];
}

/// Event to load balance history
class LoadBalanceHistoryEvent extends GraphQLTransactionEvent {
  final int months;
  final String? accountId;

  const LoadBalanceHistoryEvent({
    this.months = 12,
    this.accountId,
  });

  @override
  List<Object?> get props => [months, accountId];
}

/// Event to search transactions
class SearchTransactionsEvent extends GraphQLTransactionEvent {
  final String query;

  const SearchTransactionsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search
class ClearSearchEvent extends GraphQLTransactionEvent {
  const ClearSearchEvent();
}

/// Event to get a single transaction
class GetTransactionEvent extends GraphQLTransactionEvent {
  final String id;

  const GetTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to create a new transaction
class CreateTransactionEvent extends GraphQLTransactionEvent {
  final CreateTransactionInput input;

  const CreateTransactionEvent(this.input);

  @override
  List<Object?> get props => [input];
}

/// Event to update transaction status
class UpdateTransactionStatusEvent extends GraphQLTransactionEvent {
  final String id;
  final TransactionStatus status;

  const UpdateTransactionStatusEvent({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}

/// Event to cancel a transaction
class CancelTransactionEvent extends GraphQLTransactionEvent {
  final String id;

  const CancelTransactionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event to apply filter
class ApplyFilterEvent extends GraphQLTransactionEvent {
  final TransactionFilter filter;

  const ApplyFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Event to clear filter
class ClearFilterEvent extends GraphQLTransactionEvent {
  const ClearFilterEvent();
}

/// Event to refresh data
class RefreshTransactionsEvent extends GraphQLTransactionEvent {
  const RefreshTransactionsEvent();
}
