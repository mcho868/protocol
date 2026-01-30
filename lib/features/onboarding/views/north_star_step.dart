import 'package:flutter/material.dart';
import '../widgets/onboarding_selectable_tile.dart';

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

  static const List<String> _northStarPresets = [
    'Deep Work Blocks per Week',
    'Shipped Outputs per Week',
    'High-Impact Tasks Completed',
    'Weekly Review Completion',
    'Execution Consistency',
    'Revenue-Generating Actions',
  ];

  static const Map<String, String> _northStarDefinitions = {
    'Deep Work Blocks per Week':
        'Number of focused, distraction-free work sessions completed per week.',
    'Shipped Outputs per Week':
        'Count of externally visible deliverables (code shipped, content published, features released).',
    'High-Impact Tasks Completed':
        'Number of P0/P1 tasks completed that materially move projects forward.',
    'Weekly Review Completion':
        'Whether the weekly review ritual was completed consistently.',
    'Execution Consistency':
        'Percentage of planned days where meaningful execution occurred.',
    'Revenue-Generating Actions':
        'Count of actions tied to revenue creation (sales calls, proposals sent, launches).',
  };

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
          ..._northStarPresets.map((metric) => OnboardingSelectableTile(
                title: metric,
                subtitle: _northStarDefinitions[metric] ?? '',
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
