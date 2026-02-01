class DecisionDraftValidator {
  List<String> validate(Map<String, dynamic> draft) {
    final errors = <String>[];

    final title = (draft['decision_title'] ?? '').toString().trim();
    if (title.isEmpty) errors.add('Decision title is required.');

    final deadline = (draft['decision_deadline'] ?? '').toString().trim();
    if (deadline.isEmpty) errors.add('Decision deadline is required.');

    final reversibility = draft['reversibility'] as Map?;
    if (reversibility == null || reversibility['type'] == null) {
      errors.add('Reversibility must be selected.');
    }

    final adequacy = draft['adequacy_criteria'] as Map?;
    final mustHaves = (adequacy?['must_haves'] as List?)
            ?.where((e) => e.toString().trim().isNotEmpty)
            .toList() ??
        <dynamic>[];
    if (mustHaves.isEmpty) errors.add('Add at least one must-have.');

    final options = draft['options'] as List?;
    final optionCount = options?.where((o) => (o as Map)['name']?.toString().trim().isNotEmpty ?? false).length ?? 0;
    if (optionCount < 3) errors.add('Add at least 3 options.');

    final criteria = draft['criteria'] as List?;
    if (criteria == null || criteria.isEmpty) {
      errors.add('Criteria are required.');
    } else {
      final weightSum = criteria.fold<int>(
        0,
        (sum, c) => sum + (int.tryParse(c['weight'].toString()) ?? 0).clamp(0, 100),
      );
      if (weightSum != 100) errors.add('Criteria weights must sum to 100.');
      final hasNorthStar = criteria.any((c) => c['name']?.toString().trim() == 'North Star Impact');
      if (!hasNorthStar) errors.add('Criteria must include "North Star Impact".');
    }

    return errors;
  }
}
