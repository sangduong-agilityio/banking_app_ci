import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamController<bool> _connectionStatusController;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityService() {
    _connectionStatusController = StreamController<bool>.broadcast();
    _init();
  }

  void _init() {
    // Listen to connectivity changes - onConnectivityChanged emits ConnectivityResult now
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isOnline =
            results.isNotEmpty && !results.contains(ConnectivityResult.none);
        _connectionStatusController.add(isOnline);
      },
      onError: (error) {
        // Log error
      },
    );

    // Check initial connection state
    _checkInitialConnection();
  }

  /// Check the current connection status when service is initialized.
  Future<void> _checkInitialConnection() async {
    try {
      // checkConnectivity() now returns List<ConnectivityResult>
      final results = await _connectivity.checkConnectivity();

      // If list contains none OR is empty, we're offline
      final isOnline =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);

      _connectionStatusController.add(isOnline);
    } catch (e) {
      _connectionStatusController.add(true);
    }
  }

  /// Stream of connection status changes.
  /// Emits true when online, false when offline.
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  /// Get current connection status (snapshot).
  Future<bool> getCurrentStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final isOnline =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      return isOnline;
    } catch (e) {
      return true;
    }
  }

  /// Dispose the service (call in app lifecycle).
  void dispose() {
    _connectionStatusController.close();
    _connectivitySubscription.cancel();
  }
}
