import 'package:objectbox/objectbox.dart';
import 'package:banking_app/features/search/models/currency_model.dart';

/// Represents an individual currency exchange rate entity.
///
/// This entity is used for offline caching of individual currency exchange rates.
@Entity()
class CurrencyRateEntity {
  /// The unique ID of the entity.
  @Id()
  int id;

  /// The currency code to convert from (e.g., "USD").
  String fromCurrency;

  /// The currency code to convert to (e.g., "EUR").
  String toCurrency;

  /// The exchange rate between the two currencies.
  double rate;

  /// The timestamp when the exchange rate was last updated.
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  /// Creates a [CurrencyRateEntity] object.
  CurrencyRateEntity({
    this.id = 0,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// A composite key created from the fromCurrency and toCurrency codes.
  String get compositeKey => '${fromCurrency}_$toCurrency';
}

/// Represents a currency entity stored in the ObjectBox database.
///
/// This entity is used for caching the list of available currencies.
@Entity()
class CurrencyEntity {
  /// The unique ID of the entity.
  @Id()
  int id;

  /// The currency code (e.g., "USD", "EUR").
  String code;

  /// The currency name (e.g., "United States Dollar").
  String name;

  /// The timestamp when this currency list was cached.
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  /// Creates a [CurrencyEntity] object.
  CurrencyEntity({
    this.id = 0,
    required this.code,
    required this.name,
    required this.lastUpdated,
  });

  /// Converts this [CurrencyEntity] to a [CurrencyModel].
  CurrencyModel toModel() {
    return CurrencyModel(code: code, name: name);
  }

  /// Creates a [CurrencyEntity] from a [CurrencyModel].
  static CurrencyEntity fromModel(CurrencyModel model) {
    return CurrencyEntity(
      code: model.code,
      name: model.name,
      lastUpdated: DateTime.now(),
    );
  }
}
