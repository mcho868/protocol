import 'package:flutter/material.dart';

class DecisionGuideModal extends StatelessWidget {
  const DecisionGuideModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('DECISION PROTOCOL GUIDE'),
      content: SingleChildScrollView(
        child: Text(
          _guideText,
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

const String _guideText = '''
Decision Protocol (UI-First)
1) Fill in the decision inputs.
2) Generate the Decision Matrix.

You will define:
- The decision and deadline
- Reversibility
- Must-haves and options
- Criteria + weights (North Star included)

Why this matters
Core Values shape the scoring.
The North Star judges the outcome.
The Decision Protocol enforces both.
''';
