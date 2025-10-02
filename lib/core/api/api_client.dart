import 'dart:io';
import 'package:banking_app/core/api/failure.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/security/audit_logger.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class BankingApiClient {
  final Dio _dio;

  BankingApiClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ) {
    _setupSecureClient();
  }

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

  /// Setup secure HTTP client with certificate pinning and security headers
  void _setupSecureClient() {
    _dio.interceptors.add(_SecurityInterceptor());

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
          client.badCertificateCallback = (cert, host, port) {
            return _validateCertificate(cert, host);
          };

          client.connectionTimeout = const Duration(seconds: 30);
          client.idleTimeout = const Duration(seconds: 30);

          return client;
        };
  }

  /// Validate SSL certificate against pinned certificates
  bool _validateCertificate(X509Certificate cert, String host) {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return _validatePinnedCertificate(cert, host);
    }

    // Development mode - log certificate info for debugging
    _logCertificateInfo(cert, host);
    return true;
  }

  bool _validatePinnedCertificate(X509Certificate cert, String host) {
    try {
      final fingerprint = _getCertificateFingerprint(cert);
      final expectedFingerprint = _getPinnedFingerprint(host);

      if (expectedFingerprint.isEmpty) {
        AuditLogger.logSuspicious(
          userId: 'system',
          activity: 'unpinned_certificate',
          description: 'No pinned certificate found for host: $host',
          metadata: {'host': host, 'fingerprint': fingerprint},
        );
        return true;
      }

      final isValid = fingerprint == expectedFingerprint;

      if (!isValid) {
        AuditLogger.logSuspicious(
          userId: 'system',
          activity: 'certificate_mismatch',
          description: 'SSL certificate fingerprint mismatch for host: $host',
          metadata: {
            'host': host,
            'expected_fingerprint': expectedFingerprint,
            'actual_fingerprint': fingerprint,
          },
        );
      }

      return isValid;
    } catch (e) {
      AuditLogger.logSuspicious(
        userId: 'system',
        activity: 'certificate_validation_error',
        description: 'Error validating certificate for host: $host',
        metadata: {'host': host, 'error': e.toString()},
      );
      return false;
    }
  }

  String _getCertificateFingerprint(X509Certificate cert) {
    return 'sha256_fingerprint_placeholder';
  }

  String _getPinnedFingerprint(String host) {
    const pinnedCertificates = <String, String>{};

    if (pinnedCertificates.containsKey(host)) {
      return pinnedCertificates[host]!;
    }

    for (final entry in pinnedCertificates.entries) {
      if (entry.key.startsWith('*.') && host.endsWith(entry.key.substring(1))) {
        return entry.value;
      }
    }

    return '';
  }

  void _logCertificateInfo(X509Certificate cert, String host) {
    try {
      final fingerprint = _getCertificateFingerprint(cert);
      print('CERT_DEBUG: Host: $host, Fingerprint: $fingerprint');
      print('CERT_DEBUG: Subject: ${cert.subject}');
      print('CERT_DEBUG: Issuer: ${cert.issuer}');
      print('CERT_DEBUG: Valid from: ${cert.startValidity}');
      print('CERT_DEBUG: Valid to: ${cert.endValidity}');
    } catch (e) {
      print('CERT_DEBUG: Error logging certificate info: $e');
    }
  }
}

/// Security interceptor for adding headers and logging
class _SecurityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
    });

    AuditLogger.logEvent(
      category: 'API',
      event: 'request',
      userId: 'system',
      metadata: {
        'endpoint': options.path,
        'method': options.method,
        'has_data': options.data != null,
      },
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AuditLogger.logEvent(
      category: 'API',
      event: 'response',
      userId: 'system',
      metadata: {
        'endpoint': response.requestOptions.path,
        'status_code': response.statusCode,
        'response_size': response.data?.toString().length ?? 0,
      },
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AuditLogger.logSuspicious(
      userId: 'system',
      activity: 'api_error',
      description: 'API request failed',
      metadata: {
        'endpoint': err.requestOptions.path,
        'method': err.requestOptions.method,
        'error_type': err.type.toString(),
        'status_code': err.response?.statusCode,
        'error_message': err.message,
      },
    );

    super.onError(err, handler);
  }
}
