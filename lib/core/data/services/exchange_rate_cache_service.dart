import 'package:banking_app/features/search/data/models/exchange_rate_model.dart';
import 'package:banking_app/features/search/domain/entities/exchange_rate_entity.dart';
import 'package:objectbox/objectbox.dart';

/// Service responsible for caching a list of exchange rates.
///
/// Cached data is valid for 5 minutes.
class ExchangeRateCacheService {
  final Box<ExchangeRateEntity> _exchangeRateBox;
  static const Duration _cacheValidity = Duration(minutes: 5);

  ExchangeRateCacheService(this._exchangeRateBox);

  Future<void> cacheExchangeRates(List<ExchangeRateModel> rates) async {
    try {
      _exchangeRateBox.removeAll();
      final entities = rates.map(ExchangeRateEntity.fromModel).toList();
      _exchangeRateBox.putMany(entities);
    } catch (e) {
      // Log error
    }
  }

  List<ExchangeRateModel> getCachedExchangeRates() {
    try {
      return _exchangeRateBox.getAll().map((e) => e.toModel()).toList();
    } catch (e) {
      // Log error
      return [];
    }
  }

  bool isCacheValid() {
    final entities = _exchangeRateBox.getAll();
    if (entities.isEmpty) return false;
    return DateTime.now().difference(entities.first.lastUpdated) <
        _cacheValidity;
  }

  DateTime? getLastUpdated() {
    final entities = _exchangeRateBox.getAll();
    return entities.isNotEmpty ? entities.first.lastUpdated : null;
  }

  bool hasCachedData() => _exchangeRateBox.count() > 0;

  void clearCache() => _exchangeRateBox.removeAll();
}
