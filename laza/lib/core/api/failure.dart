import 'dart:io';

import 'package:dio/dio.dart';
import 'package:laza/core/constant/constants.dart';

class Failure {
  const Failure({required this.message, this.code});
  final String message;
  final int? code;
}

abstract class ErrorMappingHandler {
  static Failure apiErrorMappingHandler(Object error) {
    if (error is Exception) {
      try {
        if (error is DioException) {
          String? errorMessage;
          if (error.response != null) {
            try {
              errorMessage = error.response.toString();
            } catch (_) {}
          }
          if (error.response?.statusCode == 401) {
            Failure(
              message: DioExceptionMessages.unauthenticated,
              code: error.response?.statusCode,
            );
          } else {
            switch (error.type) {
              case DioExceptionType.connectionTimeout:
                return Failure(
                  message: DioExceptionMessages.connectionTimeout,
                  code: error.response?.statusCode,
                );
              case DioExceptionType.sendTimeout:
                return Failure(
                  message: DioExceptionMessages.sendTimeout,
                  code: error.response?.statusCode,
                );
              case DioExceptionType.receiveTimeout:
                return Failure(
                  message: DioExceptionMessages.receiveTimeout,
                  code: error.response?.statusCode,
                );
              case DioExceptionType.badCertificate:
                return Failure(
                  message: errorMessage ?? error.message ?? '',
                  code: error.response?.statusCode,
                );
              case DioExceptionType.badResponse:
                return Failure(
                  message: errorMessage ?? error.message ?? '',
                  code: error.response?.statusCode,
                );
              case DioExceptionType.cancel:
                return Failure(
                  message: DioExceptionMessages.cancel,
                  code: error.response?.statusCode,
                );
              case DioExceptionType.connectionError:
                return Failure(
                  message: DioExceptionMessages.connectionError,
                  code: error.response?.statusCode,
                );
              case DioExceptionType.unknown:
                return Failure(
                  message: errorMessage ?? error.message ?? '',
                  code: error.response?.statusCode,
                );
            }
          }
        } else if (error is SocketException) {
          return const Failure(
            message: DioExceptionMessages.connectionError,
          );
        } else if (error is FormatException) {
          /// Can use FormatException to custom message error
          /// Eg: throw const FormatException('Username or password is incorrect') ///
          return Failure(message: error.message);
        }
      } catch (_) {
        return const Failure(message: '');
      }
    }
    return const Failure(
      message: DioExceptionMessages.unexpectedErrorOccurred,
    );
  }
}
