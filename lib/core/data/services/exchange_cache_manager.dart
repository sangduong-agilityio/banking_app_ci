import 'package:banking_app/core/data/services/exchange_rate_cache_service.dart';
import 'package:banking_app/core/data/services/offline_exchange_service.dart';
import 'package:banking_app/core/data/services/currency_cache_service.dart';
import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';

/// Centralized cache coordinator for exchange & currency data.
/// This manager combines multiple cache sources (currency, exchange rate, offline rate)
/// and exposes unified methods for cache operations.
class ExchangeCacheManager {
  final ExchangeRateCacheService rateCache;
  final OfflineExchangeService offlineCache;
  final CurrencyCacheService currencyCache;

  ExchangeCacheManager({
    required this.rateCache,
    required this.offlineCache,
    required this.currencyCache,
  });

  /// Exchange Cache TTL (e.g. 1 hour)

  Future<void> cacheRates(List<ExchangeRateModel> rates) async {
    await rateCache.cacheExchangeRates(rates);
  }

  List<ExchangeRateModel> getCachedRates() {
    return rateCache.getCachedExchangeRates();
  }

  bool get hasRateCache => rateCache.hasCachedData();

  bool get isRateCacheValid => rateCache.isCacheValid();

  DateTime? get rateCacheLastUpdated => rateCache.getLastUpdated();

  /// Currency Cache TTL (e.g. 6 hours)

  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    await currencyCache.cacheCurrencies(currencies);
  }

  List<CurrencyModel> getCachedCurrencies() {
    return currencyCache.getCachedCurrencies();
  }

  bool get hasCurrencyCache => currencyCache.hasCachedData();

  bool get isCurrencyCacheValid => currencyCache.isCacheValid();

  DateTime? get currencyCacheLastUpdated => currencyCache.getLastUpdatedTime();

  /// Offline Rate Cache (bidirectional support)

  void cacheOfflineRate({
    required String from,
    required String to,
    required double rate,
  }) {
    offlineCache.cacheOfflineRate(
      fromCurrency: from,
      toCurrency: to,
      rate: rate,
    );
  }

  double? getOfflineRate(String from, String to) =>
      offlineCache.getOfflineRate(from, to);

  bool hasOfflineRate(String from, String to) =>
      offlineCache.hasOfflineRate(from, to);

  /// Clear all caches

  void clearAll() {
    rateCache.clearCache();
    offlineCache.clearCache();
    currencyCache.clearCache();
  }
}
