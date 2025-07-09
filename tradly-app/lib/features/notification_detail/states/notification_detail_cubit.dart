import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_state.dart';

class NotificationDetailCubit extends Cubit<NotificationDetailState> {
  final SupabaseClient supabase;

  NotificationDetailCubit(this.supabase) : super(NotificationDetailLoading());

  Future<void> fetchNotificationDetails(
      Map<String, String> notificationData) async {
    try {
      final notificationId = notificationData['id'];
      if (notificationId != null && notificationId.isNotEmpty) {
        final response = await supabase
            .from('notifications')
            .select('*')
            .eq('id', notificationId)
            .single();
        emit(
          NotificationDetailLoaded(response),
        );
      } else {
        emit(
          NotificationDetailLoaded(
            Map<String, dynamic>.from(notificationData),
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationDetailError('Failed to load notification details'),
      );
    }
  }
}
