// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionHandlerWidget extends StatefulWidget {
//   @override
//   _PermissionHandlerWidgetState createState() =>
//       _PermissionHandlerWidgetState();
// }

// class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
//   Future<PermissionStatus> _checkLocationPermission() async {
//     var location = Location();
//     var serviceEnabled = await location.serviceEnabled();

//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         // Location service is still not enabled
//         return PermissionStatus.denied;
//       }
//     }

//     var status = await location.hasPermission();
//     if (status == PermissionStatus.denied) {
//       status = await location.requestPermission();
//     }

//     return status;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Permission Handling Example'),
//       ),
//       body: FutureBuilder<PermissionStatus>(
//         future: _checkLocationPermission(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Future is still loading, show a loading indicator
//             return Center(child: CircularProgressIndicator());
//           } else {
//             // Future is complete, check the permission status
//             if (snapshot.data == PermissionStatus.granted) {
//               // Permission granted, allow the user to proceed
//               return MainScreen();
//             } else {
//               // Permission denied, show a message or request again
//               return PermissionDeniedScreen();
//             }
//           }
//         },
//       ),
//     );
//   }
// }

// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Main Functionality Screen'),
//     );
//   }
// }

// class PermissionDeniedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Location permission is required to proceed.'),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Retry requesting permission
//               _retryPermissionRequest(context);
//             },
//             child: Text('Retry Permission Request'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _retryPermissionRequest(BuildContext context) async {
//     var status = await PermissionHandlerWidget()._checkLocationPermission();
//     if (status == PermissionStatus.granted) {
//       // Permission granted after retry, navigate to the main screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     } else {
//       // Permission still denied after retry
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Location permission is required to proceed.'),
//         ),
//       );
//     }
//   }
// }
