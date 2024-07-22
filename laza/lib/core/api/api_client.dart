import 'package:dio/dio.dart';
import 'package:laza/core/api/failure.dart';
import 'package:laza/core/env/env.dart';

class LazaApiClient {
  final Dio _dio;

  LazaApiClient({
    required String baseUrl,
  }) : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
        ));

  Future<Response> _request(
    String method, {
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: {
            'endpoint': endpoint = Env.supabaseKey,
          },
        ),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) =>
      _request(
        'GET',
        endpoint: endpoint,
        queryParams: queryParams,
      );

  Future<Response> post(String endpoint, {dynamic data}) => _request(
        'POST',
        endpoint: endpoint,
        data: data,
      );

  Future<Response> patch(String endpoint, {dynamic data}) => _request(
        'PATCH',
        endpoint: endpoint,
        data: data,
      );

  Future<Response> delete(String endpoint, {dynamic data}) => _request(
        'DELETE',
        endpoint: endpoint,
        data: data,
      );
}
