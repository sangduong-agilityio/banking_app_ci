import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_cubit.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_state.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/text.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, String> notificationData;

  const NotificationDetailScreen({
    super.key,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationDetailCubit(Supabase.instance.client)
        ..fetchNotificationDetails(notificationData),
      child: TAScaffold(
        appBar: TAAppBar.checkout(
          title: 'Notification Details',
          onBackPressed: () => Navigator.pop(context),
          backgroundColor: context.colorScheme.primary,
        ),
        body: BlocBuilder<NotificationDetailCubit, NotificationDetailState>(
          builder: (context, state) {
            if (state is NotificationDetailLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NotificationDetailError) {
              return Center(child: Text(state.message));
            } else if (state is NotificationDetailLoaded) {
              final fullNotificationData = state.notificationData;
              final title = fullNotificationData['title'] ?? 'No Title';
              final body = fullNotificationData['body'] ?? 'No Content';
              final timestamp = fullNotificationData['timestamp'];

              DateTime? notificationTime;
              if (timestamp != null) {
                try {
                  final timestampInt = int.tryParse(timestamp.toString());
                  if (timestampInt != null) {
                    notificationTime =
                        DateTime.fromMillisecondsSinceEpoch(timestampInt);
                  }
                } catch (e) {
                  notificationTime = null;
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    color: context.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TAHeadlineLargeText(
                                    text: title,
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TAHeadlineSmallText(
                              text: body,
                              color: context.colorScheme.onSecondary,
                            ),
                            if (notificationTime != null) ...[
                              const SizedBox(height: 12),
                              TATitleMediumText(
                                text:
                                    'Received: ${_formatDateTime(notificationTime)}',
                                color: context.colorScheme.onSecondary,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
