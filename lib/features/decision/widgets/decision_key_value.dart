import 'package:flutter/material.dart';

class DecisionKeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool invert;

  const DecisionKeyValue({
    super.key,
    required this.label,
    required this.value,
    this.invert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: invert ? Colors.white70 : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: invert ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
