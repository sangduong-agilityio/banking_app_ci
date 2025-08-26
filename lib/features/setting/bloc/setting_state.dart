import 'package:banking_app/features/setting/models/setting_model.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

final class SettingState extends Equatable {
  const SettingState({
    this.user,
    this.status = const SettingStatus.initial(),
    this.errorMessage,
  });

  final SettingModel? user;
  final SettingStatus status;
  final String? errorMessage;

  SettingState copyWith({
    SettingModel? user,
    SettingStatus? status,
    String? errorMessage,
  }) {
    return SettingState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [user, status, errorMessage];
}

@freezed
sealed class SettingStatus with _$SettingStatus {
  const factory SettingStatus.initial() = SettingStatusInitial;
  const factory SettingStatus.loading() = SettingStatusLoading;
  const factory SettingStatus.success() = SettingStatusSuccess;
  const factory SettingStatus.failure() = SettingStatusFailure;
}
