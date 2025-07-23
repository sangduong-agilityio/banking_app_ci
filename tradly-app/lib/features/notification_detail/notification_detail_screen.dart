import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_cubit.dart';
import 'package:tradly_app/features/notification_detail/states/notification_detail_state.dart';
import 'package:tradly_app/utils/date_time.dart';
import 'package:tradly_app/widgets/layouts/app_bar.dart';
import 'package:tradly_app/widgets/layouts/scaffold.dart';
import 'package:tradly_app/widgets/not_found.dart';
import 'package:tradly_app/widgets/text.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, String> notificationData;

  const NotificationDetailScreen({
    super.key,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en', null);

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
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.notificationData != current.notificationData,
          builder: (context, state) {
            if (state.status is NotificationDetailStatusLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status is NotificationDetailStatusSuccess) {
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
                                    text: state.notificationData['title'] ?? '',
                                    color: context.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TAHeadlineSmallText(
                              text: state.notificationData['body'] ?? '',
                              color: context.colorScheme.onSecondary,
                            ),
                            ...[
                              const SizedBox(height: 12),
                              TATitleMediumText(
                                text:
                                    'Received: ${DateTimeUtil.dateTimeFormatWithDay(
                                  DateTime.parse(
                                      state.notificationData['received_at'] ??
                                          DateTime.now().toIso8601String()),
                                )}',
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
            } else if (state.status is NotificationDetailStatusFailure) {
              return NotFoundScreen();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
