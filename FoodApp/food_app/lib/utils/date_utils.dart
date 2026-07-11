import 'package:flutter/material.dart';

// get expiration date from calendar picker, format to YYYY-MM-DD
Future<void> getExpirationDate(BuildContext context, TextEditingController expirationDateController) async {
  DateTime? pickedDate = await pickCalenderDate(context);
  if (pickedDate != null) {
    expirationDateController.text = 
    // padLeft helps with the formatting
    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
  }
}

// show calendar picker for expiration date
Future<DateTime?> pickCalenderDate(BuildContext context) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 100), // just so that this keeps updating as time goes on
  );
  return pickedDate;
}