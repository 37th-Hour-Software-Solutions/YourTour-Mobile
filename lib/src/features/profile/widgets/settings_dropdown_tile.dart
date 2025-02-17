import 'package:flutter/material.dart';

class SettingsDropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const SettingsDropdownTile({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        items: items.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
} 