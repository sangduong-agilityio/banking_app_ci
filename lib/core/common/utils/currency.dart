/// A utility class for handling currency-related operations such as conversion, formatting, and validation.
class CurrencyUtils {
  /// Converts an amount from one currency to another using a given exchange rate.
  static double? convertFromTo(double? fromAmount, double rate) {
    if (fromAmount == null || fromAmount <= 0 || rate <= 0) return null;
    return double.parse((fromAmount * rate).toStringAsFixed(2));
  }

  /// Converts an amount from a target currency back to the original currency.
  static double? convertToFrom(double? toAmount, double rate) {
    if (toAmount == null || toAmount <= 0 || rate <= 0) return null;
    return double.parse((toAmount / rate).toStringAsFixed(2));
  }

  /// Swaps the from and to currencies and amounts.
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

  /// Converts a numeric amount to its word representation.
  static String convertAmountToWords(String value) {
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount == 0) return '';

    // Use intl_utils to convert number to words
    final words = _convertNumberToWords(amount.toInt());

    return '$words dollars';
  }

  static String _convertNumberToWords(int number) {
    const ones = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
    ];
    const teens = [
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];
    const scales = ['', 'thousand', 'million', 'billion', 'trillion'];

    if (number == 0) return 'zero';

    String convert(int num) {
      if (num == 0) {
        return '';
      } else if (num < 10) {
        return ones[num];
      } else if (num < 20) {
        return teens[num - 10];
      } else if (num < 100) {
        return tens[num ~/ 10] + (num % 10 != 0 ? ' ${ones[num % 10]}' : '');
      } else {
        return '${ones[num ~/ 100]} hundred${num % 100 != 0 ? ' ${convert(num % 100)}' : ''}';
      }
    }

    String result = '';
    int scaleIndex = 0;

    while (number > 0) {
      if (number % 1000 != 0) {
        result =
            convert(number % 1000) +
            (scaleIndex > 0 ? ' ${scales[scaleIndex]}' : '') +
            (result.isNotEmpty ? ' $result' : '');
      }
      number ~/= 1000;
      scaleIndex++;
    }

    return result.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Validates a given amount against the available balance and decimal precision.
  ///
  /// Returns `null` if the amount is valid, or an error message if it is invalid.
  static String? validateAmount({
    required double? amount,
    required double balance,
  }) {
    if (amount == null) return 'Amount cannot be empty';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount > balance) return 'Amount exceeds available balance';

    final parts = amount.toString().split('.');
    if (parts.length == 2 && parts[1].length > 2) {
      return 'Amount can have at most 2 decimal places';
    }

    return null;
  }

  /// Rounds an amount to two decimal places.
  static double roundTo2Decimal(double amount) {
    return double.parse(amount.toStringAsFixed(2));
  }
}
