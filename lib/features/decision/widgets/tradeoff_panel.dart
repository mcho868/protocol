import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_section.dart';
import 'decision_key_value.dart';

class TradeoffPanel extends StatelessWidget {
  final DecisionMatrix matrix;

  const TradeoffPanel({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final optionNameById = {
      for (final option in matrix.options) option.id: option.name,
    };
    final winningId = matrix.recommendation.winningOptionId;

    return DecisionSection(
      title: 'Tradeoffs',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: matrix.tradeoffAudit
            .map((tradeoff) => Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: tradeoff.optionId == winningId ? Colors.black : Colors.transparent,
                    border: tradeoff.optionId == winningId
                        ? Border.all(color: Colors.black, width: 1)
                        : Border.all(color: Colors.black, width: 1),
                  ),
                  child: DecisionKeyValue(
                    label: optionNameById[tradeoff.optionId] ?? tradeoff.optionId,
                    value: tradeoff.primarySacrifice,
                    invert: tradeoff.optionId == winningId,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
