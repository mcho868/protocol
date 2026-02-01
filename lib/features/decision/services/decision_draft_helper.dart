import 'dart:convert';
import '../../../core/models/user_context.dart';

class DecisionDraftHelper {
  static Map<String, dynamic> buildDefaultDraft(UserContext? context) {
    return {
      'type': 'decision_draft',
      'schema_version': '0.3.0',
      'decision_title': '',
      'decision_deadline': '',
      'problem_frame': '',
      'reversibility': {
        'type': 'two_way_door',
        'reversal_cost': '',
      },
      'adequacy_criteria': {
        'must_haves': <String>[],
        'deal_breakers': <String>[],
      },
      'options': _buildDefaultOptions(),
      'criteria': _buildDefaultCriteria(context),
      'opportunity_cost': {
        'foregone_options': <String>[],
      },
      'assumptions': <String>[],
      'constraints': {
        'available_capacity_hours': null,
        'deadline_is_hard': true,
      },
      'review_date': '',
      'first_action_due': '',
    };
  }

  static Map<String, dynamic> ensureDraft(
    Map<String, dynamic> existing,
    UserContext? context,
  ) {
    final draft = existing.isEmpty ? buildDefaultDraft(context) : Map<String, dynamic>.from(existing);

    draft.putIfAbsent('type', () => 'decision_draft');
    draft.putIfAbsent('schema_version', () => '0.3.0');
    draft.putIfAbsent('decision_title', () => '');
    draft.putIfAbsent('decision_deadline', () => '');
    draft.putIfAbsent('problem_frame', () => '');
    draft.putIfAbsent('reversibility', () => {'type': 'two_way_door', 'reversal_cost': ''});
    draft.putIfAbsent(
      'adequacy_criteria',
      () => {
        'must_haves': <String>[],
        'deal_breakers': <String>[],
      },
    );
    draft.putIfAbsent('options', () => _buildDefaultOptions());
    draft.putIfAbsent('criteria', () => _buildDefaultCriteria(context));
    draft.putIfAbsent('opportunity_cost', () => {'foregone_options': <String>[]});
    draft.putIfAbsent('assumptions', () => <String>[]);
    draft.putIfAbsent(
      'constraints',
      () => {
        'available_capacity_hours': null,
        'deadline_is_hard': true,
      },
    );
    draft.putIfAbsent('review_date', () => '');
    draft.putIfAbsent('first_action_due', () => '');

    if (draft['options'] is! List || (draft['options'] as List).isEmpty) {
      draft['options'] = _buildDefaultOptions();
    }
    if (draft['criteria'] is! List || (draft['criteria'] as List).isEmpty) {
      draft['criteria'] = _buildDefaultCriteria(context);
    } else {
      final list = (draft['criteria'] as List).map((e) => (e as Map).cast<String, dynamic>()).toList();
      final hasNorthStar = list.any((c) => (c['name'] ?? '').toString().trim() == 'North Star Impact');
      if (!hasNorthStar) {
        list.insert(0, {
          'id': 'crit_ns',
          'name': 'North Star Impact',
          'weight': 40,
          'why_it_matters': 'Directly ties to the North Star metric.',
        });
      }
      draft['criteria'] = list;
    }

    return draft;
  }

  static Map<String, dynamic> seedDraftFromMessage(
    String message,
    Map<String, dynamic> existing,
  ) {
    final draft = Map<String, dynamic>.from(existing);
    final lines = message
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String normalize(String input) {
      return input.replaceAll('**', '').trim();
    }

    String? findLine(String prefix) {
      return lines.firstWhere(
        (l) => normalize(l).toLowerCase().startsWith(prefix.toLowerCase()),
        orElse: () => '',
      );
    }

    final decisionLine = findLine('decision:');
    if (decisionLine != null && decisionLine.isNotEmpty) {
      draft['decision_title'] ??= normalize(decisionLine).split(':').skip(1).join(':').trim();
    }
    final deadlineLine = findLine('deadline:');
    if (deadlineLine != null && deadlineLine.isNotEmpty) {
      final raw = normalize(deadlineLine).split(':').skip(1).join(':').trim();
      draft['decision_deadline'] ??= resolveDate(raw);
    }
    final reversibilityLine = findLine('reversibility:');
    if (reversibilityLine != null && reversibilityLine.isNotEmpty) {
      final value = normalize(reversibilityLine).split(':').skip(1).join(':').trim().toLowerCase();
      if (value.contains('two')) {
        draft['reversibility'] = {
          'type': 'two_way_door',
          'reversal_cost': 'Low',
        };
      } else if (value.contains('one')) {
        draft['reversibility'] = {
          'type': 'one_way_door',
          'reversal_cost': 'High',
        };
      }
    }
    final adequacyLine = findLine('adequacy criteria:');
    if (adequacyLine != null && adequacyLine.isNotEmpty) {
      draft['adequacy_criteria'] ??= {
        'must_haves': [
          normalize(adequacyLine).split(':').skip(1).join(':').trim(),
        ],
        'deal_breakers': <String>[],
      };
    }

    final optionLines = lines.where((line) {
      final l = normalize(line);
      if (l.length < 2) return false;
      final first = l.codeUnitAt(0);
      final second = l[1];
      return first >= 65 && first <= 90 && second == ')';
    }).toList();
    if (optionLines.isNotEmpty && draft['options'] == null) {
      draft['options'] = optionLines.asMap().entries.map((entry) {
        final label = entry.key + 1;
        final text = normalize(entry.value).substring(2).trim();
        return {
          'id': 'opt_$label',
          'name': text.split('(').first.trim(),
          'description': text,
        };
      }).toList();
    }

    if (draft['decision_deadline'] != null) {
      draft['review_date'] ??= defaultReviewDate(draft['decision_deadline'].toString());
      draft['first_action_due'] ??= defaultFirstActionDue();
    }

    return draft;
  }

  static List<Map<String, dynamic>> rebuildOptionIds(List<Map<String, dynamic>> options) {
    final rebuilt = <Map<String, dynamic>>[];
    var index = 1;
    for (final option in options) {
      final name = (option['name'] ?? '').toString();
      final id = option['id']?.toString() ?? '';
      final isStatus = name.toLowerCase().contains('status quo');
      rebuilt.add({
        'id': isStatus ? 'opt_status_quo' : 'opt_$index',
        'name': name,
        'description': option['description']?.toString() ?? '',
      });
      if (!isStatus) index += 1;
    }
    return rebuilt;
  }

  static List<Map<String, dynamic>> _buildDefaultOptions() {
    return [
      {'id': 'opt_1', 'name': '', 'description': ''},
      {'id': 'opt_2', 'name': '', 'description': ''},
      {'id': 'opt_3', 'name': '', 'description': ''},
    ];
  }

  static List<Map<String, dynamic>> _buildDefaultCriteria(UserContext? context) {
    final coreValues = context?.coreValues ?? <String>[];
    final criteria = <Map<String, dynamic>>[
      {
        'id': 'crit_ns',
        'name': 'North Star Impact',
        'weight': 40,
        'why_it_matters': 'Directly ties to the North Star metric.',
      },
    ];

    final mapped = <String, String>{
      'focus': 'Focus Alignment',
      'execution': 'Execution Reliability',
      'growth': 'Growth Potential',
      'craft': 'Craft Quality',
      'autonomy': 'Autonomy Preservation',
      'clarity': 'Clarity of Outcomes',
      'integrity': 'Integrity Alignment',
      'leverage': 'Leverage Multiplier',
      'resilience': 'Resilience Recovery',
      'simplicity': 'Simplicity Maintainability',
    };

    var idx = 1;
    for (final value in coreValues) {
      final key = value.toLowerCase().trim();
      final name = mapped[key] ?? '$value Alignment';
      criteria.add({
        'id': 'crit_${idx + 1}',
        'name': name,
        'weight': 0,
        'why_it_matters': 'Aligned to your core value of $value.',
      });
      idx += 1;
    }

    if (criteria.length == 1) {
      criteria.first['weight'] = 100;
    } else {
      final remainder = 100 - (criteria.first['weight'] as int);
      final per = (remainder / (criteria.length - 1)).floor();
      var running = 0;
      for (var i = 1; i < criteria.length; i += 1) {
        final weight = i == criteria.length - 1 ? remainder - running : per;
        criteria[i]['weight'] = weight;
        running += weight;
      }
    }

    return criteria;
  }

  static bool hasMinimumDraftForArtifact(Map<String, dynamic> draft) {
    final hasDecision = (draft['decision_title'] ?? '').toString().isNotEmpty;
    final hasDeadline = (draft['decision_deadline'] ?? '').toString().isNotEmpty;
    final hasReversibility = draft['reversibility'] is Map;
    final hasAdequacy = draft['adequacy_criteria'] is Map;
    final options = draft['options'];
    final hasOptions = options is List && options.length >= 3;
    return hasDecision && hasDeadline && hasReversibility && hasAdequacy && hasOptions;
  }

  static String resolveDate(String input) {
    final trimmed = input.trim();
    final lower = trimmed.toLowerCase();
    try {
      final parsed = DateTime.parse(trimmed);
      return parsed.toIso8601String();
    } catch (_) {}

    final now = DateTime.now();
    final weekdays = <String, int>{
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };
    for (final entry in weekdays.entries) {
      if (lower.contains(entry.key)) {
        var date = now;
        while (date.weekday != entry.value) {
          date = date.add(const Duration(days: 1));
        }
        return DateTime(date.year, date.month, date.day, 17, 0).toIso8601String();
      }
    }
    return DateTime(now.year, now.month, now.day, 17, 0).toIso8601String();
  }

  static String defaultReviewDate(String deadlineIso) {
    try {
      final deadline = DateTime.parse(deadlineIso);
      return DateTime(deadline.year, deadline.month, deadline.day, 18, 0).toIso8601String();
    } catch (_) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, 18, 0).toIso8601String();
    }
  }

  static String defaultFirstActionDue() {
    final now = DateTime.now().add(const Duration(hours: 1));
    return DateTime(now.year, now.month, now.day, now.hour, now.minute).toIso8601String();
  }

  static Map<String, dynamic> decodeDraft(String? jsonText) {
    if (jsonText == null || jsonText.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(jsonText) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
