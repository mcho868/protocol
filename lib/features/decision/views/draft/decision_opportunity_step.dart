import 'package:flutter/material.dart';
import '../../widgets/draft/draft_section.dart';
import '../../widgets/draft/list_editor.dart';

class DecisionOpportunityStep extends StatelessWidget {
  final List<String> opportunityCosts;
  final List<String> assumptions;
  final double? capacityHours;
  final bool deadlineIsHard;
  final ValueChanged<List<String>> onOpportunityChanged;
  final ValueChanged<List<String>> onAssumptionsChanged;
  final void Function(double? hours, bool? deadlineIsHard) onConstraintsChanged;

  const DecisionOpportunityStep({
    super.key,
    required this.opportunityCosts,
    required this.assumptions,
    required this.capacityHours,
    required this.deadlineIsHard,
    required this.onOpportunityChanged,
    required this.onAssumptionsChanged,
    required this.onConstraintsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DraftSection(
          title: 'Opportunity Cost',
          child: ListEditor(
            hintText: 'What will you forego? (optional)',
            items: opportunityCosts,
            onAdd: (value) => onOpportunityChanged([...opportunityCosts, value]),
            onRemove: (index) {
              final updated = [...opportunityCosts]..removeAt(index);
              onOpportunityChanged(updated);
            },
          ),
        ),
        DraftSection(
          title: 'Assumptions',
          child: ListEditor(
            hintText: 'Add an assumption (optional)',
            items: assumptions,
            onAdd: (value) => onAssumptionsChanged([...assumptions, value]),
            onRemove: (index) {
              final updated = [...assumptions]..removeAt(index);
              onAssumptionsChanged(updated);
            },
          ),
        ),
        DraftSection(
          title: 'Constraints',
          child: Column(
            children: [
              TextFormField(
                initialValue: capacityHours?.toString() ?? '',
                decoration: const InputDecoration(
                  hintText: 'Available capacity hours (optional)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final hours = double.tryParse(value);
                  onConstraintsChanged(hours, null);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Deadline is hard'),
                value: deadlineIsHard,
                onChanged: (value) => onConstraintsChanged(null, value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
