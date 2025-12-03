import 'package:dio/dio.dart';

/// A GraphQL exception for GraphQL-specific errors.
class GraphQLException implements Exception {
  const GraphQLException({required this.message});
  final String message;

  @override
  String toString() => 'GraphQLException: $message';
}

class GraphQLClient {
  /// Creates a [GraphQLClient] with the given endpoint.
  GraphQLClient({required this.endpoint, Dio? dio})
    : _dio =
          dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 30)));

  /// The GraphQL endpoint URL.
  final String endpoint;

  final Dio _dio;

  /// Executes a GraphQL query.
  ///
  /// [query] - The GraphQL query string.
  /// [variables] - Optional variables for the query.
  ///
  /// Returns the data from the GraphQL response.
  ///
  /// Example:
  /// ```dart
  /// final result = await client.query(
  ///   query: '''
  ///     query GetUsers {
  ///       users {
  ///         id
  ///         name
  ///         email
  ///       }
  ///     }
  ///   ''',
  /// );
  /// ```
  Future<Map<String, dynamic>> query({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    return _execute(query: query, variables: variables);
  }

  /// Executes a GraphQL mutation.
  ///
  /// [mutation] - The GraphQL mutation string.
  /// [variables] - Optional variables for the mutation.
  ///
  /// Returns the data from the GraphQL response.
  ///
  /// Example:
  /// ```dart
  /// final result = await client.mutate(
  ///   mutation: '''
  ///     mutation AddUser(\$input: UserInput!) {
  ///       addUser(input: \$input) {
  ///         id
  ///         name
  ///         email
  ///       }
  ///     }
  ///   ''',
  ///   variables: {
  ///     'input': {
  ///       'name': 'John Doe',
  ///       'email': 'john@example.com',
  ///     },
  ///   },
  /// );
  /// ```
  Future<Map<String, dynamic>> mutate({
    required String mutation,
    Map<String, dynamic>? variables,
  }) async {
    return _execute(query: mutation, variables: variables);
  }

  /// Internal method to execute GraphQL operations.
  Future<Map<String, dynamic>> _execute({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: {'query': query, if (variables != null) 'variables': variables},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      if (data == null) {
        throw const GraphQLException(
          message: 'Empty response from GraphQL server',
        );
      }

      // Check for GraphQL errors
      if (data.containsKey('errors')) {
        final errors = data['errors'] as List<dynamic>;
        if (errors.isNotEmpty) {
          final errorMessage = errors
              .map((e) => (e as Map<String, dynamic>)['message'] as String?)
              .where((m) => m != null)
              .join(', ');
          throw GraphQLException(
            message: errorMessage.isNotEmpty
                ? errorMessage
                : 'GraphQL operation failed',
          );
        }
      }

      // Return the data portion of the response
      if (data.containsKey('data')) {
        return data['data'] as Map<String, dynamic>;
      }

      return data;
    } on DioException catch (e) {
      throw GraphQLException(message: e.message ?? 'Network error occurred');
    }
  }
}

/// GraphQL query/mutation definitions for the Users module.
///
/// This class contains all GraphQL operations related to users.
/// Using a centralized location for queries makes them easier to maintain
/// and test.
class UsersGraphQLQueries {
  /// Query to fetch all users.
  ///
  /// Returns a list of users with their id, name, email, and avatar.
  static const String getUsers = '''
    query GetUsers {
      users {
        id
        name
        email
        avatar
        createdAt
      }
    }
  ''';

  /// Query to fetch a single user by ID.
  static const String getUserById = '''
    query GetUserById(\$id: ID!) {
      user(id: \$id) {
        id
        name
        email
        avatar
        createdAt
      }
    }
  ''';

  /// Mutation to add a new user.
  ///
  /// Input: name (required), email (required), avatar (optional)
  /// Returns the created user.
  static const String addUser = '''
    mutation AddUser(\$input: CreateUserInput!) {
      createUser(input: \$input) {
        id
        name
        email
        avatar
        createdAt
      }
    }
  ''';

  /// Mutation to update an existing user.
  static const String updateUser = '''
    mutation UpdateUser(\$id: ID!, \$input: UpdateUserInput!) {
      updateUser(id: \$id, input: \$input) {
        id
        name
        email
        avatar
        createdAt
      }
    }
  ''';

  /// Mutation to delete a user.
  static const String deleteUser = '''
    mutation DeleteUser(\$id: ID!) {
      deleteUser(id: \$id) {
        success
        message
      }
    }
  ''';
}
