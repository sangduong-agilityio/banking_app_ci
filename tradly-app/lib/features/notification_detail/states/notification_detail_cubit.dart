import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_state.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  final SupabaseClient supabase;

  NotificationDetailCubit(this.supabase)
      : super(const NotificationDetailState());

  Future<void> fetchNotificationDetails(
      Map<String, String> notificationData) async {
    emit(
      state.copyWith(
        status: NotificationDetailStatus.loading(),
      ),
    );
    try {
      final notificationId = notificationData['id'];
      if (notificationId != null && notificationId.isNotEmpty) {
        final response = await supabase
            .from('notifications')
            .select('*')
            .eq('id', notificationId)
            .single();
        emit(
          state.copyWith(
            notificationData: Map<String, dynamic>.from(response),
            status: NotificationDetailStatus.success(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            notificationData: Map<String, dynamic>.from(notificationData),
            status: NotificationDetailStatus.success(),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
            status: NotificationDetailStatus.failure(),
            errorMessage: e.toString()),
      );
    }
  }
}
