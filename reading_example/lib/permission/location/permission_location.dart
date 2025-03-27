import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  _LocationPermissionScreenState createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    // Check if permission is granted
    PermissionStatus status = await Permission.location.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.location.request();
      if (newStatus.isGranted) {
        // Permission granted, do something (e.g., get location)
        print("Location permission granted");
      } else {
        // Permission denied, show a message or handle accordingly
        print("Location permission denied");
      }
    } else {
      // Permission already granted
      print("Location permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Permission Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestLocationPermission,
          child: Text("Request Location Permission"),
        ),
      ),
    );
  }
}
