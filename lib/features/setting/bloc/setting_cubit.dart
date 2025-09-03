import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:banking_app/features/setting/bloc/setting_state.dart';
import 'package:banking_app/features/setting/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({required AuthRepository repo}) : super(const SettingState());

  final supabase = Supabase.instance.client;

  Future<void> fetchProfile() async {
    emit(state.copyWith(status: const SettingStatus.loading()));
    try {
      final currentUser = supabase.auth.currentUser;

      final response = await supabase
          .from('users')
          .select('username, email, profileImage')
          .eq('id', currentUser?.id ?? '')
          .maybeSingle();

      if (response == null) {
        throw Exception("No profile found for user ${currentUser?.id}");
      }

      final user = UserModel(
        username: response['username'] ?? '',
        email: response['email'] ?? currentUser?.email ?? '',
        phoneNumber: currentUser?.phone ?? '',
        profileImage: response['profileImage'] ?? '',
      );

      emit(state.copyWith(user: user, status: const SettingStatus.success()));
    } catch (e) {
      emit(
        state.copyWith(
          status: const SettingStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
