import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_section.dart';
import 'decision_key_value.dart';
import 'decision_value_list.dart';
import '../utils/date_format.dart';

class CommitmentCard extends StatelessWidget {
  final DecisionMatrix matrix;

  const CommitmentCard({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    return DecisionSection(
      title: 'Commitment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecisionKeyValue(
            label: 'Locked Choice',
            value: matrix.commitment.lockedChoiceOptionId,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showSnack(context, 'Decision locked.'),
            child: const Text('LOCK DECISION'),
          ),
          DecisionKeyValue(
            label: 'First Action',
            value: matrix.commitment.firstAction,
          ),
          DecisionKeyValue(
            label: 'First Action Due',
            value: formatDecisionDate(matrix.commitment.firstActionDue),
          ),
          DecisionValueList(values: matrix.commitment.implementationIntentions),
          const SizedBox(height: 8),
          DecisionKeyValue(
            label: 'Review Date',
            value: formatDecisionDate(matrix.review.reviewDate),
          ),
          DecisionValueList(values: matrix.review.exitCriteria),
          const SizedBox(height: 8),
          DecisionKeyValue(
            label: 'Check-in Question',
            value: matrix.review.checkInQuestion,
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
