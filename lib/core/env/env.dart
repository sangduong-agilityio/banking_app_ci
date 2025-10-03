import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: './.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_KEY', obfuscate: true)
  static String supabaseKey = _Env.supabaseKey;

  @EnviedField(varName: 'SUPABASE_ENDPOINT', obfuscate: true)
  static String endPoint = _Env.endPoint;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static String sentryDsn = _Env.sentryDsn;

  @EnviedField(varName: 'SENTRY_ENV', obfuscate: true)
  static String sentryEnv = _Env.sentryEnv;
}
