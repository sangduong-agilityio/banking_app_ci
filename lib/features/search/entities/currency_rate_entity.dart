import 'package:objectbox/objectbox.dart';

@Entity()
class CurrencyRateEntity {
  @Id()
  int id;

  String fromCurrency;
  String toCurrency;
  double rate;

  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  CurrencyRateEntity({
    this.id = 0,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// Create from JSON
  String get compositeKey => '${fromCurrency}_$toCurrency';
}
