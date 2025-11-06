import 'package:banking_app/core/data/services/biometric_service.dart';
import 'package:banking_app/features/auth/data/repositories/auth_repository.dart';
import 'package:banking_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class AuthBlocMock extends Mock implements AuthBloc {}

class BiometricServiceMock extends Mock implements BiometricService {}

class PrivateKeyMock extends Mock implements SharedPreferences {}

class AuthMocks {
  // Sign Up Form Events
  static final signUpForm = SignUpFormValidateChanged(
    isValidate: true,
    username: 'test_user',
    email: 'test@example.com',
    password: 'password123',
  );

  static final signUpFormEmpty = SignUpFormValidateChanged(
    isValidate: false,
  );

  static final signUpButtonPressed = SignUpButtonPressed();

  // Sign In Form Events
  static final signInForm = SignInFormValidateChanged(
    isValidate: true,
    email: 'test@example.com',
    password: 'password123',
  );

  static final signInFormEmpty = SignInFormValidateChanged(
    isValidate: false,
  );

  static final signInButtonPressed = SignInButtonPressed();

  // Biometric Events
  static final signInWithBiometric = SignInWithBiometric();

  static final checkBiometricAvailability = CheckBiometricAvailability();

  // Terms & Conditions Events
  static final signUpTermsChanged = SignUpTermsChanged(isAccepted: true);

  static final signUpTermsChangedFalse = SignUpTermsChanged(isAccepted: false);

  // User Events
  static final getCurrentUser = GetCurrentUser();

  // Supabase User & Session
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