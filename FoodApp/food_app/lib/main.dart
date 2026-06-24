import 'package:flutter/material.dart';

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
  final foods = [
    {'name': 'Milk', 'expirationDate': '2026-06-15'},
    {'name': 'Eggs', 'expirationDate': '2026-06-20'},
    {'name': 'Cheese', 'expirationDate': '2026-06-25'},
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
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return ListTile(
                    title: Text(food['name']!),
                    subtitle: Text('Expires: ${food['expirationDate']}'),
                    onTap: () {
                      print('${food['name']} tapped');
                    },
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

      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final foodNameController = TextEditingController(); 
          final expirationDateController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Food'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: foodNameController,
                    decoration: const InputDecoration(
                      labelText: 'Food Name',
                    ),
                  ),
                  TextField(
                    controller: expirationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiration Date',
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      foods.add({'name': foodNameController.text, 'expirationDate': expirationDateController.text});
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, Map<String, String> food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Food'),
        content: Text('Delete ${food['name']}?'),
        actions: [
          TextButton(
            onPressed:() {
              deleteFood(index, food);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void deleteFood(int index, Map<String, String> food) {
    setState(() {
      foods.removeAt(index);
    });
    print('Delete ${food['name']}');
  }
}