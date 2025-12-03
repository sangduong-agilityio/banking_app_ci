import 'dart:developer' as developer;

/// Advanced BLoC analyzer for detecting performance issues
class BlocAnalyzer {
  BlocAnalyzer({this.blocName = 'TransferBloc'});

  final String blocName;
  final List<_StateChange> _stateChanges = [];
  final Map<String, int> _redundantEmissions = {};
  final Map<String, List<Duration>> _eventDurations = {};

  /// Record a state change
  void recordStateChange({
    required String event,
    required dynamic previousState,
    required dynamic currentState,
    required Duration duration,
  }) {
    _stateChanges.add(
      _StateChange(
        event: event,
        previousState: previousState.toString(),
        currentState: currentState.toString(),
        duration: duration,
        timestamp: DateTime.now(),
      ),
    );

    _eventDurations.putIfAbsent(event, () => []).add(duration);

    if (previousState == currentState) {
      _redundantEmissions[event] = (_redundantEmissions[event] ?? 0) + 1;
    }
  }

  /// Analyze and print performance report
  void printAnalysis() {
    developer.log(
      '\n${'=' * 60}\n'
      'BLoC Analysis Report: $blocName\n'
      '${'=' * 60}',
      name: 'BlocAnalyzer',
    );

    _printEventPerformance();
    _printRedundantEmissions();
    _printStateChangeFrequency();
    _printRecommendations();

    developer.log('${'=' * 60}\n', name: 'BlocAnalyzer');
  }

  void _printEventPerformance() {
    if (_eventDurations.isEmpty) return;

    developer.log('\nEvent Performance:', name: 'BlocAnalyzer');

    final sorted = _eventDurations.entries.toList()
      ..sort((a, b) {
        final avgA =
            a.value.fold<int>(0, (sum, d) => sum + d.inMilliseconds) /
            a.value.length;
        final avgB =
            b.value.fold<int>(0, (sum, d) => sum + d.inMilliseconds) /
            b.value.length;
        return avgB.compareTo(avgA);
      });

    for (final entry in sorted) {
      final durations = entry.value;
      final total = durations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
      final avg = total / durations.length;
      final max = durations
          .map((d) => d.inMilliseconds)
          .reduce((a, b) => a > b ? a : b);
      final min = durations
          .map((d) => d.inMilliseconds)
          .reduce((a, b) => a < b ? a : b);

      final performance = avg < 16
          ? 'Good'
          : avg < 100
          ? 'Medium'
          : 'Slow';

      developer.log(
        '  ${entry.key}:\n'
        '    Count: ${durations.length}\n'
        '    Avg: ${avg.toStringAsFixed(2)}ms $performance\n'
        '    Range: $min-${max}ms',
        name: 'BlocAnalyzer',
      );
    }
  }

  void _printRedundantEmissions() {
    if (_redundantEmissions.isEmpty) {
      developer.log('\nNo Redundant Emissions Detected', name: 'BlocAnalyzer');
      return;
    }

    developer.log('\nRedundant Emissions:', name: 'BlocAnalyzer');
    final sorted = _redundantEmissions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sorted) {
      developer.log(
        '  ${entry.key}: ${entry.value} times',
        name: 'BlocAnalyzer',
        level: 900,
      );
    }
  }

  void _printStateChangeFrequency() {
    if (_stateChanges.isEmpty) return;

    final eventCounts = <String, int>{};
    for (final change in _stateChanges) {
      eventCounts[change.event] = (eventCounts[change.event] ?? 0) + 1;
    }

    developer.log(
      '\nState Change Frequency (Total: ${_stateChanges.length}):',
      name: 'BlocAnalyzer',
    );

    final sorted = eventCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sorted.take(10)) {
      final percentage = (entry.value / _stateChanges.length * 100);
      developer.log(
        '  ${entry.key}: ${entry.value} (${percentage.toStringAsFixed(1)}%)',
        name: 'BlocAnalyzer',
      );
    }
  }

  void _printRecommendations() {
    final recommendations = <String>[];

    _eventDurations.forEach((event, durations) {
      final avg =
          durations.fold<int>(0, (sum, d) => sum + d.inMilliseconds) /
          durations.length;
      if (avg > 100) {
        recommendations.add(
          '$event is slow (${avg.toStringAsFixed(0)}ms avg). '
          'Consider optimizing or moving to isolate.',
        );
      }
    });

    _redundantEmissions.forEach((event, count) {
      if (count > 3) {
        recommendations.add(
          '$event emits redundant states $count times. '
          'Add buildWhen/listenWhen or fix BLoC logic.',
        );
      }
    });

    final eventCounts = <String, int>{};
    for (final change in _stateChanges) {
      eventCounts[change.event] = (eventCounts[change.event] ?? 0) + 1;
    }

    eventCounts.forEach((event, count) {
      if (count > 50) {
        recommendations.add(
          '$event triggered $count times. '
          'This might indicate excessive UI interactions or infinite loops.',
        );
      }
    });

    if (recommendations.isEmpty) {
      developer.log('\nNo Performance Issues Detected', name: 'BlocAnalyzer');
      return;
    }

    developer.log('\nRecommendations:', name: 'BlocAnalyzer');
    for (var i = 0; i < recommendations.length; i++) {
      developer.log('  ${i + 1}. ${recommendations[i]}', name: 'BlocAnalyzer');
    }
  }

  /// Get detailed statistics
  Map<String, dynamic> getStatistics() {
    final eventCounts = <String, int>{};
    for (final change in _stateChanges) {
      eventCounts[change.event] = (eventCounts[change.event] ?? 0) + 1;
    }

    return {
      'totalStateChanges': _stateChanges.length,
      'uniqueEvents': _eventDurations.keys.length,
      'redundantEmissions': Map.from(_redundantEmissions),
      'eventCounts': eventCounts,
      'averageDurations': _eventDurations.map(
        (key, value) => MapEntry(
          key,
          value.fold<int>(0, (sum, d) => sum + d.inMilliseconds) / value.length,
        ),
      ),
    };
  }

  /// Clear all data
  void clear() {
    _stateChanges.clear();
    _redundantEmissions.clear();
    _eventDurations.clear();
  }
}

class _StateChange {
  const _StateChange({
    required this.event,
    required this.previousState,
    required this.currentState,
    required this.duration,
    required this.timestamp,
  });

  final String event;
  final String previousState;
  final String currentState;
  final Duration duration;
  final DateTime timestamp;
}
