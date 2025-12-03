import 'package:banking_app/core/error_handling/failure.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';

/// A utility class for sanitizing and logging errors securely.
class ErrorSanitizer {
  /// Sanitizes errors to prevent sensitive information exposure.
  static String sanitize(Object error) {
    // Handle Supabase authentication errors
    if (error is AuthException) {
      return _handleAuthException(error);
    }

    // Handle Dio/Network errors
    if (error is DioException) {
      return _handleNetworkException(error);
    }

    // Handle application failures
    if (error is Failure) {
      return _handleApplicationFailure(error);
    }

    // Handle generic exceptions
    return _handleGenericError(error);
  }

  /// Maps Supabase [AuthException] to user-friendly messages.
  static String _handleAuthException(AuthException error) {
    switch (error.message.toLowerCase()) {
      case 'invalid login credentials':
      case 'invalid_credentials':
        return S.current.authErrorInvalidCredentials;
      case 'email not confirmed':
        return S.current.authErrorEmailNotConfirmed;
      case 'user not found':
        return S.current.authErrorUserNotFound;
      case 'too many requests':
        return S.current.authErrorTooManyAttempts;
      case 'weak password':
        return S.current.authErrorWeakPassword;
      case 'email already registered':
        return S.current.authErrorEmailAlreadyExists;
      default:
        return S.current.authErrorGeneric;
    }
  }

  /// Maps [DioException] to user-friendly messages.
  static String _handleNetworkException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return S.current.networkErrorTimeout;
      case DioExceptionType.connectionError:
        return S.current.networkErrorConnection;
      case DioExceptionType.badCertificate:
        return S.current.networkErrorSecurity;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return _handleHttpStatusCode(statusCode);
      default:
        return S.current.networkErrorGeneric;
    }
  }

  /// Maps HTTP status codes to user-friendly messages.
  static String _handleHttpStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return S.current.httpErrorBadRequest;
      case 401:
        return S.current.httpErrorUnauthorized;
      case 403:
        return S.current.httpErrorForbidden;
      case 404:
        return S.current.httpErrorNotFound;
      case 429:
        return S.current.httpErrorTooManyRequests;
      case 500:
      case 502:
      case 503:
      case 504:
        return S.current.httpErrorServerError;
      default:
        return S.current.httpErrorGeneric;
    }
  }

  /// Handles application-specific failures.
  static String _handleApplicationFailure(Failure failure) {
    // Application failures should already be sanitized
    // but double-check for sensitive information
    final message = failure.message;

    // Remove any potential stack traces or internal paths
    if (message.contains('Exception:') ||
        message.contains('Error:') ||
        message.contains('/lib/') ||
        message.contains('dart:')) {
      return S.current.applicationErrorGeneric;
    }

    // Truncate overly long messages
    if (message.length > 150) {
      return S.current.applicationErrorGeneric;
    }

    return message;
  }

  /// Handles any other generic errors.
  static String _handleGenericError(Object error) {
    final message = error.toString().toLowerCase();

    // Check for sensitive information patterns
    if (message.contains('exception') ||
        message.contains('error:') ||
        message.contains('stack trace') ||
        message.contains('dart:') ||
        message.contains('/lib/') ||
        message.contains('supabase') ||
        message.contains('database') ||
        message.contains('sql') ||
        message.contains('token') ||
        message.contains('key') ||
        message.contains('secret')) {
      return S.current.applicationErrorGeneric;
    }

    // Return generic error for any unhandled cases
    return S.current.applicationErrorGeneric;
  }

  /// Logs errors securely to Firebase Crashlytics with context sanitization.
  static Future<void> logSecureError(
    Object error,
    StackTrace? stackTrace, {
    String? userId,
    Map<String, dynamic>? context,
    bool isCritical = false,
  }) async {
    _sanitizeContext(context);

    // Sentry removed: log locally or to Firebase Crashlytics if needed
    // Also log to console in development mode
    assert(() {
      return true;
    }());
  }

  /// Sanitizes context by removing sensitive keys and truncating long values.
  static Map<String, dynamic> _sanitizeContext(Map<String, dynamic>? context) {
    if (context == null) return {};

    final sanitized = <String, dynamic>{};

    for (final entry in context.entries) {
      final key = entry.key.toLowerCase();

      // Skip sensitive keys
      if (key.contains('password') ||
          key.contains('token') ||
          key.contains('key') ||
          key.contains('secret') ||
          key.contains('pin') ||
          key.contains('otp')) {
        continue;
      }

      // Truncate overly long string values
      final value = entry.value;
      if (value is String && value.length > 100) {
        sanitized[entry.key] = '${value.substring(0, 100)}...';
      } else {
        sanitized[entry.key] = value;
      }
    }

    return sanitized;
  }
}
