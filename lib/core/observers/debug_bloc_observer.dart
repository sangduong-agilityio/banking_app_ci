import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/services/api/bloc_debug_service.dart';

/// Enhanced BLoC observer with debugging and visualization
class DebugBlocObserver extends BlocObserver {
  final BlocDebugService _debugService = BlocDebugService.instance;
  final bool enableLogging;
  final bool enableAnalysis;
  
  // Auto-print analysis every N events
  final Map<String, int> _eventCounts = {};
  static const int _printAnalysisEvery = 10;

  DebugBlocObserver({
    this.enableLogging = true,
    this.enableAnalysis = true,
  });

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (enableLogging) {
      debugPrint('BLoC Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    
    if (event == null) return;
    
    if (enableLogging) {
      debugPrint('Event: ${event.runtimeType} → ${bloc.runtimeType}');
    }
    
    if (enableAnalysis) {
      _debugService.onEventStarted(bloc, event);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    
    // Check if state actually changed (Equatable may skip emission)
    final stateChanged = transition.currentState != transition.nextState;
    
    if (enableLogging) {
      if (!stateChanged) {
        // REDUNDANT STATE SKIPPED BY EQUATABLE!
        debugPrint('[REDUNDANT SKIPPED] ${bloc.runtimeType} - Equatable prevented duplicate state emission');
        debugPrint('   Event: ${transition.event.runtimeType}');
        debugPrint('   State unchanged: ${_formatState(transition.currentState)}');
      } else {
        debugPrint('Transition: ${bloc.runtimeType}');
        debugPrint('   Event: ${transition.event.runtimeType}');
        debugPrint('   From: ${_formatState(transition.currentState)}');
        debugPrint('   To: ${_formatState(transition.nextState)}');
      }
    }
    
    if (enableAnalysis && stateChanged) {
      _debugService.onTransition(bloc, transition);
      
      // Auto-print analysis every N transitions
      final blocName = bloc.runtimeType.toString();
      _eventCounts[blocName] = (_eventCounts[blocName] ?? 0) + 1;
      
      if (_eventCounts[blocName]! % _printAnalysisEvery == 0) {
        debugPrint('\n${'=' * 70}');
        debugPrint(' AUTO ANALYSIS REPORT (after ${_eventCounts[blocName]} transitions)');
        debugPrint('=' * 70);
        _debugService.printAnalysis(blocName);
        debugPrint('=' * 70 + '\n');
      }
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (enableLogging) {
      debugPrint('Error in ${bloc.runtimeType}: $error');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (enableLogging) {
      debugPrint('BLoC Closed: ${bloc.runtimeType}');
    }
  }

  String _formatState(dynamic state) {
    final stateStr = state.toString();
    // Truncate long states
    return stateStr.length > 100 
        ? '${stateStr.substring(0, 97)}...' 
        : stateStr;
  }

  /// Print analysis for a specific BLoC
  void printAnalysis(String blocName) {
    _debugService.printAnalysis(blocName);
  }

  /// Print analysis for all BLoCs
  void printAllAnalysis() {
    _debugService.printAllAnalysis();
  }

  /// Get statistics for a BLoC
  Map<String, dynamic>? getStatistics(String blocName) {
    return _debugService.getStatistics(blocName);
  }

  /// Clear data for a specific BLoC
  void clear(String blocName) {
    _debugService.clear(blocName);
  }

  /// Clear all data
  void clearAll() {
    _debugService.clearAll();
  }
}
