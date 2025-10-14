import 'dart:io';

import 'package:banking_app/core/common/constants/constants.dart';
import 'package:dio/dio.dart';

/// A class representing a failure with a message and an optional code.
class Failure {
  /// Creates a [Failure] object.
  const Failure({required this.message, this.code});

  /// The error message.
  final String message;

  /// The error code.
  final int? code;
}

/// A utility class for handling and mapping errors to [Failure] objects.
class ErrorMappingHandler {
  /// Maps different types of errors to a [Failure] object.
  static Failure apiErrorMappingHandler(Object error) {
    if (error is DioException) {
      final response = error.response;
      final statusCode = response?.statusCode;
      // Handle different DioException types
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return Failure(
            message: DioExceptionMessages.connectionTimeout,
            code: statusCode,
          );
        case DioExceptionType.sendTimeout:
          return Failure(
            message: DioExceptionMessages.sendTimeout,
            code: statusCode,
          );
        case DioExceptionType.receiveTimeout:
          return Failure(
            message: DioExceptionMessages.receiveTimeout,
            code: statusCode,
          );
        case DioExceptionType.badCertificate:
          return Failure(message: error.message ?? '', code: statusCode);
        case DioExceptionType.badResponse:
          return Failure(message: error.message ?? '', code: statusCode);
        case DioExceptionType.cancel:
          return Failure(
            message: DioExceptionMessages.cancel,
            code: statusCode,
          );
        case DioExceptionType.connectionError:
          return Failure(
            message: DioExceptionMessages.connectionError,
            code: statusCode,
          );
        case DioExceptionType.unknown:
          return Failure(message: error.message ?? '', code: statusCode);
      }
    } else if (error is SocketException) {
      return const Failure(message: DioExceptionMessages.connectionError);
    } else if (error is FormatException) {
      return Failure(message: error.message);
    } else {
      return const Failure(
        message: DioExceptionMessages.unexpectedErrorOccurred,
      );
    }
  }
}
