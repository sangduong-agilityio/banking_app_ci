import 'package:banking_app/features/search/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/entities/exchange_rate_entity.dart';
import 'package:objectbox/objectbox.dart';

class ExchangeRateCacheService {
  final Box<ExchangeRateEntity> _exchangeRateBox;

  ExchangeRateCacheService(this._exchangeRateBox);

  // Check if the cache is still valid (less than 5 minutes old)
  bool isCacheValid() {
    final entities = _exchangeRateBox.getAll();
    if (entities.isEmpty) return false;

    final lastUpdated = entities.first.lastUpdated;
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    return difference.inMinutes < 5;
  }

  // Retrieve data from cache
  List<ExchangeRateModel> getCachedRates() {
    final entities = _exchangeRateBox.getAll();
    return entities.map((entity) => entity.toModel()).toList();
  }

  // Save data into cache
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
      // Handle any errors during caching
    }
  }

  // Clear all cache
  void clearCache() {
    _exchangeRateBox.removeAll();
  }

  // Get the last updated timestamp
  DateTime? getLastUpdatedTime() {
    final entities = _exchangeRateBox.getAll();
    if (entities.isEmpty) return null;
    return entities.first.lastUpdated;
  }

  // Check if there is any cached data
  bool hasCachedData() {
    return _exchangeRateBox.getAll().isNotEmpty;
  }
}
