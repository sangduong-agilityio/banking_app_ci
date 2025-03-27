import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionScreen extends StatefulWidget {
  const StoragePermissionScreen({super.key});

  @override
  _StoragePermissionScreenState createState() =>
      _StoragePermissionScreenState();
}

class _StoragePermissionScreenState extends State<StoragePermissionScreen> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.storage.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        // Permission granted
        print("Storage permission granted");
      } else {
        // Permission denied
        print("Storage permission denied");
      }
    } else {
      // Permission already granted
      print("Storage permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Storage Permission Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestStoragePermission,
          child: Text("Request Storage Permission"),
        ),
      ),
    );
  }
}
