import 'package:banking_app/features/search/entities/currency_rate_entity.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:banking_app/objectbox.g.dart';

class OfflineExchangeService {
  final Box<CurrencyRateEntity> _ratesBox;

  OfflineExchangeService(this._ratesBox);

  // Save a rate from the API into the cache
  void cacheRate(String fromCurrency, String toCurrency, double rate) {
    try {
      // Find existing rate
      final existingQuery = _ratesBox
          .query(
            CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
                CurrencyRateEntity_.toCurrency.equals(toCurrency),
          )
          .build();

      final existing = existingQuery.findFirst();
      existingQuery.close();

      if (existing != null) {
        // Update existing rate
        existing.rate = rate;
        existing.lastUpdated = DateTime.now();
        _ratesBox.put(existing);
      } else {
        // Create a new rate
        final entity = CurrencyRateEntity(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          rate: rate,
          lastUpdated: DateTime.now(),
        );
        _ratesBox.put(entity);
      }
    } catch (e) {
      print('Error caching rate: $e');
    }
  }

  // Get a rate from the cache
  double? getCachedRate(String fromCurrency, String toCurrency) {
    try {
      final query = _ratesBox
          .query(
            CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
                CurrencyRateEntity_.toCurrency.equals(toCurrency),
          )
          .build();

      final entity = query.findFirst();
      query.close();

      if (entity != null) {
        return entity.rate;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Check the freshness status of a rate
  ExchangeRateStatus getRateStatus(String fromCurrency, String toCurrency) {
    try {
      final query = _ratesBox
          .query(
            CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
                CurrencyRateEntity_.toCurrency.equals(toCurrency),
          )
          .build();

      final entity = query.findFirst();
      query.close();

      if (entity == null) {
        return ExchangeRateStatus.noData;
      }

      final difference = DateTime.now().difference(entity.lastUpdated);

      // Consider the rate stale if older than 1 hour
      if (difference.inHours >= 1) {
        return ExchangeRateStatus.stale;
      }

      return ExchangeRateStatus.fresh;
    } catch (e) {
      return ExchangeRateStatus.noData;
    }
  }

  // Get the last updated timestamp for a given rate
  DateTime? getLastUpdated(String fromCurrency, String toCurrency) {
    try {
      final query = _ratesBox
          .query(
            CurrencyRateEntity_.fromCurrency.equals(fromCurrency) &
                CurrencyRateEntity_.toCurrency.equals(toCurrency),
          )
          .build();

      final entity = query.findFirst();
      query.close();

      return entity?.lastUpdated;
    } catch (e) {
      return null;
    }
  }

  // Check if there is any cached data
  bool hasAnyCachedData() {
    return _ratesBox.getAll().isNotEmpty;
  }

  // Clear all cached data
  void clearAllCache() {
    _ratesBox.removeAll();
  }

  // Get all cached rates (useful for debugging)
  List<CurrencyRateEntity> getAllCachedRates() {
    return _ratesBox.getAll();
  }
}
