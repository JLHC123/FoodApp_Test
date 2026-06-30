import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const FoodApp());
}

// this is how MaterialApp should be placed
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

class _FoodHomePageState extends State<FoodHomePage> {
  // for "missing user input"
  final _formKey = GlobalKey<FormState>();

  // stand in for database
  int nextId = 4;
  final List<Food> foods = [
    Food(
      id: 1,
      name: 'Milk',
      expirationDate: DateTime(2026, 6, 15),
    ),
    Food(
      id: 2,
      name: 'Burger',
      expirationDate: DateTime(2026, 6, 30),
    ),
    Food(
      id: 3,
      name: 'Canned Beans',
      expirationDate: DateTime(2057, 6, 23),
    )
  ];

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              // list of foods displayed
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  final expirationDate = food.expirationDate;
                  final today = DateTime.now();

                  // expiration date icon color code
                  String expirationStatusIcon;
                  if (expirationDate.isBefore(today)) {
                    expirationStatusIcon = '🔴';
                  }
                  else if (expirationDate.difference(today).inDays <= 3) {
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
                    // 
                    Text('Expires: ${DateFormat('yyyy-MM-dd').format(food.expirationDate)}'),
                    onTap: () {
                    },
                    // delete button at the side of each item
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDeleteDialog(context, food, index);
                      },
                    )
                  );
                }
              )
            )
          ]
        )
      ),
      // add new foods
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  foods.add(
                    Food(
                      id: nextId++,
                      name: foodNameController.text,
                      expirationDate: DateTime.parse(expirationDateController.text,)
                      )
                    );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Food'),
        content: Text('Delete ${food.name}?'),
        actions: [
          TextButton(
            onPressed:() {
              deleteFood(index, food);
              Navigator.pop(context);
              // // to check if items are being deleted properly
              // for (final food in foods) {
              //   print(food);
              // }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void deleteFood(int index, Food food) {
    setState(() {
      foods.removeAt(index);
    });
  }
}