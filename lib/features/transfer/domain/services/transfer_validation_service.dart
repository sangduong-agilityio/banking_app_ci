import 'package:banking_app/features/home/data/models/account_model.dart';
import 'package:banking_app/features/home/data/models/card_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';

/// Service handling transfer validation
class TransferValidationService {
  const TransferValidationService();

  /// Validate if transfer can proceed to confirmation
  TransferValidationResult validateForConfirmation({
    AccountModel? selectedAccount,
    CardModel? selectedCard,
    BeneficiaryModel? selectedBeneficiary,
    double? amount,
    double? transactionLimit,
  }) {
    // Must have source (account or card)
    if (selectedAccount == null && selectedCard == null) {
      return const TransferValidationResult(
        isValid: false,
        errorMessage: 'Please select an account or card',
      );
    }

    // Must have beneficiary
    if (selectedBeneficiary == null) {
      return const TransferValidationResult(
        isValid: false,
        errorMessage: 'Please select a beneficiary',
      );
    }

    // Must have valid amount
    if (amount == null || amount <= 0) {
      return const TransferValidationResult(
        isValid: false,
        errorMessage: 'Please enter a valid amount',
      );
    }

    // Check transaction limit
    if (transactionLimit != null && amount > transactionLimit) {
      return TransferValidationResult(
        isValid: false,
        errorMessage:
            'Transfer amount exceeds the transaction limit of ${transactionLimit.toStringAsFixed(0)} VND',
      );
    }

    return const TransferValidationResult(isValid: true);
  }

  /// Validate OTP format
  bool validateOtp(String? otp) {
    return otp != null && otp.length == 6;
  }

  /// Validate if biometric authentication can be used
  bool canUseBiometric({
    required bool biometricAvailable,
    required bool biometricEnabled,
  }) {
    return biometricAvailable && biometricEnabled;
  }

  /// Validate if fee calculation is possible
  bool canCalculateFee({
    required bool hasSource,
    required bool hasBeneficiary,
    required bool hasValidAmount,
  }) {
    return hasSource && hasBeneficiary && hasValidAmount;
  }
}

/// Validation result
class TransferValidationResult {
  const TransferValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  final bool isValid;
  final String? errorMessage;
}
