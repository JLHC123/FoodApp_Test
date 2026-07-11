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