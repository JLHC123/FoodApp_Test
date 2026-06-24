import 'package:flutter/material.dart';

final foods = [
  {'name': 'Milk', 'expirationDate': '2026-06-15'},
  {'name': 'Eggs', 'expirationDate': '2026-06-20'},
  {'name': 'Cheese', 'expirationDate': '2026-06-25'},
];

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Expiration App',
      home: Scaffold(
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
                          // Handle delete action
                          print('Delete ${food['name']}');
                        },
                      )
                    );
                  }
                )
              )
            ]
          )
        )
      ),
    );
  }
}