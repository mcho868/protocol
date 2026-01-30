import 'package:flutter/material.dart';
import '../widgets/onboarding_selectable_tile.dart';

class CoreValuesStep extends StatelessWidget {
  final Set<String> selectedValues;
  final List<String> customValues;
  final bool useCustom;
  final ValueChanged<bool> onToggleCustom;
  final TextEditingController customController;
  final void Function(String) onToggleValue;
  final VoidCallback onAddCustomValue;
  final void Function(String) onRemoveCustomValue;

  const CoreValuesStep({
    super.key,
    required this.selectedValues,
    required this.customValues,
    required this.useCustom,
    required this.onToggleCustom,
    required this.customController,
    required this.onToggleValue,
    required this.onAddCustomValue,
    required this.onRemoveCustomValue,
  });

  static const List<String> _coreValuePresets = [
    'Focus',
    'Execution',
    'Growth',
    'Craft',
    'Autonomy',
    'Clarity',
    'Integrity',
    'Leverage',
    'Resilience',
    'Simplicity',
  ];

  static const Map<String, String> _coreValueDefinitions = {
    'Focus': 'I prioritise meaningful work and deliberately eliminate distractions.',
    'Execution': 'I value shipping and progress over perfection.',
    'Growth': 'I optimise for long-term learning and compounding improvement.',
    'Craft': 'I care about quality, standards, and building things properly.',
    'Autonomy': 'I value control over my time, decisions, and direction.',
    'Clarity': 'I prefer clear thinking, explicit trade-offs, and defined outcomes.',
    'Integrity': 'I follow through on commitments and act in alignment with my principles.',
    'Leverage': 'I use systems, tools, and structure to multiply my impact.',
    'Resilience': 'I recover quickly from setbacks and maintain forward momentum.',
    'Simplicity': 'I choose simple, maintainable solutions over unnecessary complexity.',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CORE VALUES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Core Values are decision filters. They define how the system should prioritise, reject, and trade off options.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select up to 3.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const Text(
            'You can change this later in settings.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ..._coreValuePresets.map((value) => OnboardingSelectableTile(
                title: value,
                subtitle: _coreValueDefinitions[value] ?? '',
                selected: selectedValues.contains(value),
                onTap: () => onToggleValue(value),
              )),
          OnboardingSelectableTile(
            title: 'Other (custom)',
            subtitle: 'Add your own values. You can add more than one.',
            selected: useCustom,
            onTap: () => onToggleCustom(!useCustom),
          ),
          const SizedBox(height: 16),
          if (useCustom) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Add a custom value',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onAddCustomValue,
                  child: const Text('ADD'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...customValues.map((value) => OnboardingSelectableTile(
                  title: value,
                  subtitle: 'Custom value (tap to remove)',
                  selected: true,
                  onTap: () => onRemoveCustomValue(value),
                )),
          ],
          const SizedBox(height: 24),
          const Text(
            'How Core Values are used by the system:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Applied as implicit weighting in DecisionMatrix scoring\n'
            '- Referenced explicitly in explanations\n'
            '- Used in Reviews to detect value drift',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
