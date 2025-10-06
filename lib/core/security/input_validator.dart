import 'package:banking_app/core/resources/l10n_generated/l10n.dart';

/// A secure validator with stricter checks than [InputValidationMixin].
/// Used for sensitive inputs like account number, amount, PIN, password, etc.
/// It includes checks for common weak patterns and suspicious inputs.
class SecureInputValidator {
  /// Validate banking account number (10–16 digits)
  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length < 10 || cleaned.length > 16) {
      return 'Account number must be 10–16 digits';
    }
    return null;
  }

  /// Validate transfer amount with security + suspicious checks
  static String? validateTransferAmount(String? value, {double? maxBalance}) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) return 'Please enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount < 0.01) return 'Minimum transfer amount is \$0.01';
    if (amount > 999999.99) return 'Maximum transfer amount is \$999,999.99';

    if (maxBalance != null && amount > maxBalance) {
      return 'Insufficient balance';
    }

    if (_isSuspiciousAmount(amount)) {
      return 'Please verify the amount';
    }
    return null;
  }

  /// Check suspicious amount patterns
  static bool _isSuspiciousAmount(double amount) {
    if (amount >= 10000 && amount % 1000 == 0) return true;
    final amountStr = amount.toStringAsFixed(2).replaceAll('.', '');
    final uniqueDigits = amountStr.split('').toSet().length;
    return amountStr.length > 4 && uniqueDigits <= 2;
  }

  /// Validate bill code (6–20 alphanumeric characters)

  static String? validateBillCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bill code is required';
    }
    final cleaned = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z0-9]{6,20}$').hasMatch(cleaned)) {
      return 'Bill code must be 6–20 alphanumeric characters';
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.transferEnterOtpCodeTitle;
    }
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 6) return 'OTP must be 6 digits';
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (!RegExp(r'^\+?[1-9]\d{7,14}$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate email with security + suspicious checks
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final email = value.trim().toLowerCase();
    if (email.length > 254) return 'Email is too long';

    final sanitized = sanitizeInput(email);
    if (sanitized != email) return 'Email contains invalid characters';

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(sanitized)) return 'Invalid email format';
    if (_isSuspiciousEmail(sanitized)) return 'Please use a valid email';
    return null;
  }

  static bool _isSuspiciousEmail(String email) {
    if (email.contains('..')) return true;
    const suspiciousDomains = [
      'tempmail',
      '10minutemail',
      'guerrillamail',
      'mailinator',
      'throwaway',
    ];
    return suspiciousDomains.any((d) => email.contains(d));
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (value.length > 128) return 'Password is too long';

    if (_isWeakPassword(value)) {
      return 'Password too weak. Use letters, numbers & symbols';
    }
    if (_containsSuspiciousPatterns(value)) {
      return 'Password contains invalid characters';
    }
    return null;
  }

  static bool _isWeakPassword(String password) {
    const common = [
      'password',
      '123456',
      'qwerty',
      'abc123',
      'admin',
      'letmein',
      'welcome',
    ];
    final lower = password.toLowerCase();
    if (common.any(lower.contains)) return true;

    const patterns = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm', '1234567890'];
    if (patterns.any(lower.contains)) return true;

    int complexity = 0;
    if (RegExp(r'[a-z]').hasMatch(password)) complexity++;
    if (RegExp(r'[A-Z]').hasMatch(password)) complexity++;
    if (RegExp(r'[0-9]').hasMatch(password)) complexity++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) complexity++;
    return complexity < 3;
  }

  static String? validatePIN(String? value) {
    if (value == null || value.trim().isEmpty) return 'PIN is required';
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 4 && cleaned.length != 6) {
      return 'PIN must be 4 or 6 digits';
    }
    if (_isWeakPIN(cleaned)) return 'Please choose a more secure PIN';
    return null;
  }

  static bool _isWeakPIN(String pin) {
    if (['1234', '4321', '123456', '654321'].contains(pin)) return true;
    if (RegExp(r'^(\d)\1+$').hasMatch(pin)) return true;
    const commonPins = ['0000', '1111', '2222', '1212', '1010'];
    return commonPins.contains(pin);
  }

  /// Sanitize input by removing dangerous characters and patterns

  static String sanitizeInput(String input) {
    String result = input;

    // Remove dangerous characters
    result = result.replaceAll('<', '');
    result = result.replaceAll('>', '');
    result = result.replaceAll('"', '');
    result = result.replaceAll("'", '');
    result = result.replaceAll('&', '');
    result = result.replaceAll(';', '');
    result = result.replaceAll('(', '');
    result = result.replaceAll(')', '');
    result = result.replaceAll('{', '');
    result = result.replaceAll('}', '');
    result = result.replaceAll('[', '');
    result = result.replaceAll(']', '');
    result = result.replaceAll('\\', '');
    result = result.replaceAll('|', '');
    result = result.replaceAll('`', '');
    result = result.replaceAll('~', '');

    // Remove script-related keywords
    result = result.replaceAll(RegExp(r'script', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'javascript', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'vbscript', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'onload', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'onerror', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'onclick', caseSensitive: false), '');

    return result.trim();
  }

  static String? validateSecureInput(
    String? value, {
    required String fieldName,
    int minLength = 1,
    int maxLength = 255,
    bool allowSpecialChars = false,
    RegExp? customPattern,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    if (trimmed.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    final sanitized = allowSpecialChars ? trimmed : sanitizeInput(trimmed);
    if (sanitized != trimmed) {
      return '$fieldName contains invalid characters';
    }

    if (customPattern != null && !customPattern.hasMatch(sanitized)) {
      return '$fieldName format is invalid';
    }

    if (_containsSuspiciousPatterns(sanitized)) {
      return '$fieldName contains invalid content';
    }

    return null;
  }

  /// Check for suspicious patterns like SQL keywords or XSS vectors

  static bool _containsSuspiciousPatterns(String input) {
    final lower = input.toLowerCase();
    const sqlPatterns = [
      'select',
      'insert',
      'update',
      'delete',
      'drop',
      'union',
      'exec',
      'declare',
    ];
    if (sqlPatterns.any(lower.contains)) return true;

    return lower.contains('<script') ||
        lower.contains('javascript:') ||
        lower.contains('onload=') ||
        lower.contains('onerror=');
  }
}
