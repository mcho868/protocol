import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import '../widgets/decision_header.dart';
import '../widgets/criteria_weight_table.dart';
import '../widgets/option_score_matrix.dart';
import '../widgets/tradeoff_panel.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/commitment_card.dart';

class DecisionMatrixView extends StatelessWidget {
  final DecisionMatrix matrix;

  const DecisionMatrixView({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecisionHeader(matrix: matrix),
          const SizedBox(height: 16),
          CriteriaWeightTable(matrix: matrix),
          const SizedBox(height: 16),
          OptionScoreMatrix(matrix: matrix),
          const SizedBox(height: 16),
          TradeoffPanel(matrix: matrix),
          const SizedBox(height: 16),
          RecommendationCard(matrix: matrix),
          const SizedBox(height: 16),
          CommitmentCard(matrix: matrix),
        ],
      ),
    );
  }
}
