import 'package:flutter/material.dart';
import '../pages/FoodHomePage.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Expiration App',
      home: const FoodHomePage(),
    );
  }
}