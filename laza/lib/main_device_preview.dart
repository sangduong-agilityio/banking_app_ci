import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laza/core/env/env.dart';
import 'package:laza/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseKey,
  );
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true,
        builder: (context) => const LazaShopApp(),
      ),
    ),
  );
}
