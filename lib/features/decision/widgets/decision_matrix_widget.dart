import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import '../views/decision_review_page.dart';
import 'decision_badge.dart';
import 'decision_key_value.dart';
import 'decision_section.dart';
import 'decision_value_list.dart';

class DecisionMatrixWidget extends StatelessWidget {
  final DecisionMatrix matrix;

  const DecisionMatrixWidget({
    super.key,
    required this.matrix,
  });

  @override
  Widget build(BuildContext context) {
    final optionNameById = {
      for (final option in matrix.options) option.id: option.name,
    };
    final sortedCriteria = [...matrix.criteria]
      ..sort((a, b) {
        final aIsNorthStar = a.name.toLowerCase().contains('north star');
        final bIsNorthStar = b.name.toLowerCase().contains('north star');
        if (aIsNorthStar == bIsNorthStar) return 0;
        return aIsNorthStar ? -1 : 1;
      });

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
                  'Deadline: ${matrix.decisionDeadline}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Frame',
            child: DecisionKeyValue(
              label: 'Problem',
              value: matrix.problemFrame,
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Adequacy',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DecisionKeyValue(label: 'Must Haves', value: ''),
                DecisionValueList(values: matrix.adequacyCriteria.mustHaves),
                const SizedBox(height: 8),
                const DecisionKeyValue(label: 'Deal Breakers', value: ''),
                DecisionValueList(values: matrix.adequacyCriteria.dealBreakers),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Options',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matrix.options
                  .map((option) => DecisionKeyValue(
                        label: option.name,
                        value: option.description,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Opportunity Cost',
            child: DecisionValueList(values: matrix.opportunityCost.foregoneOptions),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Criteria',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sortedCriteria
                  .map((criterion) => DecisionKeyValue(
                        label: '${criterion.name} (${criterion.weight})',
                        value: criterion.whyItMatters,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Totals',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (matrix.totalsScale != null && matrix.totalsScale!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Scale: ${matrix.totalsScale}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ...matrix.totals
                    .map((total) => DecisionKeyValue(
                          label: optionNameById[total.optionId] ?? total.optionId,
                          value: total.weightedTotal.toStringAsFixed(2),
                        ))
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Tradeoffs',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matrix.tradeoffAudit
                  .map((tradeoff) => DecisionKeyValue(
                        label: optionNameById[tradeoff.optionId] ?? tradeoff.optionId,
                        value: tradeoff.primarySacrifice,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
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
                DecisionValueList(values: matrix.recommendation.reasoningBullets),
                const SizedBox(height: 8),
                DecisionKeyValue(
                  label: 'Confidence',
                  value: matrix.recommendation.confidence.toStringAsFixed(2),
                ),
                const SizedBox(height: 8),
                DecisionValueList(values: matrix.recommendation.assumptions),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Risks',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matrix.risks
                  .map((risk) => DecisionKeyValue(
                        label: '${risk.risk} (${risk.likelihood}/${risk.impact})',
                        value: risk.mitigation,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
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
                  value: matrix.commitment.firstActionDue,
                ),
                DecisionValueList(values: matrix.commitment.implementationIntentions),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showSnack(context, 'Start: ${matrix.commitment.firstAction}'),
                  child: const Text('START FIRST ACTION'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Review',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecisionKeyValue(
                  label: 'Review Date',
                  value: matrix.review.reviewDate,
                ),
                DecisionValueList(values: matrix.review.exitCriteria),
                const SizedBox(height: 8),
                DecisionKeyValue(
                  label: 'Check-in Question',
                  value: matrix.review.checkInQuestion,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DecisionReviewPage(decisionId: matrix.decisionId),
                    ),
                  ),
                  child: const Text('REVIEW OUTCOME'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DecisionSection(
            title: 'Memory Links',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecisionValueList(values: matrix.memoryLinks.coreValuesUsed),
                const SizedBox(height: 8),
                DecisionKeyValue(
                  label: 'North Star',
                  value: matrix.memoryLinks.northStarMetricUsed,
                ),
              ],
            ),
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
