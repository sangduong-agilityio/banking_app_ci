/// A class that contains security configuration constants for the application.
class SecurityConfig {
  // Input validation limits
  static const int maxEmailLength = 254;
  static const int maxPasswordLength = 128;
  static const int minPasswordLength = 8;
  static const int maxInputLength = 1000;
  static const int maxAmountPrecision = 2;

  // Transfer limits
  static const double minTransferAmount = 0.01;
  static const double maxTransferAmount = 999999.99;
  static const double suspiciousAmountThreshold = 10000.0;

  // Account number validation
  static const int minAccountNumberLength = 10;
  static const int maxAccountNumberLength = 16;

  // OTP configuration
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 10;
  static const int maxOtpAttempts = 3;

  // PIN configuration
  static const List<int> allowedPinLengths = [4, 6];

  // Session security
  static const int maxSessionDurationHours = 24;
  static const int sessionWarningMinutes = 5;

  // Rate limiting
  static const int maxLoginAttemptsPerHour = 5;
  static const int maxTransferAttemptsPerDay = 50;
  static const int maxApiRequestsPerMinute = 100;

  // Sensitive data patterns for sanitization
  static const List<String> sensitiveKeywords = [
    'password',
    'pin',
    'otp',
    'token',
    'key',
    'secret',
    'credential',
    'auth',
    'session',
    'cookie',
    'card_number',
    'cvv',
    'ssn',
    'account_number',
  ];

  // SQL injection patterns
  static const List<String> sqlInjectionPatterns = [
    'select',
    'insert',
    'update',
    'delete',
    'drop',
    'union',
    'exec',
    'declare',
    'alter',
    'create',
  ];

  // XSS patterns
  static const List<String> xssPatterns = [
    '<script',
    'javascript:',
    'onload=',
    'onerror=',
    'onclick=',
    'onmouseover=',
    'onfocus=',
    'onblur=',
  ];

  // Suspicious email domains
  static const List<String> suspiciousEmailDomains = [
    'tempmail',
    '10minutemail',
    'guerrillamail',
    'mailinator',
    'throwaway',
    'temp-mail',
    'disposable',
  ];

  // Common weak passwords
  static const List<String> commonWeakPasswords = [
    'password',
    '123456',
    'qwerty',
    'abc123',
    'password123',
    'admin',
    'letmein',
    'welcome',
    '12345678',
    'iloveyou',
  ];

  // Keyboard patterns
  static const List<String> keyboardPatterns = [
    'qwertyuiop',
    'asdfghjkl',
    'zxcvbnm',
    '1234567890',
    'qwerty',
    'asdfgh',
    'zxcvbn',
  ];

  // Common weak PINs
  static const List<String> commonWeakPins = [
    '0000',
    '1111',
    '2222',
    '3333',
    '4444',
    '5555',
    '6666',
    '7777',
    '8888',
    '9999',
    '1234',
    '4321',
    '1212',
    '1010',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
  ];

  // Security headers
  static const Map<String, String> securityHeaders = {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
    'Referrer-Policy': 'strict-origin-when-cross-origin',
  };

  // Audit log retention
  static const int auditLogRetentionDays = 365;
  static const int criticalLogRetentionDays = 2555; // 7 years for compliance

  // Biometric security
  static const int maxBiometricAttempts = 3;
  static const int biometricLockoutMinutes = 15;

  // Device security
  static const int maxDevicesPerUser = 5;
  static const int deviceTrustDays = 30;

  /// Checks if the application is running in production mode.
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  /// Checks if the application is running in debug mode.
  static bool get isDebugMode => !isProduction;

  /// The timeout duration for network requests.
  static Duration get networkTimeout => const Duration(seconds: 30);

  /// The session timeout duration.
  static Duration get sessionTimeout =>
      const Duration(hours: maxSessionDurationHours);

  /// The OTP expiry duration.
  static Duration get otpExpiry => const Duration(minutes: otpExpiryMinutes);

  /// The maximum file upload size in bytes (5MB).
  static int get maxFileUploadSize => 5 * 1024 * 1024; // 5MB

  /// The allowed file types for uploads.
  static List<String> get allowedFileTypes => ['jpg', 'jpeg', 'png', 'pdf'];

  /// The severity thresholds for security events.
  static const Map<String, int> severityThresholds = {
    'failed_login_attempts': 3,
    'invalid_otp_attempts': 3,
    'suspicious_amount_threshold': 10000,
    'max_daily_transfers': 50,
    'max_transfer_amount': 999999,
  };
}

/// A class that represents the result of a security validation.
class SecurityValidationResult {
  /// Whether the validation was successful.
  final bool isValid;

  /// The error message if the validation failed.
  final String? errorMessage;

  /// Additional metadata about the validation.
  final Map<String, dynamic>? metadata;

  /// Creates a [SecurityValidationResult] object for a successful validation.
  const SecurityValidationResult.valid()
      : isValid = true,
        errorMessage = null,
        metadata = null;

  /// Creates a [SecurityValidationResult] object for a failed validation.
  const SecurityValidationResult.invalid(this.errorMessage, {this.metadata})
      : isValid = false;

  /// Whether the validation failed.
  bool get isInvalid => !isValid;
}

/// An enum that defines the different security risk levels.
enum SecurityRiskLevel { low, medium, high, critical }

/// An enum that defines the different security event categories.
enum SecurityEventCategory {
  authentication,
  authorization,
  dataAccess,
  transaction,
  configuration,
  suspicious,
  biometric,
  network,
  input,
}
