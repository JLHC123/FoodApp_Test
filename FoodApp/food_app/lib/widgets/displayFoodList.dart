import 'package:flutter/material.dart';
import '../models/food.dart';
import 'package:intl/intl.dart';

class DisplayFoodList extends StatelessWidget {
  final List<Food> filteredFoods;
  final DateTime today;
  final Future<void> Function(Food)? onDelete;

  const DisplayFoodList({
    super.key,
    required this.filteredFoods,
    required this.today,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredFoods.length,
        itemBuilder: (context, index) {
          // for each food in filteredFoods...
          final food = filteredFoods[index];
          final expirationDate = truncateTime(food.expirationDate);
          final daysLeft = expirationDate.difference(today).inDays;
          // expiration date icon color code
          String expirationStatusIcon = expirationStatus(daysLeft);
          return ListTile(
            leading: Text(
              expirationStatusIcon,
            ),
            title: Text(food.name),
            subtitle: 
            Text('Expires: ${DateFormat('yyyy-MM-dd').format(food.expirationDate)}'),
            onTap: () {
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete?.call(food);
              },
            )
          );
        }
      )
    );
  }
}

