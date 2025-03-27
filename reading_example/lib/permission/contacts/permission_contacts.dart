import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPermissionScreen extends StatefulWidget {
  const ContactsPermissionScreen({super.key});

  @override
  _ContactsPermissionScreenState createState() =>
      _ContactsPermissionScreenState();
}

class _ContactsPermissionScreenState extends State<ContactsPermissionScreen> {
  @override
  void initState() {
    super.initState();
    requestContactsPermission();
  }

  Future<void> requestContactsPermission() async {
    // Check if permission is granted
    PermissionStatus status = await Permission.contacts.status;

    // If the permission is not granted, request it
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.contacts.request();
      if (newStatus.isGranted) {
        // Permission granted
        print("Contacts permission granted");
      } else {
        // Permission denied
        print("Contacts permission denied");
      }
    } else {
      // Permission already granted
      print("Contacts permission already granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts Permission Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: requestContactsPermission,
          child: Text("Request Contacts Permission"),
        ),
      ),
    );
  }
}
