import 'package:banking_app/core/api/failure.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:dio/dio.dart';

class BankingApiClient {
  final Dio _dio;

  BankingApiClient({required String baseUrl})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));

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
        options: Options(headers: {'apikey': Env.supabaseKey}),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) =>
      _request('GET', endpoint: endpoint, queryParams: queryParams);

  Future<Response> post(String endpoint, {dynamic data}) =>
      _request('POST', endpoint: endpoint, data: data);

  Future<Response> patch(String endpoint, {dynamic data}) =>
      _request('PATCH', endpoint: endpoint, data: data);

  Future<Response> delete(String endpoint, {dynamic data}) =>
      _request('DELETE', endpoint: endpoint, data: data);
}
