import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String pickerValueFormat = 'MMM-dd-yyyy';

  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return _formatDate(date, pattern: pattern);
  }

  static DateTime? tryParse(String dateStr, {String pattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(pattern).parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static String? formatNullable(DateTime? date,
      {String pattern = 'yyyy-MM-dd'}) {
    if (date == null) return null;
    return _formatDate(date, pattern: pattern);
  }

  static String formatPickerValue(DateTime dateTime) {
    return _formatDate(dateTime, pattern: pickerValueFormat);
  }

  static String dateTimeFormat(DateTime date) {
    return _formatDate(date, pattern: "MMMM yyyy");
  }

  static String dateTimeFormatWithDay(DateTime date) {
    return _formatDate(date, pattern: "dd MMMM yyyy");
  }

  static String _formatDate(DateTime date, {required String pattern}) {
    return DateFormat(pattern).format(date);
  }
}
