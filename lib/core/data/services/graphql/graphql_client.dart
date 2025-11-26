import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/error_handling/graphql_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A GraphQL client for the banking application.
/// 
/// This client provides:
/// - Automatic authentication via Supabase JWT tokens
/// - Error handling and mapping
/// - Caching policies
/// - Request/Response logging in debug mode
class BankingGraphQLClient {
  static BankingGraphQLClient? _instance;
  late final GraphQLClient _client;
  
  /// Private constructor for singleton pattern
  BankingGraphQLClient._internal() {
    _client = _createClient();
  }
  
  /// Returns the singleton instance of [BankingGraphQLClient]
  factory BankingGraphQLClient() {
    _instance ??= BankingGraphQLClient._internal();
    return _instance!;
  }
  
  /// Creates and configures the GraphQL client
  GraphQLClient _createClient() {
    // HTTP Link - connects to Supabase GraphQL endpoint
    final httpLink = HttpLink(
      Env.supabaseGraphQLEndpoint,
      defaultHeaders: {
        'apikey': Env.supabaseKey,
        'Content-Type': 'application/json',
      },
    );
    
    // Auth Link - adds JWT token to requests
    final authLink = AuthLink(
      getToken: () async {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return 'Bearer ${session.accessToken}';
        }
        return null;
      },
    );
    
    // Error Link - handles GraphQL errors
    final errorLink = ErrorLink(
      onGraphQLError: (request, forward, response) {
        // Log GraphQL errors
        if (response.errors != null) {
          for (final error in response.errors!) {
            _logError('GraphQL Error: ${error.message}');
          }
        }
        return null;
      },
      onException: (request, forward, exception) {
        _logError('GraphQL Exception: $exception');
        return null;
      },
    );
    
    // Combine links: Error -> Auth -> HTTP
    final link = Link.from([
      errorLink,
      authLink,
      httpLink,
    ]);
    
    // Create client with in-memory cache
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheFirst,
          error: ErrorPolicy.all,
          cacheReread: CacheRereadPolicy.mergeOptimistic,
        ),
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.all,
        ),
      ),
    );
  }
  
  /// Logs errors in debug mode
  void _logError(String message) {
    assert(() {
      // ignore: avoid_print
      print('[BankingGraphQLClient] $message');
      return true;
    }());
  }
  
  /// Returns the underlying GraphQL client
  GraphQLClient get client => _client;
  
  /// Executes a GraphQL query
  /// 
  /// Throws [GraphQLQueryException] if the query fails
  Future<QueryResult<T>> query<T>(
    QueryOptions<T> options, {
    bool throwOnError = true,
  }) async {
    try {
      final result = await _client.query(options);
      
      if (throwOnError && result.hasException) {
        throw GraphQLQueryException.fromResult(result);
      }
      
      return result;
    } catch (e) {
      if (e is GraphQLException) rethrow;
      throw GraphQLNetworkException(e.toString());
    }
  }
  
  /// Executes a GraphQL mutation
  /// 
  /// Throws [GraphQLMutationException] if the mutation fails
  Future<QueryResult<T>> mutate<T>(
    MutationOptions<T> options, {
    bool throwOnError = true,
  }) async {
    try {
      final result = await _client.mutate(options);
      
      if (throwOnError && result.hasException) {
        throw GraphQLMutationException.fromResult(result);
      }
      
      return result;
    } catch (e) {
      if (e is GraphQLException) rethrow;
      throw GraphQLNetworkException(e.toString());
    }
  }
  
  /// Creates a subscription stream
  Stream<QueryResult<T>> subscribe<T>(SubscriptionOptions<T> options) {
    return _client.subscribe(options);
  }
  
  /// Clears the GraphQL cache
  void clearCache() {
    _client.cache.store.reset();
  }
  
  /// Resets the client (useful for logout)
  static void reset() {
    _instance = null;
  }
}

/// Extension to add convenience methods to GraphQL results
extension QueryResultExtension<T> on QueryResult<T> {
  /// Returns true if the result has data and no exceptions
  bool get isSuccess => !hasException && data != null;
  
  /// Returns the first error message if any
  String? get firstErrorMessage {
    if (exception?.graphqlErrors.isNotEmpty ?? false) {
      return exception!.graphqlErrors.first.message;
    }
    return exception?.linkException?.toString();
  }
  
  /// Extracts data from a specific key
  Map<String, dynamic>? dataForKey(String key) {
    if (data == null) return null;
    return data![key] as Map<String, dynamic>?;
  }
  
  /// Extracts a list from a specific key
  List<Map<String, dynamic>>? listForKey(String key) {
    if (data == null) return null;
    final list = data![key] as List<dynamic>?;
    return list?.cast<Map<String, dynamic>>();
  }
}
