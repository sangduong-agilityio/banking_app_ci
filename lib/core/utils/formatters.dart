import 'package:intl/intl.dart';

/// A utility class for formatting dates, amounts, and other common data types.
class FormatterUtils {
  /// Formats a [DateTime] object as a string in `dd/MM/yyyy` format.
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Formats a [DateTime] object as a string in `Month YYYY` format.
  static String formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Masks a credit card number, showing only the first and last four digits.
  ///
  /// Example: `1234 **** **** 5678`
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 8) return cardNumber;

    final start = cardNumber.substring(0, 4);
    final end = cardNumber.substring(cardNumber.length - 4);
    const mask = '**** ****';

    return '$start $mask $end';
  }

  /// Formats a generic amount without a currency symbol.
  static String formatAmount(double amount) {
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    } else if (amount >= 1000) {
      return amount.toStringAsFixed(0);
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  /// Formats a balance with a currency code and locale-specific formatting.
  static String formatBalance(
    double amount, {
    String currencyCode = 'USD',
    String locale = 'en_US',
    bool showDecimalAlways = true,
  }) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: showDecimalAlways ? 2 : 0,
    );

    final formatted = format.format(amount);

    // Add currency code before the amount
    return '$currencyCode $formatted';
  }

  /// Formats a [DateTime] object as a relative time string (e.g., "Just now", "5 minutes ago").
  static String formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('dd/MM, HH:mm').format(lastUpdated);
    }
  }
}
