import 'package:flutter/material.dart';

class FormChips extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> selectedValues;
  final ValueChanged<Set<String>> onChanged;

  const FormChips({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) => 
            FilterChip(
              label: Text(option),
              selected: selectedValues.contains(option),
              onSelected: (selected) {
                final newValues = Set<String>.from(selectedValues);
                selected ? newValues.add(option) : newValues.remove(option);
                onChanged(newValues);
              },
            ),
          ).toList(),
        ),
      ],
    );
  }
} 