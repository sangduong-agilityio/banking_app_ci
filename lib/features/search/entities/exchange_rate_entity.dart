import 'package:objectbox/objectbox.dart';
import 'package:banking_app/features/search/models/exchange_rate_model.dart';

@Entity()
class ExchangeRateEntity {
  @Id()
  int id;

  String country;
  String flag;
  String buy;
  String sell;

  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  ExchangeRateEntity({
    this.id = 0,
    required this.country,
    required this.flag,
    required this.buy,
    required this.sell,
    required this.lastUpdated,
  });

  // Convert to domain model
  ExchangeRateModel toModel() {
    return ExchangeRateModel(
      country: country,
      flag: flag,
      buy: buy,
      sell: sell,
    );
  }

  // Create from domain model
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
