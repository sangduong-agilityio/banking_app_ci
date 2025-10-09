import 'package:objectbox/objectbox.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';

/// Represents an exchange rate entity stored in the ObjectBox database.
///
/// This entity is used for short-term caching of the list of exchange rates.
@Entity()
class ExchangeRateEntity {
  /// The unique ID of the entity.
  @Id()
  int id;

  /// The country name associated with the currency.
  String country;

  /// The URL or asset path for the country's flag image.
  String flag;

  /// The buying price of the currency.
  String buy;

  /// The selling price of the currency.
  String sell;

  /// The timestamp when the exchange rate was last updated.
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  /// Creates an [ExchangeRateEntity] object.
  ExchangeRateEntity({
    this.id = 0,
    required this.country,
    required this.flag,
    required this.buy,
    required this.sell,
    required this.lastUpdated,
  });

  /// Converts this [ExchangeRateEntity] to an [ExchangeRateModel].
  ExchangeRateModel toModel() {
    return ExchangeRateModel(
      country: country,
      flag: flag,
      buy: buy,
      sell: sell,
    );
  }

  /// Creates an [ExchangeRateEntity] from an [ExchangeRateModel].
  ///
  /// The [lastUpdated] timestamp is set to the current time.
  static ExchangeRateEntity fromModel(ExchangeRateModel model) {
    return ExchangeRateEntity(
      country: model.country,
      flag: model.flag,
      buy: model.buy,
      sell: model.sell,
      lastUpdated: DateTime.now(),
    );
  }
}
