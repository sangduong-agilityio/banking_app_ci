import 'package:sentry_flutter/sentry_flutter.dart';

/// A unified monitoring service for crash, performance, and analytics tracking.
class MonitoringService {
  MonitoringService._();
  static final MonitoringService instance = MonitoringService._();

  /// Capture unexpected errors or exceptions.
  Future<void> logError(
    dynamic error, {
    StackTrace? stackTrace,
    String? hint,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: hint != null ? Hint.withMap({'hint': hint}) : null,
    );
  }

  /// Record a user event (e.g., button click, flow success).
  Future<void> logEvent(String eventName, {Map<String, dynamic>? data}) async {
    await Sentry.captureMessage(
      'UserEvent: $eventName',
      withScope: (scope) {
        scope.setContexts('event_data', data ?? {});
      },
    );
  }

  /// Track performance of a specific code block.
  Future<void> tracePerformance(
    String name,
    Future<void> Function() action,
  ) async {
    final transaction = Sentry.startTransaction(name, 'performance');
    try {
      await action();
      transaction.finish(status: const SpanStatus.ok());
    } catch (e, st) {
      transaction.finish(status: const SpanStatus.internalError());
      await logError(
        e,
        stackTrace: st,
        hint: 'Performance trace failed: $name',
      );
    }
  }

  /// Log a business metric (e.g., transfer amount, payment count).
  Future<void> logBusinessMetric(
    String metricName, {
    required num value,
    Map<String, dynamic>? tags,
  }) async {
    await Sentry.captureMessage(
      'BusinessMetric: $metricName = $value',
      withScope: (scope) {
        scope.setContexts('metric_tags', tags ?? {});
      },
    );
  }
}
