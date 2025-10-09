import 'package:banking_app/core/api/api_client.dart';
import 'package:banking_app/core/env/env.dart';
import 'package:banking_app/core/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/services/offline_exchange_service.dart';
import 'package:banking_app/features/search/models/currency_model.dart';
import 'package:banking_app/features/search/models/exchange_model.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/models/interest_rate_model.dart';
import 'package:banking_app/features/search/states/search_state.dart';

/// Repository for handling currency exchange and interest rate data.
abstract class SearchRepository {
  /// Exchanges a specified amount from one currency to another.
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  });

  /// Fetches the list of exchange rates, optionally forcing a refresh from the API.
  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  });

  /// Fetches the list of interest rates.
  Future<List<InterestRateModel>> fetchInterestRates();

  /// Fetches the list of available currencies.
  Future<List<CurrencyModel>> fetchCurrencies();

  /// Converts an amount from one currency to another, using cached rates if available.
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  });

  /// Gets the status of the exchange rate between two currencies.
  ExchangeRateStatus getRateStatus(String fromCurrency, String toCurrency);

  /// Gets the last update time of the exchange rate between two currencies.
  DateTime? getLastRateUpdate(String fromCurrency, String toCurrency);
}

/// Implementation of [SearchRepository] using a banking API client and caching services.
class SearchRepositoryImplement implements SearchRepository {
  final BankingApiClient _client;
  final ExchangeRateCacheService _cacheService;
  final OfflineExchangeService _offlineService;

  SearchRepositoryImplement({
    required BankingApiClient client,
    required ExchangeRateCacheService cacheService,
    required OfflineExchangeService offlineService,
  }) : _client = client,
       _cacheService = cacheService,
       _offlineService = offlineService;

  /// Fetches the list of exchange rates.
  @override
  Future<List<ExchangeRateModel>> fetchExchangeRates({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cacheService.isCacheValid()) {
      return _cacheService.getCachedRates();
    }

    try {
      String apiUrl = '${Env.endPoint}exchange_rates';
      final response = await _client.get(
        apiUrl,
        queryParams: {'select': 'country,flag,buy,sell'},
      );

      final jsonData = response.data;
      final exchangeRates = (jsonData as List)
          .map((json) => ExchangeRateModel.fromJson(json))
          .toList();

      _cacheService.cacheRates(exchangeRates);
      return exchangeRates;
    } catch (_) {
      if (_cacheService.hasCachedData()) {
        return _cacheService.getCachedRates();
      }
      rethrow;
    }
  }

  /// Fetches the list of interest rates.
  @override
  Future<List<InterestRateModel>> fetchInterestRates() async {
    String apiUrl = '${Env.endPoint}interest_rates';
    final response = await _client.get(
      apiUrl,
      queryParams: {'select': 'id,type,period,rate'},
    );
    final jsonData = response.data;

    return (jsonData as List)
        .map((json) => InterestRateModel.fromJson(json))
        .toList();
  }

  /// Exchanges a specified amount from one currency to another.
  @override
  Future<ExchangeModel> exchange({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  }) async {
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
  }

  /// Fetches the list of available currencies.
  @override
  Future<List<CurrencyModel>> fetchCurrencies() async {
    String apiUrl = '${Env.endPoint}currencies';
    final response = await _client.get(
      apiUrl,
      queryParams: {'select': 'code,name'},
    );
    final jsonData = response.data;
    return (jsonData as List)
        .map((json) => CurrencyModel.fromJson(json))
        .toList();
  }

  /// Converts an amount from one currency to another, using cached rates if available.
  @override
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    if (fromCurrency == toCurrency) {
      return amount;
    }

    final cachedRate = _offlineService.getCachedRate(fromCurrency, toCurrency);
    final rateStatus = _offlineService.getRateStatus(fromCurrency, toCurrency);

    if (rateStatus == ExchangeRateStatus.fresh && cachedRate != null) {
      return amount * cachedRate;
    }

    try {
      final exchangeResult = await exchange(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        fromAmount: 1.0,
      );

      _offlineService.cacheRate(fromCurrency, toCurrency, exchangeResult.rate);
      return amount * exchangeResult.rate;
    } catch (_) {
      if (cachedRate != null) {
        return amount * cachedRate;
      }

      throw Exception(
        'No available exchange rate for $fromCurrency -> $toCurrency',
      );
    }
  }

  /// Gets the status of the exchange rate between two currencies.
  @override
  ExchangeRateStatus getRateStatus(String fromCurrency, String toCurrency) {
    return _offlineService.getRateStatus(fromCurrency, toCurrency);
  }

  /// Gets the last update time of the exchange rate between two currencies.
  @override
  DateTime? getLastRateUpdate(String fromCurrency, String toCurrency) {
    return _offlineService.getLastUpdated(fromCurrency, toCurrency);
  }
}
