import 'package:flutter/material.dart';
import '../models/food.dart';
import 'package:intl/intl.dart';

class FoodDetailsDialog extends StatelessWidget {
  final Food food;

  const FoodDetailsDialog({
    super.key,
    required this.food,
  });

  @override 
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(food.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expiration Date: ${DateFormat('yyyy-MM-dd').format(food.expirationDate)}'),
          Text('Useful Links: '),
          Text('https://www.google.com/search?q=${food.name}'),
          Text('https://www.google.com/search?q=${food.name}+recipes'),
        ]
      )
    );
  }
}