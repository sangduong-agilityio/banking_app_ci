import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/configs/app_router.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final supabase = Supabase.instance.client;
  bool _initialized = false;

  // Add a global navigator key reference
  static GlobalKey<NavigatorState>? navigatorKey;

  bool get initialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    const initSettingAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    // Handle notification tap when app is running
    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      _navigateToNotificationDetail(payload);
    }
  }

  NotificationDetails notificationsDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_launcher',
        color: Color(0xFF33907C),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload, // Add payload parameter
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationsDetails(),
      payload: payload, // Pass payload to local notification
    );
  }

  Future<void> initializeFirebaseMessaging() async {
    // Handle notification when app is terminated and opened via notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(initialMessage);
    }

    // Handle notification when app is in background and opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);

    supabase.auth.onAuthStateChange.listen((event) async {
      if (event.event == AuthChangeEvent.signedIn) {
        await FirebaseMessaging.instance.getAPNSToken();
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _setFcmToken(fcmToken);
        }
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await _setFcmToken(fcmToken);
    });

    // Handle notification when app is in foreground
    FirebaseMessaging.onMessage.listen((payload) async {
      final notification = payload.notification;
      if (notification != null) {
        // Create payload with notification data
        final notificationPayload = _createNotificationPayload(payload);

        await showNotification(
          title: notification.title,
          body: notification.body,
          payload: notificationPayload,
        );
      }
    });
  }

  // Create payload string from RemoteMessage
  String _createNotificationPayload(RemoteMessage message) {
    final data = {
      'id': message.data['id'] ?? '',
      'type': message.data['type'] ?? 'general',
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
      'userId': message.data['user_id'] ?? '',
      'orderId': message.data['order_id'] ?? '',
      'productId': message.data['product_id'] ?? '',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    // Convert to JSON string
    return data.entries.map((e) => '${e.key}:${e.value}').join('|');
  }

  // Parse payload string back to map
  Map<String, String> _parseNotificationPayload(String payload) {
    final Map<String, String> data = {};
    final pairs = payload.split('|');

    for (final pair in pairs) {
      final keyValue = pair.split(':');
      if (keyValue.length == 2) {
        data[keyValue[0]] = keyValue[1];
      }
    }

    return data;
  }

  // Handle navigation from Firebase message
  void _handleNotificationNavigation(RemoteMessage message) {
    final payload = _createNotificationPayload(message);
    _navigateToNotificationDetail(payload);
  }

  // Navigate to notification detail screen
  void _navigateToNotificationDetail(String payload) {
    final data = _parseNotificationPayload(payload);

    // Use the global navigator key or the router
    if (navigatorKey?.currentContext != null) {
      navigatorKey!.currentContext!.pushNamed(
        TAPaths.notificationDetail.name,
        extra: data,
      );
    }
  }

  Future<void> _setFcmToken(String fcmToken) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      await supabase
          .from('profiles')
          .upsert({'id': userId, 'fcm_token': fcmToken});
    }
  }

  // Fetch the number of unread notifications
  Future<int> getUnreadNotificationCount() async {
    try {
      final response =
          await supabase.from('notifications').select('id').eq('read', false);

      return response.length;
    } catch (e) {
      return 0; // Return 0 if an error occurs
    }
  }
}
