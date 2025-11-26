import 'package:graphql_flutter/graphql_flutter.dart';

/// Base class for all GraphQL exceptions
sealed class GraphQLException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? extensions;

  const GraphQLException({
    required this.message,
    this.code,
    this.extensions,
  });

  @override
  String toString() => 'GraphQLException: $message (code: $code)';
}

/// Exception thrown when a GraphQL query fails
class GraphQLQueryException extends GraphQLException {
  final List<GraphQLError>? errors;
  final OperationException? operationException;

  const GraphQLQueryException({
    required super.message,
    super.code,
    super.extensions,
    this.errors,
    this.operationException,
  });

  /// Creates a [GraphQLQueryException] from a [QueryResult]
  static GraphQLQueryException fromResult(QueryResult result) {
    final exception = result.exception;
    
    if (exception == null) {
      return const GraphQLQueryException(
        message: 'Unknown query error',
        code: 'UNKNOWN_ERROR',
      );
    }

    // Handle GraphQL errors
    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      return GraphQLQueryException(
        message: firstError.message,
        code: _extractErrorCode(firstError),
        extensions: firstError.extensions,
        errors: exception.graphqlErrors,
        operationException: exception,
      );
    }

    // Handle link/network errors
    if (exception.linkException != null) {
      return GraphQLQueryException(
        message: exception.linkException.toString(),
        code: 'NETWORK_ERROR',
        operationException: exception,
      );
    }

    return GraphQLQueryException(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
      operationException: exception,
    );
  }

  static String? _extractErrorCode(GraphQLError error) {
    return error.extensions?['code'] as String?;
  }
}

/// Exception thrown when a GraphQL mutation fails
class GraphQLMutationException extends GraphQLException {
  final List<GraphQLError>? errors;
  final OperationException? operationException;
  final String? field;

  const GraphQLMutationException({
    required super.message,
    super.code,
    super.extensions,
    this.errors,
    this.operationException,
    this.field,
  });

  /// Creates a [GraphQLMutationException] from a [QueryResult]
  static GraphQLMutationException fromResult(QueryResult result) {
    final exception = result.exception;
    
    if (exception == null) {
      return const GraphQLMutationException(
        message: 'Unknown mutation error',
        code: 'UNKNOWN_ERROR',
      );
    }

    // Handle GraphQL errors
    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      return GraphQLMutationException(
        message: firstError.message,
        code: _extractErrorCode(firstError),
        extensions: firstError.extensions,
        errors: exception.graphqlErrors,
        operationException: exception,
        field: _extractField(firstError),
      );
    }

    // Handle link/network errors
    if (exception.linkException != null) {
      return GraphQLMutationException(
        message: exception.linkException.toString(),
        code: 'NETWORK_ERROR',
        operationException: exception,
      );
    }

    return GraphQLMutationException(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
      operationException: exception,
    );
  }

  static String? _extractErrorCode(GraphQLError error) {
    return error.extensions?['code'] as String?;
  }

  static String? _extractField(GraphQLError error) {
    return error.extensions?['field'] as String?;
  }
}

/// Exception thrown when a network error occurs
class GraphQLNetworkException extends GraphQLException {
  const GraphQLNetworkException(String message)
      : super(message: message, code: 'NETWORK_ERROR');
}

/// Exception thrown when authentication fails
class GraphQLAuthException extends GraphQLException {
  const GraphQLAuthException([String message = 'Authentication required'])
      : super(message: message, code: 'UNAUTHORIZED');
}

/// Exception thrown when a resource is not found
class GraphQLNotFoundException extends GraphQLException {
  final String resourceType;
  final String? resourceId;

  const GraphQLNotFoundException({
    required this.resourceType,
    this.resourceId,
    String? message,
  }) : super(
          message: message ?? '$resourceType not found',
          code: 'NOT_FOUND',
        );
}

/// Exception thrown for validation errors
class GraphQLValidationException extends GraphQLException {
  final Map<String, String> fieldErrors;

  const GraphQLValidationException({
    required String message,
    this.fieldErrors = const {},
  }) : super(message: message, code: 'VALIDATION_ERROR');

  /// Creates a [GraphQLValidationException] from field-level errors
  factory GraphQLValidationException.fromFields(Map<String, String> errors) {
    final messages = errors.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    return GraphQLValidationException(
      message: 'Validation failed: $messages',
      fieldErrors: errors,
    );
  }
}

/// Transaction-specific GraphQL errors
enum TransactionErrorCode {
  insufficientFunds('INSUFFICIENT_FUNDS', 'Insufficient funds for this transaction'),
  invalidAccount('INVALID_ACCOUNT', 'Invalid account specified'),
  invalidBeneficiary('INVALID_BENEFICIARY', 'Invalid beneficiary specified'),
  transactionLimitExceeded('TRANSACTION_LIMIT_EXCEEDED', 'Transaction limit exceeded'),
  duplicateTransaction('DUPLICATE_TRANSACTION', 'Duplicate transaction detected'),
  accountInactive('ACCOUNT_INACTIVE', 'Account is not active'),
  transactionNotFound('TRANSACTION_NOT_FOUND', 'Transaction not found');

  final String code;
  final String defaultMessage;

  const TransactionErrorCode(this.code, this.defaultMessage);

  /// Matches a code string to a [TransactionErrorCode]
  static TransactionErrorCode? fromCode(String? code) {
    if (code == null) return null;
    return TransactionErrorCode.values.cast<TransactionErrorCode?>().firstWhere(
          (e) => e?.code == code,
          orElse: () => null,
        );
  }
}

/// Exception thrown for transaction-specific errors
class GraphQLTransactionException extends GraphQLException {
  final TransactionErrorCode? errorCode;

  const GraphQLTransactionException({
    required super.message,
    super.code,
    super.extensions,
    this.errorCode,
  });

  factory GraphQLTransactionException.fromCode(
    String code, [
    String? customMessage,
  ]) {
    final errorCode = TransactionErrorCode.fromCode(code);
    return GraphQLTransactionException(
      message: customMessage ?? errorCode?.defaultMessage ?? 'Transaction error',
      code: code,
      errorCode: errorCode,
    );
  }
}

/// Mapper to convert GraphQL exceptions to user-friendly messages
class GraphQLErrorMapper {
  /// Maps a [GraphQLException] to a user-friendly message
  static String toUserMessage(GraphQLException exception) {
    switch (exception) {
      case GraphQLNetworkException():
        return 'Unable to connect. Please check your internet connection.';
      case GraphQLAuthException():
        return 'Your session has expired. Please log in again.';
      case GraphQLNotFoundException():
        return 'The requested ${exception.resourceType.toLowerCase()} was not found.';
      case GraphQLValidationException():
        return exception.message;
      case GraphQLTransactionException():
        return _mapTransactionError(exception);
      case GraphQLQueryException():
        return _mapQueryError(exception);
      case GraphQLMutationException():
        return _mapMutationError(exception);
    }
  }

  static String _mapTransactionError(GraphQLTransactionException exception) {
    switch (exception.errorCode) {
      case TransactionErrorCode.insufficientFunds:
        return 'You don\'t have enough funds for this transaction.';
      case TransactionErrorCode.transactionLimitExceeded:
        return 'This transaction exceeds your daily limit.';
      case TransactionErrorCode.accountInactive:
        return 'This account is currently inactive.';
      default:
        return exception.message;
    }
  }

  static String _mapQueryError(GraphQLQueryException exception) {
    if (exception.code == 'NETWORK_ERROR') {
      return 'Unable to load data. Please try again.';
    }
    return 'An error occurred while loading data.';
  }

  static String _mapMutationError(GraphQLMutationException exception) {
    if (exception.code == 'NETWORK_ERROR') {
      return 'Unable to complete the action. Please try again.';
    }
    return 'An error occurred. Please try again.';
  }
}
