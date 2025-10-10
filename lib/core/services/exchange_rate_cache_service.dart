import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/entities/exchange_rate_entity.dart';
import 'package:objectbox/objectbox.dart';

/// A service that manages the short-term caching of a list of exchange rates.
///
/// This service uses ObjectBox to store the exchange rates and keeps them in a
/// cache that is valid for 5 minutes. This is used to quickly display the list
/// of exchange rates to the user without having to fetch them from the network
/// every time.
class ExchangeRateCacheService {
  final Box<ExchangeRateEntity> _exchangeRateBox;

  /// Creates an [ExchangeRateCacheService] object.
  ExchangeRateCacheService(this._exchangeRateBox);

  /// Checks if the cache is still valid (less than 5 minutes old).
  ///
  /// This method checks the timestamp of the first entity in the cache.
  /// It assumes that all entities in the cache have the same timestamp.
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
  ///
  /// This method first clears the existing cache and then saves the new rates
  /// with the current timestamp.
  void cacheRates(List<ExchangeRateModel> rates) {
    try {
      // Remove old cache
      _exchangeRateBox.removeAll();

      // Add new data with current timestamp
      final entities = rates
          .map((rate) => ExchangeRateEntity.fromModel(rate))
          .toList();
      _exchangeRateBox.putMany(entities);
    } catch (e) {
      rethrow;
    }
  }

  /// Clears all the cached exchange rates.
  void clearCache() {
    _exchangeRateBox.removeAll();
  }

  /// Gets the last updated timestamp of the cache.
  ///
  /// This method returns the timestamp of the first entity in the cache.
  /// It assumes that all entities in the cache have the same timestamp.
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
