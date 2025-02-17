import 'package:flutter/material.dart';

class FormDropdown extends StatelessWidget {
  final String? value;
  final String label;
  final IconData icon;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const FormDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
} 