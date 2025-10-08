import 'package:banking_app/core/env/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes the Supabase client with the URL and anonymous key from the environment variables.
Future<void> initializeServices() async {
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseKey);
}
