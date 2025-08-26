import 'package:banking_app/features/auth/services/auth_repository.dart';
import 'package:banking_app/features/setting/bloc/setting_state.dart';
import 'package:banking_app/features/setting/models/setting_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({required AuthRepository repo})
    : _repo = repo,
      super(const SettingState());

  final AuthRepository _repo;

  void fetchProfile() async {
    emit(state.copyWith(status: const SettingStatus.loading()));
    try {
      final currentUser = await _repo.getCurrentUser();
      final user = SettingModel(
        fullName: currentUser?.userMetadata?['username'] ?? '',
        email: currentUser?.email ?? '',
        phoneNumber: currentUser?.phone ?? '',
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
