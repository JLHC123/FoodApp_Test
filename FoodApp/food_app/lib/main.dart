import 'package:flutter/material.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Expiration App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Food Expiration App'),
        ),
        body: const Center(
          child: Text('Welcome to the Food Expiration App!'),
        ),
      ),
    );
  }
}