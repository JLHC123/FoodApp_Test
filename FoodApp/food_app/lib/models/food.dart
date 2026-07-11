import 'package:flutter/material.dart';

// create Food class with id, name, and expirationDate
class Food{
  final int id;
  final String name;
  final DateTime expirationDate;

  Food({
    required this.id,
    required this.name,
    required this.expirationDate,
  });
}

// build new food object from user input
Food buildFood(TextEditingController foodNameController, TextEditingController expirationDateController) {
  final newFood = Food(
    id: 0,
    name: foodNameController.text,
    expirationDate: DateTime.parse(expirationDateController.text),
  );
  return newFood;
}

// Filter foods based on the selected filter
List<Food> getFilteredFoods(List<Food> foods, String selectedFilter, DateTime today) {
  if (selectedFilter == 'Expired') {
    return foods.where((food) {
      return food.expirationDate.isBefore(today);
    }).toList();
  }
  else if (selectedFilter == 'Expiring Soon') {
    return foods.where((food) {
      final daysLeft = food.expirationDate.difference(today).inDays;
      return daysLeft >= 0 && daysLeft <= 3;
    }).toList();
  }
  else if (selectedFilter == 'Fresh') {
    return foods.where((food) {
      final daysLeft = food.expirationDate.difference(today).inDays;
      return daysLeft > 3;
    }).toList();
  }
  return foods;
}

// get expiration date from calendar picker, format to YYYY-MM-DD
Future<void> getExpirationDate(BuildContext context, TextEditingController expirationDateController) async {
  DateTime? pickedDate = await pickCalenderDate(context);
  if (pickedDate != null) {
    expirationDateController.text = 
    // padLeft helps with the formatting
    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
  }
}

// show calendar picker for expiration date
Future<DateTime?> pickCalenderDate(BuildContext context) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 100), // just so that this keeps updating as time goes on
  );
  return pickedDate;
}

// Determine the expiration status icon color based on days left
String expirationStatus(int daysLeft) {
  if (daysLeft < 0) {
    return '🔴';
  }
  else if (daysLeft <= 3) {
    return '🟡';
  }
  else {
    return '🟢';
  }
}

// Get time truncated to just year month day for comparison purposes
DateTime truncateTime(DateTime time) {
  final truncatedTime = DateTime(
    time.year,
    time.month,
    time.day
  );
  return truncatedTime;
}