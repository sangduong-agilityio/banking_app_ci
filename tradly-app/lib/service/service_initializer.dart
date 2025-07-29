import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradly_app/env/env.dart';
import 'package:tradly_app/firebase_options.dart';
import 'package:tradly_app/service/notification_service.dart';
import 'package:tradly_app/configs/app_router.dart';

Future<void> initializeServices() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseKey,
  );
  NotificationService.navigatorKey = TARouter.rootNavigatorKey;
  await NotificationService().initializeAllNotifications();
}
