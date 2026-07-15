import 'package:flutter/material.dart';
import '../models/food.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodDetailsDialog extends StatelessWidget {
  final Food food;

  const FoodDetailsDialog({
    super.key,
    required this.food,
  });

  @override 
  Widget build(BuildContext context) {
    final expirationDate = DateFormat('yyyy-MM-dd').format(food.expirationDate);
    final foodName = Uri.encodeComponent(food.name);
    final foodUrl = Uri.parse('https://www.google.com/search?q=$foodName');
    final recipeUrl = Uri.parse('https://www.google.com/search?q=$foodName+recipes');
    return AlertDialog(
      title: Text(food.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expiration Date: $expirationDate'),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              if (await canLaunchUrl(foodUrl)) {
                await launchUrl(foodUrl);
              }
            },
            child: const Text(
              'Search for more information',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              if (await canLaunchUrl(recipeUrl)) {
                await launchUrl(recipeUrl);
              }
            },
            child: const Text(
              'Search for recipes',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      )
    );
  }
}