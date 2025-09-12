import 'package:banking_app/core/resources/l10n_generated/l10n.dart';

mixin InputValidationMixin {
  static String? validUserName(String firstName) {
    if (firstName.isEmpty) {
      return S.current.validatorNameRequired;
    }
    return null;
  }

  static String? validEmail(String input) {
    if (input.isEmpty) {
      return S.current.validatorEmailRequired;
    } else if (!RegExpValidator.regExpEmail.hasMatch(input)) {
      return S.current.validatorEmailWrongFormat;
    }
    return null;
  }

  static String? validPassword(String password) {
    if (password.isEmpty) {
      return S.current.validatorPasswordRequired;
    } else if (password.length < 8) {
      return S.current.validatorPasswordCharacterMinimum;
    }
    return null;
  }

  static String? validConfirmPassword({required String confirmPassword}) {
    if (confirmPassword.isEmpty) {
      return S.current.validatorConfirmPasswordRequired;
    }
    return null;
  }

  static String? validConfirmation({
    required String needConfirm,
    required String confirm,
  }) {
    if (needConfirm.length < 8) {
      return S.current.validatorPasswordCharacterMinimum;
    } else if (needConfirm != confirm) {
      return S.current.validatorConfirmedPasswordNotMatch;
    }
    return null;
  }

  static String? validReEnterPassword({
    required String password,
    required String reEnterPassword,
  }) {
    if (reEnterPassword.isEmpty) {
      return S.current.validatorConfirmPasswordRequired;
    } else if (password != reEnterPassword) {
      return S.current.validatorConfirmedPasswordNotMatch;
    }
    return null;
  }

  static String? validateInput<T>(T? value, String fieldName) {
    if (value == null || value.toString().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? validateOption({
    required String? value,
    required String label,
    bool Function(String)? isValidOption,
  }) {
    final baseValidation = validateInput(value, label);
    if (baseValidation != null) return baseValidation;

    if (isValidOption != null && value != null && !isValidOption(value)) {
      return 'Invalid option selected';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Card number is required";
    }

    final cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length < 10) {
      return "Card number must be 10 digits";
    }

    return null;
  }

  static String? validateAmount(String? value, double? availableBalance) {
    if (value == null || value.isEmpty) {
      return "Amount is required";
    }

    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return "Please enter a valid amount";
    }

    if (amount < 0.01) {
      return "Minimum amount is \$0.01";
    }

    if (availableBalance != null && amount > availableBalance) {
      return "Insufficient balance";
    }

    return null;
  }
}

class RegExpValidator {
  static final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp regExpPassword = RegExp('^(?=.*?[a-z])(?=.*?[A-Z]){8,}');

  static final RegExp regExpPhone = RegExp(r'^\+?[0-9]{7,15}$');
}
