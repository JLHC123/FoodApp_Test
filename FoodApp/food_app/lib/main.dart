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
    DateTime today = getToday();
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
            dropDownWidget(),
            expandFoodListBuilder(filteredFoods, today)
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the list of foods based on the filtered list
  Expanded expandFoodListBuilder(List<Food> filteredFoods, DateTime today) {
    return Expanded(
            // list of foods displayed
            child: ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                
                // expiration date truncated to just year month day
                final expirationDate = DateTime(
                  food.expirationDate.year,
                  food.expirationDate.month,
                  food.expirationDate.day,
                );

                final daysLeft = expirationDate.difference(today).inDays;

                // expiration date icon color code
                String expirationStatusIcon;
                if (expirationDate.isBefore(today)) {
                  expirationStatusIcon = '🔴';
                }
                else if (daysLeft <= 3) {
                  expirationStatusIcon = '🟡';
                }
                else {
                  expirationStatusIcon = '🟢';
                }
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
                      showDeleteDialog(context, food);
                    },
                  )
                );
              }
            )
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

  // Get today's date without time component
  DateTime getToday() {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day
    );
    return today;
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

  // Dropdown menu for filtering foods based on expiration status
  Widget dropDownWidget() {
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

  // add new food dialog box (too long)
  void showAddDialog(BuildContext context) {
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
    
                // food user input code
                controller: foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                ),
    
                // if empty error
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a food name';
                  }
                  return null;
                },
              ),
    
              TextFormField(
                // expiration date user input code
                controller: expirationDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Expiration Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                
                // calender code
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 100), // just so that this keeps updating as time goes on
                  );
    
                  if (pickedDate != null) {
                    expirationDateController.text = 
                    // YYYY, MM, DD, padLeft helps with the formatting
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
    
                // if empty error
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
            // if both are valid, proceed
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newFood = Food(
                  id: 0, // id will be auto-generated by the database
                  name: foodNameController.text,
                  expirationDate: DateTime.parse(expirationDateController.text),
                );

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
  void showDeleteDialog(BuildContext context, Food food) {
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