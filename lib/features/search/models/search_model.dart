// lib/features/search/models/search_model.dart

class ExchangeRate {
  final String country;
  final String flag;
  final String code;
  final String buy;
  final String sell;

  ExchangeRate({
    required this.country,
    required this.flag,
    required this.code,
    required this.buy,
    required this.sell,
  });

  factory ExchangeRate.fromApi(
    String code,
    String country,
    String flag,
    double rate,
  ) {
    return ExchangeRate(
      country: country,
      flag: flag,
      code: code,
      buy: (rate * 0.98).toStringAsFixed(3),
      sell: (rate * 1.02).toStringAsFixed(3),
    );
  }
}

class ExchangeTransaction {
  final String fromCurrency;
  final String toCurrency;
  final double fromAmount;
  final double toAmount;
  final DateTime time;

  ExchangeTransaction({
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.time,
  });
}

class InterestRate {
  final String type;
  final String period;
  final String rate;

  InterestRate({required this.type, required this.period, required this.rate});

  factory InterestRate.fromMap(Map<String, dynamic> map) {
    return InterestRate(
      type: map['type'] as String,
      period: map['period'] as String,
      rate: map['rate'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'type': type, 'period': period, 'rate': rate};
  }
}

class SearchModel {
  final List<ExchangeRate>? exchangeRates;
  final List<ExchangeTransaction>? transactions;
  final List<InterestRate>? interestRates;

  SearchModel({this.exchangeRates, this.transactions, this.interestRates});
}
