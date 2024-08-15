import 'package:laza/data/models/user_model.dart';
import 'package:laza/data/repositories/auth_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepositoryImplement(Supabase.instance.client);

@Riverpod(keepAlive: true)
Future<Users?> userProfile(UserProfileRef ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.fetchUserProfile();
}
