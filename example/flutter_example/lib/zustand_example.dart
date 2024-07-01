import 'package:flutter/material.dart';
import 'package:flutter_zustand/flutter_zustand.dart';

void main() {
  runApp(const StoreScope(child: MyApp()));
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
    final bears = useBearStore().select(context, (state) => state);
    return ElevatedButton(
      onPressed: useBearStore().increasePopulation,
      child: Text('Bears: $bears'),
    );
  }
}

class BearStore extends Store<int> {
  BearStore() : super(0);

  void increasePopulation() => set(state + 1);
  void removeAllBears() => set(0);
}

BearStore useBearStore() => create(() => BearStore());
