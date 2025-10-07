import 'dart:convert';
import 'dart:io';
import 'package:banking_app/core/api/failure.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/security/error_sanitizer.dart';
import 'package:banking_app/core/security/security_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';

class BankingApiClient {
  final Dio _dio;

  BankingApiClient({required String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: SecurityConfig.networkTimeout,
          receiveTimeout: SecurityConfig.networkTimeout,
          sendTimeout: SecurityConfig.networkTimeout,
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
        ErrorSanitizer.logSecureError(
          Exception('Missing pinned certificate for host: $host'),
          StackTrace.current,
          context: {'host': host, 'fingerprint': fingerprint},
          isCritical: false,
        );
        return true;
      }

      final isValid = fingerprint == expectedFingerprint;

      if (!isValid) {
        print(
          'SECURITY_ERROR: SSL certificate fingerprint mismatch for host: $host',
        );

        ErrorSanitizer.logSecureError(
          Exception('Certificate pinning failed for host: $host'),
          StackTrace.current,
          context: {
            'host': host,
            'expected': expectedFingerprint,
            'actual': fingerprint,
          },
          isCritical: true, // Certificate mismatch = potential MITM attack
        );
      }

      return isValid;
    } catch (e) {
      ErrorSanitizer.logSecureError(
        e,
        StackTrace.current,
        context: {'host': host, 'stage': 'certificate_validation'},
        isCritical: true,
      );

      return false;
    }
  }

  String _getCertificateFingerprint(X509Certificate cert) {
    final derBytes = cert.der; // Get DER-encoded certificate
    final digest = sha256.convert(derBytes);
    return 'sha256/${base64.encode(digest.bytes)}';
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
    options.headers.addAll(SecurityConfig.securityHeaders);
    print('API_REQUEST: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'API_RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('API_ERROR: ${err.type} ${err.requestOptions.path} - ${err.message}');

    if (_shouldLogToSentry(err)) {
      await ErrorSanitizer.logSecureError(
        err,
        err.stackTrace,
        context: {
          'endpoint': err.requestOptions.path,
          'method': err.requestOptions.method,
          'status_code': err.response?.statusCode,
          'error_type': err.type.name,
        },
        isCritical: _isCriticalError(err),
      );
    }

    super.onError(err, handler);
  }

  bool _shouldLogToSentry(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return false;
    }

    return true;
  }

  bool _isCriticalError(DioException err) {
    // Certificate errors = CRITICAL
    if (err.type == DioExceptionType.badCertificate) {
      return true;
    }

    // Server errors 5xx = CRITICAL
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }

    // Connection errors = CRITICAL (có thể là network attack)
    if (err.type == DioExceptionType.connectionError) {
      return true;
    }

    return false;
  }
}
