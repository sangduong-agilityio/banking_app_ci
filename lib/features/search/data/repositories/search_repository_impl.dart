import 'dart:async';
import 'dart:math';

import 'package:banking_app/core/data/services/api/api_client.dart';
import 'package:banking_app/app/env/env.dart';
import 'package:banking_app/core/data/services/exchange_rate_cache_service.dart';
import 'package:banking_app/features/search/presentation/blocs/search_state.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/data/models/exchange_model.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/interest_rate_model.dart';
import 'package:banking_app/features/search/domain/repositories/search_repository.dart';
import 'package:banking_app/core/common/utils/helpers.dart';
import 'package:banking_app/features/search/data/models/conversion_result.dart';

/// Implementation of [SearchRepository] using a banking API client and caching services.
class SearchRepositoryImpl implements SearchRepository {
  final BankingApiClient _client;
  final CacheManager _cacheManager;

  SearchRepositoryImpl({
    required BankingApiClient client,
    required CacheManager cacheManager,
  }) : _client = client,
       _cacheManager = cacheManager;

  /// Fetches the list of exchange rates.
  @override
  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cacheManager.isExchangeRateCacheValid()) {
      return _cacheManager.getCachedExchangeRates();
    }

    try {
      return await _retry<List<ExchangeRateModel>>(() async {
        String apiUrl = '${Env.endPoint}exchange_rates';
        final response = await _client.get(
          apiUrl,
          queryParams: {'select': 'country,flag,buy,sell'},
        );

        final jsonData = response.data;
        final exchangeRates = (jsonData as List)
            .map((json) => ExchangeRateModel.fromJson(json))
            .toList();

        _cacheManager.cacheExchangeRates(exchangeRates);
        return exchangeRates;
      });
    } catch (_) {
      if (_cacheManager.hasCachedExchangeRateData()) {
        return _cacheManager.getCachedExchangeRates();
      }
      rethrow;
    }
  }

  /// Fetches the list of interest rates.
  @override
  Future<List<InterestRateModel>> fetchInterestRates() async {
    return await _retry<List<InterestRateModel>>(() async {
      String apiUrl = '${Env.endPoint}interest_rates';
      final response = await _client.get(
        apiUrl,
        queryParams: {'select': 'id,type,period,rate'},
      );
      final jsonData = response.data;

      return (jsonData as List)
          .map((json) => InterestRateModel.fromJson(json))
          .toList();
    });
  }

  /// Exchanges a specified amount from one currency to another.
  @override
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  }) async {
    return await _retry<ExchangeModel>(() async {
      final apiUrl = '${Env.endPoint}exchange';

      final response = await _client.get(
        apiUrl,
        queryParams: {
          'select': 'from_currency,to_currency,from_amount,to_amount,rate',
          'from_currency': 'eq.$fromCurrency',
          'to_currency': 'eq.$toCurrency',
          'limit': '1',
        },
      );

      final jsonData = (response.data as List).first;
      final rate = double.tryParse(jsonData['rate'].toString()) ?? 0;
      final toAmount = fromAmount * rate;

      return ExchangeModel(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        fromAmount: fromAmount,
        toAmount: toAmount,
        rate: rate,
      );
    });
  }

  @override
  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      return await _retry<List<CurrencyModel>>(() async {
        String apiUrl = '${Env.endPoint}currencies';
        final response = await _client.get(
          apiUrl,
          queryParams: {'select': 'code,name'},
        );
        final jsonData = response.data;
        final currencies = (jsonData as List)
            .map((json) => CurrencyModel.fromJson(json))
            .toList();
        _cacheManager.cacheCurrencies(currencies);
        return currencies;
      });
    } catch (_) {
      final cachedCurrencies = _cacheManager.getCachedCurrencies();
      if (cachedCurrencies != null) {
        return cachedCurrencies;
      }
      rethrow;
    }
  }

  /// Converts an amount from one currency to another, using cached rates if available.
  @override
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final detailed = await convertCurrencyDetailed(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
    );
    return detailed.toAmount;
  }

  /// Converts with explicit source behavior, including offline default mapping fallback.
  @override
  Future<ConversionResult> convertCurrencyDetailed({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    if (fromCurrency == toCurrency) {
      return ConversionResult(
        rate: 1.0,
        toAmount: amount,
        status: ExchangeRateStatus.fresh,
        lastUpdated: DateTime.now(),
      );
    }

    // 1) Try fresh cached rate first
    final cachedRate = _cacheManager.getCachedRate(fromCurrency, toCurrency);
    final cachedStatus = _cacheManager.getRateStatus(fromCurrency, toCurrency);
    final cachedLastUpdated = _cacheManager.getLastUpdated(fromCurrency, toCurrency);

    if (cachedStatus == ExchangeRateStatus.fresh && cachedRate != null) {
      return ConversionResult(
        rate: cachedRate,
        toAmount: amount * cachedRate,
        status: ExchangeRateStatus.fresh,
        lastUpdated: cachedLastUpdated,
      );
    }

    // 2) Try network
    try {
      final exchangeResult = await exchange(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        fromAmount: 1.0,
      );
      _cacheManager.cacheRate(fromCurrency, toCurrency, exchangeResult.rate);
      return ConversionResult(
        rate: exchangeResult.rate,
        toAmount: amount * exchangeResult.rate,
        status: ExchangeRateStatus.fresh,
        lastUpdated: DateTime.now(),
      );
    } catch (_) {
      // 3) Use stale cached if present
      if (cachedRate != null) {
        return ConversionResult(
          rate: cachedRate,
          toAmount: amount * cachedRate,
          status: cachedStatus,
          lastUpdated: cachedLastUpdated,
        );
      }

      // 4) Final fallback: default mapping based on static baseRates
      final defaultRate = DefaultRates.getRate(fromCurrency, toCurrency);
      if (defaultRate != null) {
        // Do NOT cache default mapping rate; it is an emergency offline derivation
        return ConversionResult(
          rate: defaultRate,
          toAmount: amount * defaultRate,
          status: ExchangeRateStatus.stale,
          lastUpdated: null,
        );
      }

      throw Exception('No available exchange rate for $fromCurrency -> $toCurrency');
    }
  }

  /// Gets the status of the exchange rate between two currencies.
  @override
  ExchangeRateStatus getRateStatus(String fromCurrency, String toCurrency) {
    return _cacheManager.getRateStatus(fromCurrency, toCurrency);
  }

  /// Gets the last update time of the exchange rate between two currencies.
  @override
  DateTime? getLastRateUpdate(String fromCurrency, String toCurrency) {
    return _cacheManager.getLastUpdated(fromCurrency, toCurrency);
  }

  /// Retry mechanism with exponential backoff.
  Future<T> _retry<T>(Future<T> Function() body, {int retries = 3}) async {
    int attempt = 0;
    while (true) {
      try {
        return await body();
      } catch (e) {
        if (++attempt >= retries) {
          rethrow;
        }
        final delay = Duration(seconds: pow(2, attempt).toInt());
        await Future.delayed(delay);
      }
    }
  }
}
