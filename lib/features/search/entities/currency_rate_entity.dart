import 'package:objectbox/objectbox.dart';

/// Represents a currency exchange rate entity stored in the ObjectBox database.
///
/// This entity is used for offline caching of individual currency exchange rates.
@Entity()
class CurrencyRateEntity {
  /// The unique ID of the entity.
  @Id()
  int id;

  /// The currency code to convert from (e.g., \"USD\").
  String fromCurrency;

  /// The currency code to convert to (e.g., \"EUR\").
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
  ///
  /// This can be used to uniquely identify a currency pair.
  String get compositeKey => '${fromCurrency}_$toCurrency';
}
