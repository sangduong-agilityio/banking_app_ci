import 'package:intl/intl.dart';

class FormatterUtils {
  /// Format date as dd/MM/yyyy
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format month and year as "January 2025"
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

  /// Mask card number: "1234 **** **** 5678"
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 8) return cardNumber;

    final start = cardNumber.substring(0, 4);
    final end = cardNumber.substring(cardNumber.length - 4);
    const mask = '**** ****';

    return "$start $mask $end";
  }

  /// Format generic amount (without currency)
  static String formatAmount(double amount) {
    if (amount % 1 == 0) {
      return amount.toInt().toString();
    } else if (amount >= 1000) {
      return amount.toStringAsFixed(0);
    } else {
      return amount.toStringAsFixed(2);
    }
  }

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
    return "$currencyCode $formatted";
  }

  /// Format last updated time
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
