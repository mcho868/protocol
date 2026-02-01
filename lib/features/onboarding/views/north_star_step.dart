import 'package:flutter/material.dart';
import '../widgets/onboarding_selectable_tile.dart';
import '../onboarding_presets.dart';

class NorthStarStep extends StatelessWidget {
  final String? selectedMetric;
  final bool useCustom;
  final ValueChanged<bool> onToggleCustom;
  final TextEditingController nameController;
  final TextEditingController unitController;
  final TextEditingController targetController;
  final void Function(String) onSelectMetric;

  const NorthStarStep({
    super.key,
    required this.selectedMetric,
    required this.useCustom,
    required this.onToggleCustom,
    required this.nameController,
    required this.unitController,
    required this.targetController,
    required this.onSelectMetric,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NORTH STAR METRIC',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The North Star Metric is the single behavioural signal used to judge progress.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select exactly 1.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const Text(
            'You can change this later in settings.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ...northStarPresets.map((metric) => OnboardingSelectableTile(
                title: metric,
                subtitle: northStarDefinitions[metric] ?? '',
                selected: selectedMetric == metric,
                onTap: () => onSelectMetric(metric),
              )),
          OnboardingSelectableTile(
            title: 'Other (custom)',
            subtitle: 'Define your own metric with unit and weekly target.',
            selected: useCustom,
            onTap: () => onToggleCustom(!useCustom),
          ),
          const SizedBox(height: 16),
          if (useCustom) ...[
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Metric name',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: unitController,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Measurement unit (e.g. sessions, tasks, %)',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Weekly target',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 4),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'How the North Star is used by the system:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '- Acts as the primary evaluation axis in Weekly Reviews\n'
            '- Influences ActionPlan prioritisation\n'
            '- Used for longitudinal tracking and trend detection\n'
            '- Surfaces misalignment',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
