import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/data/models/user_model.dart';
import 'package:tradly_app/data/repositories/auth_repo.dart';

class AuthRepositoryMock extends Mock implements AuthRepository {}

class ProfileMocks {
  static final UserModel userModel = UserModel(
    userName: 'test_user',
    email: 'test@example.com',
    phoneNumber: '1234567890',
  );
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
