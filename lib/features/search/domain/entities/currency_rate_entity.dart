import 'package:objectbox/objectbox.dart';
import 'package:banking_app/features/search/data/models/currency_model.dart';

/// Entity representing a cached exchange rate between two currencies.
@Entity()
class CurrencyRateEntity {
  @Id()
  int id;

  /// Source currency code (e.g., "USD")
  String fromCurrency;

  /// Target currency code (e.g., "EUR")
  String toCurrency;

  /// Latest known exchange rate.
  double rate;

  /// When this rate was last updated.
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  CurrencyRateEntity({
    this.id = 0,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// Returns composite key format like "USD_EUR".
  String get compositeKey => '${fromCurrency}_$toCurrency';
}

/// Entity representing a cached currency item.
@Entity()
class CurrencyEntity {
  @Id()
  int id;

  /// ISO currency code.
  String code;

  /// Human-readable currency name.
  String name;

  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  CurrencyEntity({
    this.id = 0,
    required this.code,
    required this.name,
    required this.lastUpdated,
  });

  CurrencyModel toModel() => CurrencyModel(code: code, name: name);

  static CurrencyEntity fromModel(CurrencyModel model) => CurrencyEntity(
    code: model.code,
    name: model.name,
    lastUpdated: DateTime.now(),
  );
}
