import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json/json.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final myself = Person.fromJson(jsonDecode(sampleJsonStr));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text('Hello, Macros!, I am ${myself.name}'),
      ),
    );
  }
}

const sampleJsonStr = """
{
"name":"Sang",
"age":25
}
""";

@JsonCodable()
class Person {
  final String name;
}
