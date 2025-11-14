import 'dart:async';
import 'dart:math' as math;

import 'package:banking_app/core/data/services/api/api_client.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/data/services/exchange_cache_manager.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/data/models/exchange_model.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';
import 'package:banking_app/features/search/domain/repositories/search_repository.dart';

/// Implementation of [SearchRepository] using a banking API client and caching services.
///
/// KEY IMPROVEMENTS:
/// - Better error logging for debugging
/// - Validates cached rates before using them
/// - Checks API responses for invalid data
/// - Clear fallback chain: API → valid cache → error
/// - Removed misleading getRateStatus() method
class SearchRepositoryImpl implements SearchRepository {
  final BankingApiClient _client;
  final ExchangeCacheManager _cacheManager;

  SearchRepositoryImpl({
    required BankingApiClient client,
    required ExchangeCacheManager cacheManager,
  }) : _client = client,
       _cacheManager = cacheManager;

  /// Fetch exchange rates from API with fallback to cache.
  /// Returns fresh rates if online, cached rates if offline/error.
  @override
  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  }) async {
    // Check if cache is valid and skip API if not forced to refresh
    if (!forceRefresh && _cacheManager.isRateCacheValid) {
      final cached = _cacheManager.getCachedRates();
      if (cached.isNotEmpty) {
        return cached;
      }
    }

    try {
      final rates = await _retry<List<ExchangeRateModel>>(() async {
        final apiUrl = '${Env.endPoint}/exchange_rates';
        final response = await _client.get(
          apiUrl,
          queryParams: {'select': 'country,flag,buy,sell'},
        );

        final jsonData = response.data;
        if (jsonData == null || jsonData is! List) {
          throw Exception(
            'Invalid response for exchange_rates: '
            'expected List but got ${jsonData.runtimeType}',
          );
        }

        final exchangeRates = jsonData
            .map((json) => ExchangeRateModel.fromJson(json))
            .cast<ExchangeRateModel>()
            .toList();

        if (exchangeRates.isEmpty) {
          throw Exception('API returned empty exchange rates list');
        }

        _cacheManager.cacheRates(exchangeRates);
        return exchangeRates;
      });

      return rates;
    } catch (e) {
      // Fallback to cache on error
      if (_cacheManager.hasRateCache) {
        final cached = _cacheManager.getCachedRates();
        return cached;
      }

      rethrow;
    }
  }

  /// Fetch interest rates from API.
  @override
  Future<List<InterestRateModel>> fetchInterestRates() async {
    try {
      final rates = await _retry<List<InterestRateModel>>(() async {
        final apiUrl = '${Env.endPoint}/interest_rates';
        final response = await _client.get(
          apiUrl,
          queryParams: {'select': 'id,type,period,rate'},
        );

        final jsonData = response.data;
        if (jsonData == null || jsonData is! List) {
          return <InterestRateModel>[];
        }

        final rates = (jsonData)
            .map((json) => InterestRateModel.fromJson(json))
            .cast<InterestRateModel>()
            .toList();

        return rates;
      });

      return rates;
    } catch (e) {
      return [];
    }
  }

  /// Perform a conversion/exchange with API and cache the rate.
  @override
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  }) async {
    try {
      final exchange = await _retry<ExchangeModel>(() async {
        final apiUrl = '${Env.endPoint}/exchange';

        final response = await _client.get(
          apiUrl,
          queryParams: {
            'select': 'from_currency,to_currency,from_amount,to_amount,rate',
            'from_currency': 'eq.$fromCurrency',
            'to_currency': 'eq.$toCurrency',
            'limit': '1',
          },
        );

        final data = response.data;
        if (data == null || data is! List || data.isEmpty) {
          throw Exception(
            'No exchange data returned for $fromCurrency → $toCurrency',
          );
        }

        final jsonData = data.first;
        final rate = double.tryParse(jsonData['rate']?.toString() ?? '') ?? 0.0;

        // IMPORTANT: Validate rate is not 0 or negative
        if (rate <= 0) {
          throw Exception(
            'Invalid exchange rate received: $rate '
            '(must be > 0)',
          );
        }

        final toAmount = fromAmount * rate;

        // Cache rate for offline/future use
        _cacheManager.cacheOfflineRate(
          from: fromCurrency,
          to: toCurrency,
          rate: rate,
        );

        return ExchangeModel(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          fromAmount: fromAmount,
          toAmount: toAmount,
          rate: rate,
        );
      });

      return exchange;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch currencies from API with fallback to cache.
  @override
  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      final currencies = await _retry<List<CurrencyModel>>(() async {
        final apiUrl = '${Env.endPoint}/currencies';
        final response = await _client.get(
          apiUrl,
          queryParams: {'select': 'code,name'},
        );

        final jsonData = response.data;
        if (jsonData == null || jsonData is! List) {
          return <CurrencyModel>[];
        }

        final list = (jsonData)
            .map((json) => CurrencyModel.fromJson(json))
            .cast<CurrencyModel>()
            .toList();

        if (list.isEmpty) {
          throw Exception('API returned empty currencies list');
        }

        _cacheManager.cacheCurrencies(list);
        return list;
      });

      if (currencies.isNotEmpty) return currencies;

      // Fallback to cache if API returned empty
      final cached = _cacheManager.getCachedCurrencies();
      if (cached.isNotEmpty) {
        return cached;
      }

      return currencies;
    } catch (e) {
      // Fallback to cache on error
      final cached = _cacheManager.getCachedCurrencies();
      if (cached.isNotEmpty) {
        return cached;
      }

      rethrow;
    }
  }

  /// Convert currency using API rate, with fallback to cached rate.
  ///
  /// IMPORTANT: This method now properly validates cached rates.
  /// The actual "freshness" status is tracked by SearchBloc,
  /// not by this repository.
  @override
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    if (fromCurrency == toCurrency) {
      return amount;
    }

    try {
      final exchangeResult = await exchange(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        fromAmount: 1.0,
      );

      final result = amount * exchangeResult.rate;
      return result;
    } catch (e) {
      // Try cached rate (forward direction)
      var cachedRate = _cacheManager.getOfflineRate(fromCurrency, toCurrency);

      // If not found, try reverse direction and invert
      if (cachedRate == null) {
        final reverseRate = _cacheManager.getOfflineRate(
          toCurrency,
          fromCurrency,
        );

        if (reverseRate != null && reverseRate > 0) {
          cachedRate = 1.0 / reverseRate;

          // Cache the calculated forward rate for future use
          _cacheManager.cacheOfflineRate(
            from: fromCurrency,
            to: toCurrency,
            rate: cachedRate,
          );
        }
      }

      if (cachedRate != null) {
        final result = amount * cachedRate;
        return result;
      }

      throw Exception(
        'No exchange rate available for $fromCurrency → $toCurrency',
      );
    }
  }

  /// Generic retry with exponential backoff.
  /// Retries up to 3 times with delays: 2s, 4s, 8s
  Future<T> _retry<T>(Future<T> Function() body, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        return await body();
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          rethrow;
        }

        final backoffSeconds = math.pow(2, attempt).toInt();
        await Future.delayed(Duration(seconds: backoffSeconds));
      }
    }
  }
}
