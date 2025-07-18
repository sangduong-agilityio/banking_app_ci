import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String pickerValueFormat = 'MMM-dd-yyyy';

  static String formatDate(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
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
    return formatDate(date, pattern: pattern);
  }

  static String formatPickerValue(
    DateTime dateTime,
  ) {
    return DateFormat(pickerValueFormat).format(
      dateTime,
    );
  }
}
