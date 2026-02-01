import 'package:flutter/material.dart';
import '../../widgets/draft/draft_section.dart';

class DecisionOptionsStep extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final bool includeStatusQuo;
  final void Function(int index, String value) onNameChanged;
  final void Function(int index, String value) onDescriptionChanged;
  final VoidCallback onAddOption;
  final void Function(int index) onRemoveOption;
  final ValueChanged<bool> onToggleStatusQuo;

  const DecisionOptionsStep({
    super.key,
    required this.options,
    required this.includeStatusQuo,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onToggleStatusQuo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DraftSection(
          title: 'Options',
          child: Column(
            children: [
              for (var i = 0; i < options.length; i += 1)
                _OptionCard(
                  index: i,
                  option: options[i],
                  canRemove: options.length > 3,
                  onNameChanged: (value) => onNameChanged(i, value),
                  onDescriptionChanged: (value) => onDescriptionChanged(i, value),
                  onRemove: () => onRemoveOption(i),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: onAddOption,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Option'),
                ),
              ),
            ],
          ),
        ),
        DraftSection(
          title: 'Status Quo',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Include Status Quo / Delay option'),
            value: includeStatusQuo,
            onChanged: onToggleStatusQuo,
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> option;
  final bool canRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final VoidCallback onRemove;

  const _OptionCard({
    required this.index,
    required this.option,
    required this.canRemove,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = (option['name'] ?? '').toString();
    final description = (option['description'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Option ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
            ],
          ),
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(
              hintText: 'Option name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: description,
            decoration: const InputDecoration(
              hintText: 'Short description (optional)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onDescriptionChanged,
          ),
        ],
      ),
    );
  }
}
