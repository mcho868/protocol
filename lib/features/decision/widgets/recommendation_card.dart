import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_section.dart';
import 'decision_key_value.dart';
import 'decision_value_list.dart';

class RecommendationCard extends StatelessWidget {
  final DecisionMatrix matrix;

  const RecommendationCard({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final optionNameById = {
      for (final option in matrix.options) option.id: option.name,
    };

    return DecisionSection(
      title: 'Recommendation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecisionKeyValue(
            label: 'Winning Option',
            value: optionNameById[matrix.recommendation.winningOptionId] ??
                matrix.recommendation.winningOptionId,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: const Text(
              'WINNING OPTION',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          DecisionValueList(values: matrix.recommendation.reasoningBullets),
          const SizedBox(height: 8),
          DecisionKeyValue(
            label: 'Confidence',
            value: matrix.recommendation.confidence.toStringAsFixed(2),
          ),
          if (matrix.recommendation.assumptions.isNotEmpty) ...[
            const SizedBox(height: 8),
            DecisionValueList(values: matrix.recommendation.assumptions),
          ],
        ],
      ),
    );
  }
}
