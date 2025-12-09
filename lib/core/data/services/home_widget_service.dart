import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';

class HomeWidgetService {
  /// The method channel for widget communication
  static const MethodChannel _channel = MethodChannel(
    'com.example.banking_app/widget',
  );

  /// Singleton instance
  static final HomeWidgetService _instance = HomeWidgetService._internal();
  factory HomeWidgetService() => _instance;
  HomeWidgetService._internal();

  /// Check if home screen widgets are supported on this platform
  Future<bool> isWidgetSupported() async {
    // Only Android supports home screen widgets in this implementation
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final bool isSupported = await _channel.invokeMethod('isWidgetSupported');
      return isSupported;
    } on PlatformException catch (e) {
      debugPrint('HomeWidgetService: Error checking widget support: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('HomeWidgetService: Widget plugin not available');
      return false;
    }
  }

  /// Updates the home screen widget with the latest exchange rates.
  ///
  /// [rates] - List of exchange rates to display in the widget.
  /// The widget will display up to 5 rates.
  ///
  /// Returns `true` if the update was successful, `false` otherwise.
  Future<bool> updateExchangeRates(List<ExchangeRateModel> rates) async {
    if (!Platform.isAndroid) {
      debugPrint('HomeWidgetService: Widgets not supported on this platform');
      return false;
    }

    try {
      // Convert rates to JSON format expected by the widget
      final List<Map<String, String>> ratesData = rates
          .take(5) // Widget displays max 5 rates
          .map((rate) => {
                'country': rate.country,
                'flag': rate.flag,
                'buy': rate.buy,
                'sell': rate.sell,
              })
          .toList();

      final String ratesJson = jsonEncode(ratesData);

      final bool result = await _channel.invokeMethod('updateExchangeRates', {
        'rates': ratesJson,
      });

      debugPrint('HomeWidgetService: Updated widget with ${rates.length} rates');
      return result;
    } on PlatformException catch (e) {
      debugPrint('HomeWidgetService: Error updating widget: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('HomeWidgetService: Widget plugin not available');
      return false;
    }
  }

  /// Initializes the widget with the API endpoint for background updates.
  ///
  /// [apiEndpoint] - The base URL for the exchange rates API.
  /// This is stored by the native side for periodic background fetches.
  ///
  /// Returns `true` if initialization was successful.
  Future<bool> initializeWidget({required String apiEndpoint}) async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final bool result = await _channel.invokeMethod('initializeWidget', {
        'apiEndpoint': apiEndpoint,
      });

      debugPrint('HomeWidgetService: Initialized widget with endpoint: $apiEndpoint');
      return result;
    } on PlatformException catch (e) {
      debugPrint('HomeWidgetService: Error initializing widget: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('HomeWidgetService: Widget plugin not available');
      return false;
    }
  }

  /// Triggers an immediate refresh of the widget data.
  ///
  /// This schedules a background work to fetch fresh exchange rates
  /// and update the widget.
  ///
  /// Returns `true` if the refresh was triggered successfully.
  Future<bool> refreshWidget() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final bool result = await _channel.invokeMethod('refreshWidget');
      debugPrint('HomeWidgetService: Widget refresh triggered');
      return result;
    } on PlatformException catch (e) {
      debugPrint('HomeWidgetService: Error refreshing widget: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('HomeWidgetService: Widget plugin not available');
      return false;
    }
  }
}
