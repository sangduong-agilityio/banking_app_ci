class DateTimeUtils {
  /// Format date as dd/MM/yyyy
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

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
}

class CardFormatter {
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 8) return cardNumber;

    final start = cardNumber.substring(0, 4);
    final end = cardNumber.substring(cardNumber.length - 4);

    const mask = '●●●● ●●●●';

    return "$start $mask $end";
  }
}
