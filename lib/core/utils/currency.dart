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

  /// Convert amount to words (simplified)
  static String convertAmountToWords(String value) {
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return '';

    if (amount == 1000) return "One thousand dollar";
    if (amount == 2000) return "Two thousand dollar";
    if (amount == 5000) return "Five thousand dollar";
    if (amount == 10000) return "Ten thousand dollar";
    if (amount == 20000) return "Twenty thousand dollar";
    if (amount == 50000) return "Fifty thousand dollar";
    if (amount == 100000) return "One hundred thousand dollar";
    if (amount == 200000) return "Two hundred thousand dollar";
    if (amount == 500000) return "Five hundred thousand dollar";
    if (amount == 1000000) return "One million dollar";

    return "$amount dollars";
  }

  /// Validate amount against balance and decimal precision
  /// Returns null if valid, or error message if invalid
  static String? validateAmount({
    required double? amount,
    required double balance,
  }) {
    if (amount == null) return "Amount cannot be empty";
    if (amount <= 0) return "Amount must be greater than 0";
    if (amount > balance) return "Amount exceeds available balance";

    final parts = amount.toString().split('.');
    if (parts.length == 2 && parts[1].length > 2) {
      return "Amount can have at most 2 decimal places";
    }

    return null;
  }

  /// Round amount to 2 decimal points
  static double roundTo2Decimal(double amount) {
    return double.parse(amount.toStringAsFixed(2));
  }
}
