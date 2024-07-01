import 'package:flutter/material.dart';
import 'package:laza_design/ui/atoms/search_bar.dart';
import 'package:laza_design/ui/templates/scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const LazaShopScaffold(
      paddingScaffold: 20,
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          LSSearchBar()
        ],
      ),
    );
  }
}
