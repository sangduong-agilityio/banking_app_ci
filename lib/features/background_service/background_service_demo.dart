import 'package:flutter/material.dart';
import 'package:banking_app/services/background_service.dart';

class BackgroundServiceDemo extends StatefulWidget {
  const BackgroundServiceDemo({super.key});

  @override
  State<BackgroundServiceDemo> createState() => _BackgroundServiceDemoState();
}

class _BackgroundServiceDemoState extends State<BackgroundServiceDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Service Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => BackgroundService.startService(),
              child: const Text('Start Background Service'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => BackgroundService.stopService(),
              child: const Text('Stop Background Service'),
            ),
            const SizedBox(height: 32),
           
          ],
        ),
      ),
    );
  }
}
