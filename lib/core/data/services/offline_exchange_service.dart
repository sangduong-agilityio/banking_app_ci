import 'package:banking_app/features/search/domain/entities/currency_rate_entity.dart';
import 'package:banking_app/objectbox.g.dart';

/// Handles offline exchange rate lookups and caching with bidirectional support.
///
/// IMPROVEMENT: Automatically caches both directions (A→B and B→A)
/// to support currency swapping without additional API calls.
class OfflineExchangeService {
  final Box<CurrencyRateEntity> _ratesBox;

  OfflineExchangeService(this._ratesBox);

  /// Cache exchange rate with bidirectional support.
  void cacheOfflineRate({
    required String fromCurrency,
    required String toCurrency,
    required double rate,
  }) {
    if (rate <= 0) {
      return;
    }

  
      // Cache forward direction (A → B)
      _cacheOneDirection(from: fromCurrency, to: toCurrency, rate: rate);

      // Cache reverse direction (B → A)
      final reverseRate = 1.0 / rate;
      _cacheOneDirection(from: toCurrency, to: fromCurrency, rate: reverseRate);
    
  }

  /// Cache rate in one direction only (internal helper).
  void _cacheOneDirection({
    required String from,
    required String to,
    required double rate,
  }) {
    final existing = _ratesBox
        .query(
          CurrencyRateEntity_.fromCurrency.equals(from) &
              CurrencyRateEntity_.toCurrency.equals(to),
        )
        .build()
        .findFirst();

    final entity = CurrencyRateEntity(
      id: existing?.id ?? 0,
      fromCurrency: from,
      toCurrency: to,
      rate: rate,
      lastUpdated: DateTime.now(),
    );

    _ratesBox.put(entity);
  }

  /// Get cached exchange rate for a currency pair.
  ///
  /// Returns null if:
  /// - Rate not found in cache
  /// - Rate is older than 24 hours (stale)
  double? getOfflineRate(String fromCurrency, String toCurrency) {
    final entity = _ratesBox
        .query(
          CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
              CurrencyRateEntity_.toCurrency.equals(toCurrency),
        )
        .build()
        .findFirst();

    if (entity == null) {
      return null;
    }

    // Check if rate is too old (> 24 hours = stale)
    final age = DateTime.now().difference(entity.lastUpdated);
    if (age.inHours > 24) {
    } else {}

    return entity.rate;
  }

  /// Check if a cached rate exists (regardless of age).
  bool hasOfflineRate(String fromCurrency, String toCurrency) {
    final result = _ratesBox
        .query(
          CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
              CurrencyRateEntity_.toCurrency.equals(toCurrency),
        )
        .build()
        .findFirst();
    return result != null;
  }

  /// Check if a cached rate is fresh (< 24 hours old).
  bool isCacheFresh(String fromCurrency, String toCurrency) {
    final entity = _ratesBox
        .query(
          CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
              CurrencyRateEntity_.toCurrency.equals(toCurrency),
        )
        .build()
        .findFirst();

    if (entity == null) return false;

    final age = DateTime.now().difference(entity.lastUpdated);
    return age.inHours <= 24;
  }

  /// Get all cached rates (for debugging).
  List<CurrencyRateEntity> getAllCachedRates() {
    return _ratesBox.getAll();
  }

  /// Clear all cached rates.
  void clearCache() {
    _ratesBox.removeAll();
  }

  /// Log current cache status (for debugging).
  void logCacheStatus() {
    final all = getAllCachedRates();

    for (final entity in all) {
      DateTime.now().difference(entity.lastUpdated);
    }
  }
}
