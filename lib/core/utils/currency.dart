class CurrencyUtils {
  /// Convert from amount → to amount
  static double? convertFromTo(double? fromAmount, double rate) {
    if (fromAmount == null || fromAmount <= 0 || rate <= 0) return null;
    return double.parse((fromAmount * rate).toStringAsFixed(2));
  }

  /// Convert to amount → from amount
  static double? convertToFrom(double? toAmount, double rate) {
    if (toAmount == null || toAmount <= 0 || rate <= 0) return null;
    return double.parse((toAmount / rate).toStringAsFixed(2));
  }

  /// Swap currencies and amounts
  static ({
    String? fromCurrency,
    String? toCurrency,
    double? fromAmount,
    double? toAmount,
    double? exchangeRate,
  })
  swap({
    required String? fromCurrency,
    required String? toCurrency,
    required double? fromAmount,
    required double? toAmount,
    required double? exchangeRate,
  }) {
    final newRate = (exchangeRate != null && exchangeRate > 0)
        ? 1 / exchangeRate
        : null;

    return (
      fromCurrency: toCurrency,
      toCurrency: fromCurrency,
      fromAmount: toAmount,
      toAmount: fromAmount,
      exchangeRate: newRate,
    );
  }
}
