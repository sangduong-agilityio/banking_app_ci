import 'package:laza/core/l10n/l10n_generated/l10n.dart';

mixin InputValidationMixin {
  static String? validUserName(String username) {
    if (username.isEmpty) {
      return S.current.validatorUsernameRequired;
    } else if (username.length < 6) {
      return S.current.validatorUsernameCharacterMinimum;
    } else if (RegExpValidator.regExpUserName.hasMatch(username)) {
      return S.current.validatorUsernameWrongFormat;
    }

    return null;
  }

  static String? validEmail(String email) {
    if (email.isEmpty) {
      return S.current.validatorEmailRequired;
    } else if (!RegExpValidator.regExpEmail.hasMatch(email)) {
      return S.current.validatorEmailWrongFormat;
    }
    return null;
  }

  static String? validPassword(String password) {
    if (password.isEmpty) {
      return S.current.validatorPasswordRequired;
    } else if (password.length < 8) {
      return S.current.validatorPasswordCharacterMinimum;
    } else if (!RegExpValidator.regExpPassword.hasMatch(password)) {
      return S.current.validatorPasswordWrongFormat;
    }
    return null;
  }
}

class RegExpValidator {
  // Not allow special character
  static final RegExp regExpUserName = RegExp(r'[^\w.]');

  static final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  static final RegExp regExpPassword = RegExp('^(?=.*?[a-z])(?=.*?[A-Z]){8,}');
}
