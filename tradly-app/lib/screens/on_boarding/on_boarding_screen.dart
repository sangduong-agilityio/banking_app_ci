import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 358,
            color: Colors.blue,
          ),
          Container(
            height: 454,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
