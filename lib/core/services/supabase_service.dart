import 'package:banking_app/core/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeServices() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
}
