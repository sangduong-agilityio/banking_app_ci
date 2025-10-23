import 'app/env/env.dart' as generated;

class Config {
  static String get aguiBaseUrl => generated.Env.aguiBaseUrl;
  static String? get aguiApiKey => generated.Env.aguiApiKey;

  static Future<void> load() async {}
}