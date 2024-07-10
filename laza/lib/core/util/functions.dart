class NumberFormatter {
  static String formatViewer(int number, [int decimal = 0]) {
    if (number < 1000) {
      return number.toString();
    }
    if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(decimal)}K';
    }
    if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(decimal)}M';
    }
    {
      return '${(number / 1000000000).toStringAsFixed(decimal)}B';
    }
  }
}
