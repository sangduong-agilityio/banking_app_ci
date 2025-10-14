class InsufficientFundsException implements Exception {
  final String message;
  const InsufficientFundsException([
    this.message = "Insufficient funds for the transfer.",
  ]);

  @override
  String toString() => "InsufficientFundsException: $message";
}

class InvalidTransferSourceException implements Exception {
  final String message;
  const InvalidTransferSourceException([
    this.message = "Invalid transfer source or amount.",
  ]);

  @override
  String toString() => "InvalidTransferSourceException: $message";
}

class InvalidOtpException implements Exception {
  final String message;
  const InvalidOtpException([this.message = "Invalid or expired OTP."]);

  @override
  String toString() => "InvalidOtpException: $message";
}

class UserNotLoggedInException implements Exception {
  final String message;
  const UserNotLoggedInException([this.message = "User not logged in."]);

  @override
  String toString() => "UserNotLoggedInException: $message";
}

class OtpSendFailedException implements Exception {
  final String message;
  const OtpSendFailedException([this.message = "Failed to send OTP."]);

  @override
  String toString() => "OtpSendFailedException: $message";
}
