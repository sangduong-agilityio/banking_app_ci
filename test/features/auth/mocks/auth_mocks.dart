import 'package:banking_app/core/services/biometric_service.dart';
import 'package:banking_app/features/auth/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/blocs/auth_bloc.dart';
import 'package:banking_app/features/auth/blocs/auth_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class AuthBlocMock extends Mock implements AuthBloc {}

class BiometricServiceMock extends Mock implements BiometricService {}

class PrivateKeyMock extends Mock implements SharedPreferences {}

class AuthMocks {
  static final signUpForm = SignUpFormValidateChangedEvt(
    isValidate: true,
    username: 'test_user',
    email: 'test@example.com',
    password: 'password123',
  );

  static final signInForm = SignInFormValidateChangedEvt(
    isValidate: true,
    email: 'test@example.com',
    password: 'password123',
  );

  static final signInFormEmpty = SignInFormValidateChangedEvt(
    isValidate: false,
  );

  static final signUpFormEmpty = SignUpFormValidateChangedEvt(
    isValidate: false,
  );

  static final signUpButtonPressed = SignUpButtonPressedEvt();

  static final signInButtonPressed = SignInButtonPressedEvt();

  static final User user = User(
    id: 'test_id',
    email: 'test@example.com',
    userMetadata: {'username': 'test_user'},
    aud: 'authenticated',
    createdAt: DateTime.now().toIso8601String(),
    appMetadata: {
      'provider': 'email',
      'providers': ['email'],
    },
  );

  static final Session session = Session(
    accessToken: 'test_access_token',
    tokenType: 'bearer',
    user: user,
  );

  static final AuthResponse authResponseSuccess = AuthResponse(
    user: user,
    session: session,
  );

  static final AuthResponse authResponseNoUser = AuthResponse();
}
