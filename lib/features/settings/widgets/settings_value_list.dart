import 'package:flutter/material.dart';

class SettingsValueList extends StatelessWidget {
  final List<String> values;
  final String emptyLabel;

  const SettingsValueList({
    super.key,
    required this.values,
    this.emptyLabel = 'Not set',
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return Text(
        emptyLabel,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
