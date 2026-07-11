import 'package:flutter/material.dart';

class FoodFilterDropdown extends StatelessWidget {
  final String selectedFilter; 
  final ValueChanged<String?> onFilterChanged;

  const FoodFilterDropdown({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
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
      onChanged: onFilterChanged,
    );
  }
}