import 'package:flutter/material.dart';
import '../../utils/date_format.dart';
import '../../widgets/draft/draft_section.dart';
import '../../widgets/draft/list_editor.dart';

class DecisionFramingStep extends StatelessWidget {
  final Map<String, dynamic> draft;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onProblemFrameChanged;
  final ValueChanged<DateTime> onDeadlineChanged;
  final ValueChanged<String> onReversibilityChanged;
  final ValueChanged<List<String>> onMustHavesChanged;
  final ValueChanged<List<String>> onDealBreakersChanged;

  const DecisionFramingStep({
    super.key,
    required this.draft,
    required this.onTitleChanged,
    required this.onProblemFrameChanged,
    required this.onDeadlineChanged,
    required this.onReversibilityChanged,
    required this.onMustHavesChanged,
    required this.onDealBreakersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final title = (draft['decision_title'] ?? '').toString();
    final frame = (draft['problem_frame'] ?? '').toString();
    final deadlineIso = (draft['decision_deadline'] ?? '').toString();
    final reversibility = (draft['reversibility'] as Map?)?['type']?.toString() ?? 'two_way_door';
    final adequacy = (draft['adequacy_criteria'] as Map?) ?? {};
    final mustHaves = (adequacy['must_haves'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    final dealBreakers = (adequacy['deal_breakers'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DraftSection(
          title: 'Decision',
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'What decision are you making?',
              border: OutlineInputBorder(),
            ),
            initialValue: title,
            onChanged: onTitleChanged,
          ),
        ),
        DraftSection(
          title: 'Deadline',
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    deadlineIso.isEmpty ? 'Select a deadline' : formatDecisionDate(deadlineIso),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _pickDate(context),
                child: const Text('Pick'),
              ),
            ],
          ),
        ),
        DraftSection(
          title: 'Reversibility',
          child: ToggleButtons(
            isSelected: [reversibility == 'two_way_door', reversibility == 'one_way_door'],
            onPressed: (index) {
              onReversibilityChanged(index == 0 ? 'two_way_door' : 'one_way_door');
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Two-way door'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('One-way door'),
              ),
            ],
          ),
        ),
        DraftSection(
          title: 'Problem frame (optional)',
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'What are you optimizing for?',
              border: OutlineInputBorder(),
            ),
            initialValue: frame,
            onChanged: onProblemFrameChanged,
          ),
        ),
        DraftSection(
          title: 'Must-haves',
          child: ListEditor(
            hintText: 'Add a must-have constraint',
            items: mustHaves,
            onAdd: (value) => onMustHavesChanged([...mustHaves, value]),
            onRemove: (index) {
              final updated = [...mustHaves]..removeAt(index);
              onMustHavesChanged(updated);
            },
          ),
        ),
        DraftSection(
          title: 'Deal-breakers',
          child: ListEditor(
            hintText: 'Add a deal-breaker (optional)',
            items: dealBreakers,
            onAdd: (value) => onDealBreakersChanged([...dealBreakers, value]),
            onRemove: (index) {
              final updated = [...dealBreakers]..removeAt(index);
              onDealBreakersChanged(updated);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null || !context.mounted) return;
    onDeadlineChanged(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}
