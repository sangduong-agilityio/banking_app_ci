import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_detail_state.freezed.dart';

class NotificationDetailState extends Equatable {
  const NotificationDetailState({
    this.notificationData = const {},
    this.status = const NotificationDetailStatus.initial(),
    this.errorMessage,
  });

  final Map<String, dynamic> notificationData;
  final NotificationDetailStatus status;
  final String? errorMessage;

  NotificationDetailState copyWith({
    Map<String, dynamic>? notificationData,
    NotificationDetailStatus? status,
    String? errorMessage,
  }) {
    return NotificationDetailState(
      notificationData: notificationData ?? this.notificationData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        notificationData,
        status,
        errorMessage,
      ];
}

@freezed
sealed class NotificationDetailStatus with _$NotificationDetailStatus {
  const factory NotificationDetailStatus.initial() =
      NotificationDetailStatusInitial;
  const factory NotificationDetailStatus.loading() =
      NotificationDetailStatusLoading;
  const factory NotificationDetailStatus.success() =
      NotificationDetailStatusSuccess;
  const factory NotificationDetailStatus.failure() =
      NotificationDetailStatusFailure;
}
