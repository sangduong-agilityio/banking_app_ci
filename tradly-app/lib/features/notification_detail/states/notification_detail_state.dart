abstract class NotificationDetailState {}

class NotificationDetailLoading extends NotificationDetailState {}

class NotificationDetailLoaded extends NotificationDetailState {
  final Map<String, dynamic> notificationData;

  NotificationDetailLoaded(this.notificationData);
}

class NotificationDetailError extends NotificationDetailState {
  final String message;

  NotificationDetailError(this.message);
}
