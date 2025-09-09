class DefaultRates {
  static final Map<String, Map<String, double>> rates = {
    'USD': {
      'VND': 24300,
      'EUR': 0.85,
      'GBP': 0.75,
      'JPY': 149,
      'CNY': 7.3,
      'KRW': 1330,
    },
    'VND': {'USD': 0.000041, 'EUR': 0.000035, 'GBP': 0.000031},
    'EUR': {'USD': 1.18, 'VND': 28600, 'GBP': 0.88},
  };

  static double? getRate(String from, String to) {
    return rates[from]?[to];
  }
}
