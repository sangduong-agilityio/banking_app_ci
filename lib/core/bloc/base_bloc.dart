import 'package:banking_app/core/security/error_sanitizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  /// Safely execute async operations with automatic error logging
  Future<T?> executeWithErrorHandling<T>(
    Future<T> Function() operation, {
    required String operationName,
    bool isCritical = false,
    Map<String, dynamic>? context,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      await ErrorSanitizer.logSecureError(
        e,
        stackTrace,
        userId: getCurrentUserId(),
        context: {
          'operation': operationName,
          'bloc': runtimeType.toString(),
          ...?context,
        },
        isCritical: isCritical,
      );
      rethrow;
    }
  }

  /// Override this in child BLoCs to provide user ID
  String? getCurrentUserId() => null;
}
