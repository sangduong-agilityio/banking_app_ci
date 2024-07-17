import 'package:dio/dio.dart';
import 'package:laza/core/api/failure.dart';
import 'package:laza/core/constant/constants.dart';

class LazaApiClient {
  final String baseUrl;
  final Dio _dio;

  LazaApiClient({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // GET request
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
            headers: {'endpoint': endpoint = SupabaseConfig.supabaseKey}),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }

  // POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
            headers: {'endpoint': endpoint = SupabaseConfig.supabaseKey}),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }

  // PATCH request
  Future<Response> patch(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        options: Options(
            headers: {'endpoint': endpoint = SupabaseConfig.supabaseKey}),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }

  // DELETE request
  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(
            headers: {'endpoint': endpoint = SupabaseConfig.supabaseKey}),
      );
      return response;
    } catch (e) {
      throw ErrorMappingHandler.apiErrorMappingHandler(e);
    }
  }
}
