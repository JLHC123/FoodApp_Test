import 'package:flutter/material.dart';
import '../models/food.dart';

class DeleteFoodDialog extends StatefulWidget {
  final Food food;
  final Future<void> Function(Food) onDelete;

  const DeleteFoodDialog({
    super.key,
    required this.food,
    required this.onDelete,
  });

  @override
  State<DeleteFoodDialog> createState() => _DeleteFoodDialogState();
}

class _DeleteFoodDialogState extends State<DeleteFoodDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Food'),
      content: Text('Delete ${widget.food.name}?'),
      actions: [
        TextButton(
          onPressed: () async {
            await widget.onDelete(widget.food);
            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

