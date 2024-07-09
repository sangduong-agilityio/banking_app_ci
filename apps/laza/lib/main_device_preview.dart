import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laza/main.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const LazaShopApp(),
    ),
  );
}
