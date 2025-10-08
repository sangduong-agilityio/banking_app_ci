/// A helper class that provides default currency conversion rates.
class DefaultRates {
  /// A map of base currency rates with USD as the reference currency.
  static final Map<String, double> baseRates = {
    'USD': 1.0,
    'VND': 24300,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 147.0,
    'CNY': 7.3,
    'KRW': 1330,
    'SGD': 1.34,
    'CAD': 1.36,
    'AUD': 1.52,
  };

  /// Returns the conversion rate between two currencies.
  static double? getRate(String from, String to) {
    final fromRate = baseRates[from];
    final toRate = baseRates[to];
    if (fromRate == null || toRate == null) return null;

    return toRate / fromRate;
  }
}
