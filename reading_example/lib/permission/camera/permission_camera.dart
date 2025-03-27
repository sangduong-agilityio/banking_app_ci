import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCamera extends StatefulWidget {
  const PermissionCamera({super.key});

  @override
  State<PermissionCamera> createState() => _PermissionCameraState();
}

class _PermissionCameraState extends State<PermissionCamera> {
  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    // Check if permission is granted
    PermissionStatus status = await Permission.camera.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        // Permission granted, do something (e.g., open camera)
        print("Camera permission granted");
      } else {
        // Permission denied, show a message or handle accordingly
        print("Camera permission denied");
      }
    } else {
      // Permission already granted
      print("Camera permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Permission Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestCameraPermission,
          child: Text("Request Camera Permission"),
        ),
      ),
    );
  }
}
