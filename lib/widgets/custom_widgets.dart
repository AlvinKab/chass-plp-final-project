import 'package:flutter/material.dart';

// Custom Text Field Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  CustomTextField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CustomButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
