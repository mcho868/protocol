import 'package:flutter/material.dart';

class DecisionValueList extends StatelessWidget {
  final List<String> values;

  const DecisionValueList({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Text('Not provided', style: TextStyle(color: Colors.grey));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values
          .map((value) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
