import 'package:flutter/material.dart';
import 'widgets/addFoodDialog.dart';
import 'models/food.dart';
import 'databases/food_database.dart';
import 'widgets/deleteFoodDialog.dart';
import 'widgets/foodFilterDropdown.dart';
import 'widgets/displayFoodList.dart';

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

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});
  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  final FoodDatabase foodDatabase = FoodDatabase();
  List<Food> foods = [];
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateTime today = truncateTime(now);
    List<Food> filteredFoods = foods;
    filteredFoods = getFilteredFoods(filteredFoods, selectedFilter, today);
    return Scaffold(
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
            selectFoodFilter(),
            displayFoodList(filteredFoods, today)
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddFoodDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Initialize the database and load foods when the app starts
  Future<void> initializeApp() async {
    await foodDatabase.initializeDatabase();
    await loadFoods();
  }

  // load foods from database
  Future<void> loadFoods() async {
    final data = await foodDatabase.getAllFoods();
    setState(() {
      foods = data;
    });
  }

  // connects to addFoodDialog
  void showAddFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(
        onAdd: (newFood) async {
          await foodDatabase.insertFood(newFood);
          await loadFoods();
        },
      ),
    );
  }

  void showDeleteFoodDialog(BuildContext context, Food food) {
    showDialog(
      context: context, 
      builder: (context) => DeleteFoodDialog(
        food: food,
        onDelete: (food) async {
          await foodDatabase.deleteFood(food.id);
          await loadFoods();
        },
      )
    );
  }

  // Dropdown menu for filtering foods based on expiration status
  Widget selectFoodFilter() {
    return FoodFilterDropdown(
      selectedFilter: selectedFilter,
      onFilterChanged: (value) {
        setState(() {
          selectedFilter = value!;
        });
      },
    );
  }

   // Build the list of foods based on the filtered list
  Expanded displayFoodList(List<Food> filteredFoods, DateTime today) {
    return Expanded(
      child: DisplayFoodList(
        filteredFoods: filteredFoods,
        today: today,
        onDelete: (food) async {
          showDeleteFoodDialog(context, food);
        },
      )
    );
  }
}