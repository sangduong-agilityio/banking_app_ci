import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MicrophonePermissionScreen extends StatefulWidget {
  const MicrophonePermissionScreen({super.key});

  @override
  _MicrophonePermissionScreenState createState() =>
      _MicrophonePermissionScreenState();
}

class _MicrophonePermissionScreenState
    extends State<MicrophonePermissionScreen> {
  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
  }

  Future<void> requestMicrophonePermission() async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.microphone.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        // Permission granted
        print("Microphone permission granted");
      } else {
        // Permission denied
        print("Microphone permission denied");
      }
    } else {
      // Permission already granted
      print("Microphone permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Microphone Permission Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestMicrophonePermission,
          child: Text("Request Microphone Permission"),
        ),
      ),
    );
  }
}
