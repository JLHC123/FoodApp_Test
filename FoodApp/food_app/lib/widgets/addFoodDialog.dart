import 'package:flutter/material.dart';
import '../models/food.dart';

class AddFoodDialog extends StatefulWidget {
  final Future<void> Function(Food food) onAdd;

  const AddFoodDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddFoodDialog> createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final expirationDateController = TextEditingController();

  @override
  void dispose() {
    foodNameController.dispose();
    expirationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              final newFood = buildFood(foodNameController, expirationDateController);
              await widget.onAdd(newFood);
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}