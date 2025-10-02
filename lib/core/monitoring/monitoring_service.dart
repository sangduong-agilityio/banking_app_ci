import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class MonitoringService {
  void recordError(Object error, StackTrace stack, {String? context}) {
    developer.log(
      '[Error] ${context ?? ''} ${error.toString()}',
      name: 'Monitoring',
      error: error,
      stackTrace: stack,
    );
  }

  void logEvent(String name, {Map<String, Object?>? params}) {
    developer.log('[Event] $name ${params ?? {}}', name: 'Monitoring');
  }
}

class MonitoringBinding extends FlutterErrorDetails {
  MonitoringBinding(FlutterErrorDetails details, this.service)
    : super(
        exception: details.exception,
        library: details.library,
        context: details.context,
        informationCollector: details.informationCollector,
        stack: details.stack,
        silent: details.silent,
      );

  final MonitoringService service;
}
