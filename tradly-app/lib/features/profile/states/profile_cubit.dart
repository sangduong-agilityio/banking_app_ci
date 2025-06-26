import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradly_app/features/auth/models/user_model.dart';
import 'package:tradly_app/features/auth/repositories/auth_repo.dart';
import 'package:tradly_app/features/profile/states/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required AuthRepository repo})
      : _repo = repo,
        super(const ProfileState());

  final AuthRepository _repo;

  void fetchProfile() async {
    emit(
      state.copyWith(
        status: const ProfileStatus.loading(),
      ),
    );
    try {
      final currentUser = await _repo.getCurrentUser();
      final user = UserModel(
        userName: currentUser?.userMetadata?['username'] ?? '',
        email: currentUser?.email ?? '',
        phoneNumber: currentUser?.phone ?? '',
      );
      emit(
        state.copyWith(
          user: user,
          status: const ProfileStatus.success(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: const ProfileStatus.failure(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
