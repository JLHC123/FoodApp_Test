import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'food.dart';
import 'food_database.dart';

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
  final _formKey = GlobalKey<FormState>();
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

  Future<void> loadFoods() async {
    final data = await foodDatabase.getAllFoods();
    setState(() {
      foods = data;
    });
  }

  // Dropdown menu for filtering foods based on expiration status
  Widget selectFoodFilter() {
    return DropdownButton<String>(
      value: selectedFilter,
      items: const [
        DropdownMenuItem(
          value: 'All',
          child: Text('All'),
        ),
        DropdownMenuItem(
          value: 'Expired',
          child: Text('Expired'),
        ),
        DropdownMenuItem(
          value: 'Expiring Soon',
          child: Text('Expiring Soon'),
        ),
        DropdownMenuItem(
          value: 'Fresh',
          child: Text('Fresh'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedFilter = value!;
        });
      },
    );
  }

   // Build the list of foods based on the filtered list
  Expanded displayFoodList(List<Food> filteredFoods, DateTime today) {
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
                showDeleteFoodDialog(context, food);
              },
            )
          );
        }
      )
    );
  }
    // add new food dialog box (too long)
  void showAddFoodDialog(BuildContext context) {
    final foodNameController = TextEditingController(); 
    final expirationDateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a food name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: expirationDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Expiration Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  await getExpirationDate(context, expirationDateController);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an expiration date';
                  }
                  return null;
                }
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Food newFood = buildFood(foodNameController, expirationDateController);
                await foodDatabase.insertFood(newFood);
                await loadFoods(); // Refresh the list after inserting new food
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  // delete food dialog box
  void showDeleteFoodDialog(BuildContext context, Food food) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Food'),
        content: Text('Delete ${food.name}?'),
        actions: [
          TextButton(
            onPressed:() async {
              await foodDatabase.deleteFood(food.id);
              await loadFoods();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}