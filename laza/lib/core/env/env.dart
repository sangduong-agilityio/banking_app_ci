import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: './.env.dev')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_KEY')
  static const String supabaseKey = _Env.supabaseKey;

  @EnviedField(varName: 'SUPABASE_ENDPOINT')
  static const String endPoint = _Env.endPoint;
}
