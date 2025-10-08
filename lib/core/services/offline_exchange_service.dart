import 'package:banking_app/features/search/entities/currency_rate_entity.dart';
import 'package:banking_app/features/search/states/search_state.dart';
import 'package:banking_app/objectbox.g.dart';

/// A service that manages the offline caching of currency exchange rates using ObjectBox.
class OfflineExchangeService {
  final Box<CurrencyRateEntity> _ratesBox;

  /// Creates an [OfflineExchangeService] object.
  OfflineExchangeService(this._ratesBox);

  /// Caches a currency exchange rate.
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
      // Handle any errors during caching
    }
  }

  /// Retrieves a cached currency exchange rate.
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

  /// Gets the status of a cached currency exchange rate (fresh, stale, or no data).
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

  /// Gets the last updated timestamp of a cached currency exchange rate.
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

  /// Checks if there is any cached data.
  bool hasAnyCachedData() {
    return _ratesBox.getAll().isNotEmpty;
  }

  /// Clears all the cached data.
  void clearAllCache() {
    _ratesBox.removeAll();
  }

  /// Retrieves all the cached currency exchange rates.
  List<CurrencyRateEntity> getAllCachedRates() {
    return _ratesBox.getAll();
  }
}
