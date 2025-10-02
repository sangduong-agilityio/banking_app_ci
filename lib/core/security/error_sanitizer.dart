class ErrorSanitizer {
  static String sanitize(Object error) {
    final message = error.toString();
    if (message.toLowerCase().contains('exception') ||
        message.toLowerCase().contains('dio')) {
      return 'Something went wrong. Please try again.';
    }
    if (message.length > 120) {
      return message.substring(0, 120);
    }
    return message;
  }
}
