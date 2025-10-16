import 'package:banking_app/features/search/data/models/currency_model.dart';
import 'package:banking_app/features/search/domain/entities/currency_rate_entity.dart';
import 'package:banking_app/objectbox.g.dart';

/// Handles caching and retrieval of currency list + rates.
class CurrencyCacheService {
  final Box<CurrencyEntity> _currenciesBox;
  final Box<CurrencyRateEntity> _ratesBox;
  static const _cacheValidityDuration = Duration(hours: 6);

  CurrencyCacheService(this._currenciesBox, this._ratesBox);

  /// Cache the list of currencies, replacing any existing cached data.

  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    try {
      _currenciesBox.removeAll();
      _currenciesBox.putMany(currencies.map(CurrencyEntity.fromModel).toList());
    } catch (e) {
      // Log error
    }
  }

  List<CurrencyModel> getCachedCurrencies() {
    try {
      final entities = _currenciesBox.getAll();
      if (entities.isEmpty) {
        return [];
      }
      if (!isCacheValid()) {
        return [];
      }
      return entities.map((e) => e.toModel()).toList();
    } catch (e) {
      // Log error
      return [];
    }
  }

  bool isCacheValid() {
    final entities = _currenciesBox.getAll();
    if (entities.isEmpty) return false;
    return DateTime.now().difference(entities.first.lastUpdated) <
        _cacheValidityDuration;
  }

  DateTime? getLastUpdatedTime() {
    final entities = _currenciesBox.getAll();
    return entities.isNotEmpty ? entities.first.lastUpdated : null;
  }

  bool hasCachedData() => _currenciesBox.count() > 0;

  /// Cache a specific currency exchange rate.
  Future<void> cacheRate(String from, String to, double rate) async {
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

  CurrencyRateEntity? getCachedRate(String from, String to) {
    final entity = _ratesBox
        .query(
          CurrencyRateEntity_.fromCurrency.equals(from) &
              CurrencyRateEntity_.toCurrency.equals(to),
        )
        .build()
        .findFirst();

    if (entity == null) {
      return null;
    }
    if (DateTime.now().difference(entity.lastUpdated) >
        _cacheValidityDuration) {
      return null;
    }
    return entity;
  }

  void clearCache() {
    _currenciesBox.removeAll();
    _ratesBox.removeAll();
  }
}
