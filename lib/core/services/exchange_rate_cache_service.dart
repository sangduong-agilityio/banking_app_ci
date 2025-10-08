import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/entities/exchange_rate_entity.dart';
import 'package:objectbox/objectbox.dart';

/// A service that manages the caching of exchange rates using ObjectBox.
class ExchangeRateCacheService {
  final Box<ExchangeRateEntity> _exchangeRateBox;

  /// Creates an [ExchangeRateCacheService] object.
  ExchangeRateCacheService(this._exchangeRateBox);

  /// Checks if the cache is still valid (less than 5 minutes old).
  bool isCacheValid() {
    final entities = _exchangeRateBox.getAll();
    if (entities.isEmpty) return false;

    final lastUpdated = entities.first.lastUpdated;
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inMinutes < 5;
  }

  /// Retrieves the cached exchange rates.
  List<ExchangeRateModel> getCachedRates() {
    final entities = _exchangeRateBox.getAll();
    return entities.map((entity) => entity.toModel()).toList();
  }

  /// Saves the exchange rates into the cache.
  void cacheRates(List<ExchangeRateModel> rates) {
    try {
      // Remove old cache
      _exchangeRateBox.removeAll();

      // Add new data with current timestamp
      final entities =
          rates.map((rate) => ExchangeRateEntity.fromModel(rate)).toList();
      _exchangeRateBox.putMany(entities);
    } catch (e) {
      // Handle any errors during caching
    }
  }

  /// Clears all the cached exchange rates.
  void clearCache() {
    _exchangeRateBox.removeAll();
  }

  /// Gets the last updated timestamp of the cache.
  DateTime? getLastUpdatedTime() {
    final entities = _exchangeRateBox.getAll();
    if (entities.isEmpty) return null;
    return entities.first.lastUpdated;
  }

  /// Checks if there is any cached data.
  bool hasCachedData() {
    return _exchangeRateBox.getAll().isNotEmpty;
  }
}
