import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// A unified monitoring service for crash, performance, and analytics tracking.
class MonitoringService {
  MonitoringService._();
  static final MonitoringService instance = MonitoringService._();

  /// Capture unexpected errors or exceptions.
  Future<void> logError(
    dynamic error, {
    StackTrace? stackTrace,
    String? hint,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: hint,
    );
  }

  /// Record a user event (e.g., button click, flow success).
  Future<void> logEvent(String eventName, {Map<String, dynamic>? data}) async {
    // Log as breadcrumb/custom log in Crashlytics
    FirebaseCrashlytics.instance.log('UserEvent: $eventName');
    
    // Optionally set custom keys for the event data
    if (data != null) {
      for (final entry in data.entries) {
        FirebaseCrashlytics.instance.setCustomKey(entry.key, entry.value);
      }
    }
  }

  /// Track performance of a specific code block.
  /// Note: For detailed performance tracking, use Firebase Performance Monitoring
  Future<void> tracePerformance(
    String name,
    Future<void> Function() action,
  ) async {
    final startTime = DateTime.now();
    FirebaseCrashlytics.instance.log('Performance trace started: $name');
    
    try {
      await action();
      final duration = DateTime.now().difference(startTime);
      FirebaseCrashlytics.instance.log(
        'Performance trace completed: $name (${duration.inMilliseconds}ms)',
      );
    } catch (e, st) {
      final duration = DateTime.now().difference(startTime);
      FirebaseCrashlytics.instance.log(
        'Performance trace failed: $name (${duration.inMilliseconds}ms)',
      );
      await logError(
        e,
        stackTrace: st,
        hint: 'Performance trace failed: $name',
      );
      rethrow;
    }
  }

  /// Log a business metric (e.g., transfer amount, payment count).
  Future<void> logBusinessMetric(
    String metricName, {
    required num value,
    Map<String, dynamic>? tags,
  }) async {
    FirebaseCrashlytics.instance.log('BusinessMetric: $metricName = $value');
    
    // Set as custom keys
    FirebaseCrashlytics.instance.setCustomKey('metric_$metricName', value);
    if (tags != null) {
      for (final entry in tags.entries) {
        FirebaseCrashlytics.instance.setCustomKey(
          'metric_tag_${entry.key}',
          entry.value,
        );
      }
    }
  }

  /// Set user identifier for crash reports
  Future<void> setUserId(String userId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  /// Set custom key-value pair for crash context
  void setCustomKey(String key, dynamic value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  /// Log a message (breadcrumb)
  void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
}

