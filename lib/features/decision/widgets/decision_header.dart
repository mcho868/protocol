import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_badge.dart';
import '../utils/date_format.dart';

class DecisionHeader extends StatelessWidget {
  final DecisionMatrix matrix;

  const DecisionHeader({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          matrix.decisionTitle.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DecisionBadge(
              label: matrix.reversibility.type == 'one_way_door'
                  ? 'ONE-WAY DOOR'
                  : 'TWO-WAY DOOR',
            ),
            if ((matrix.decisionDeadline ?? '').isNotEmpty)
              Text(
                'Deadline: ${formatDecisionDate(matrix.decisionDeadline)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.black),
      ],
    );
  }
}
