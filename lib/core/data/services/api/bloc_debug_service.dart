import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_analyzer.dart';

/// Centralized BLoC debugging and analysis service
class BlocDebugService {
  BlocDebugService._();

  static final instance = BlocDebugService._();

  final _analyzers = <String, BlocAnalyzer>{};
  final _eventTimestamps = <String, DateTime>{};

  /// Get or create analyzer for a BLoC
  BlocAnalyzer getAnalyzer(String blocName) {
    return _analyzers.putIfAbsent(
      blocName,
      () => BlocAnalyzer(blocName: blocName),
    );
  }

  /// Record event start
  void onEventStarted<Event>(Bloc bloc, Event event) {
    final key = '${bloc.runtimeType}_${event.runtimeType}_${event.hashCode}';
    _eventTimestamps[key] = DateTime.now();
  }

  /// Record state transition
  void onTransition<Event, State>(
    Bloc bloc,
    Transition<Event, State> transition,
  ) {
    final blocName = bloc.runtimeType.toString();
    final eventName = transition.event.runtimeType.toString();
    final key = '${blocName}_${eventName}_${transition.event.hashCode}';

    final startTime = _eventTimestamps.remove(key);
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    getAnalyzer(blocName).recordStateChange(
      event: eventName,
      previousState: transition.currentState,
      currentState: transition.nextState,
      duration: duration,
    );
  }

  /// Print analysis for a specific BLoC
  void printAnalysis(String blocName) {
    final analyzer = _analyzers[blocName];
    if (analyzer != null) {
      analyzer.printAnalysis();
    } else {
      developer.log('No data for $blocName', name: 'BlocDebugService');
    }
  }

  /// Print analysis for all BLoCs
  void printAllAnalysis() {
    if (_analyzers.isEmpty) {
      developer.log('No BLoC data collected', name: 'BlocDebugService');
      return;
    }

    for (final analyzer in _analyzers.values) {
      analyzer.printAnalysis();
    }
  }

  /// Get statistics for a BLoC
  Map<String, dynamic>? getStatistics(String blocName) {
    return _analyzers[blocName]?.getStatistics();
  }

  /// Get all statistics
  Map<String, Map<String, dynamic>> getAllStatistics() {
    return _analyzers.map((name, analyzer) {
      return MapEntry(name, analyzer.getStatistics());
    });
  }

  /// Clear data for a specific BLoC
  void clear(String blocName) {
    _analyzers[blocName]?.clear();
    _eventTimestamps.removeWhere((key, _) => key.startsWith(blocName));
  }

  /// Clear all data
  void clearAll() {
    _analyzers.forEach((_, analyzer) => analyzer.clear());
    _eventTimestamps.clear();
  }
}
