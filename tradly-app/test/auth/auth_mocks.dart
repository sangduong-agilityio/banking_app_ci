import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/auth/states/sign_in_bloc.dart';
import 'package:tradly_app/features/auth/states/sign_in_event.dart';
import 'package:tradly_app/features/auth/states/sign_up_bloc.dart';
import 'package:tradly_app/features/auth/states/sign_up_event.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class SignUpBlocMock extends Mock implements SignUpBloc {}

class SignInBlocMock extends Mock implements SignInBloc {}

class AuthMocks {
  static final signUpForm = SignUpFormValidateChangedEvt(
    isValidate: true,
    username: 'test_user',
    emailOrPhoneNumber: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
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
}
