import 'dart:convert';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/error_handling/failure.dart';
import 'package:dio/dio.dart';

/// GraphQL Client for making GraphQL queries and mutations
///
/// Flow: GraphQL Client → Repository → BLoC → UI
class GraphQLClient {
  final Dio _dio;
  final String _endpoint;

  GraphQLClient({String? endpoint})
    : _endpoint = endpoint ?? '${Env.endPoint}/graphql',
      _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'apikey': Env.supabaseKey,
          },
        ),
      );

  Future<Map<String, dynamic>> query({
    required String query,
    Map<String, dynamic>? variables,
    String? operationName,
  }) async {
    return _execute(
      query: query,
      variables: variables,
      operationName: operationName,
    );
  }

  Future<Map<String, dynamic>> mutate({
    required String mutation,
    Map<String, dynamic>? variables,
    String? operationName,
  }) async {
    return _execute(
      query: mutation,
      variables: variables,
      operationName: operationName,
    );
  }

  /// Internal method to execute GraphQL operations
  Future<Map<String, dynamic>> _execute({
    required String query,
    Map<String, dynamic>? variables,
    String? operationName,
  }) async {
    try {
      final body = <String, dynamic>{
        'query': query,
        if (variables != null) 'variables': variables,
        if (operationName != null) 'operationName': operationName,
      };

      final response = await _dio.post(_endpoint, data: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for GraphQL errors
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'] as List;
          if (errors.isNotEmpty) {
            throw GraphQLException(
              message: errors.first['message'] ?? 'GraphQL Error',
              errors: errors.cast<Map<String, dynamic>>(),
            );
          }
        }

        return data['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw GraphQLException(
          message: 'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }
}

/// Custom exception for GraphQL errors
class GraphQLException implements Exception {
  final String message;
  final List<Map<String, dynamic>>? errors;
  final int? statusCode;

  GraphQLException({required this.message, this.errors, this.statusCode});

  @override
  String toString() => 'GraphQLException: $message';
}
