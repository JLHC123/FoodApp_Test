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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to the Food Expiration App!',
              ),
              const SizedBox(height: 16.0),
              const Text('Milk - Expires: 2026-06-15'),
              const Text('Eggs - Expires: 2026-06-20'),
              const Text('Cheese - Expires: 2026-06-25'),
            ]
          )
        )
      ),
    );
  }
}