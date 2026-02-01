import 'package:flutter/material.dart';
import '../../widgets/draft/draft_section.dart';

class DecisionCriteriaStep extends StatelessWidget {
  final List<Map<String, dynamic>> criteria;
  final VoidCallback onAddCriterion;
  final void Function(int index) onRemoveCriterion;
  final void Function(int index, String value) onNameChanged;
  final void Function(int index, int value) onWeightChanged;
  final VoidCallback onRebalance;

  const DecisionCriteriaStep({
    super.key,
    required this.criteria,
    required this.onAddCriterion,
    required this.onRemoveCriterion,
    required this.onNameChanged,
    required this.onWeightChanged,
    required this.onRebalance,
  });

  @override
  Widget build(BuildContext context) {
    final weightSum = criteria.fold<int>(
      0,
      (sum, c) => sum + (int.tryParse(c['weight'].toString()) ?? 0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DraftSection(
          title: 'Criteria & Weights',
          child: Column(
            children: [
              for (var i = 0; i < criteria.length; i += 1)
                _CriterionRow(
                  index: i,
                  criterion: criteria[i],
                  canRemove: i != 0,
                  onNameChanged: (value) => onNameChanged(i, value),
                  onWeightChanged: (value) => onWeightChanged(i, value),
                  onRemove: () => onRemoveCriterion(i),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: onAddCriterion,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Criterion'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: onRebalance,
                    child: const Text('Auto-balance'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Weight total: $weightSum / 100'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CriterionRow extends StatelessWidget {
  final int index;
  final Map<String, dynamic> criterion;
  final bool canRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int> onWeightChanged;
  final VoidCallback onRemove;

  const _CriterionRow({
    required this.index,
    required this.criterion,
    required this.canRemove,
    required this.onNameChanged,
    required this.onWeightChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = (criterion['name'] ?? '').toString();
    final weight = (criterion['weight'] ?? 0).toString();
    final isLocked = name.trim() == 'North Star Impact';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: name,
              enabled: !isLocked,
              decoration: const InputDecoration(
                hintText: 'Criterion name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: onNameChanged,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: weight,
              decoration: const InputDecoration(
                hintText: 'Weight',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => onWeightChanged(int.tryParse(value) ?? 0),
            ),
          ),
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
