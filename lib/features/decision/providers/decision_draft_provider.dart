import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/decision_draft.dart';
import '../../../core/models/user_context.dart';
import '../../settings/providers/settings_provider.dart';
import '../services/decision_draft_helper.dart';

part 'decision_draft_provider.g.dart';

class DecisionDraftState {
  final int sessionId;
  final Map<String, dynamic> draft;
  final DecisionDraft record;
  final UserContext? userContext;

  const DecisionDraftState({
    required this.sessionId,
    required this.draft,
    required this.record,
    required this.userContext,
  });

  DecisionDraftState copyWith({
    Map<String, dynamic>? draft,
    DecisionDraft? record,
    UserContext? userContext,
  }) {
    return DecisionDraftState(
      sessionId: sessionId,
      draft: draft ?? this.draft,
      record: record ?? this.record,
      userContext: userContext ?? this.userContext,
    );
  }
}

@riverpod
class DecisionDraftController extends _$DecisionDraftController {
  @override
  Future<DecisionDraftState> build(int sessionId) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final userContext = await ref.read(settingsControllerProvider.future);
    final existing = await repo.getDecisionDraftBySessionId(sessionId);
    final draft = DecisionDraftHelper.ensureDraft(
      DecisionDraftHelper.decodeDraft(existing?.dataJson),
      userContext,
    );

    final record = existing ?? DecisionDraft()..sessionId = sessionId;
    record.dataJson = jsonEncode(draft);
    record.updatedAt = DateTime.now();
    await repo.saveDecisionDraft(record);

    return DecisionDraftState(
      sessionId: sessionId,
      draft: draft,
      record: record,
      userContext: userContext,
    );
  }

  Future<void> updateDraft(Map<String, dynamic> draft) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> setDecisionTitle(String value) async {
    await _updateField('decision_title', value);
  }

  Future<void> setProblemFrame(String value) async {
    await _updateField('problem_frame', value);
  }

  Future<void> setDecisionDeadline(DateTime dateTime) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    draft['decision_deadline'] = dateTime.toIso8601String();
    if ((draft['review_date'] ?? '').toString().isEmpty) {
      draft['review_date'] = DecisionDraftHelper.defaultReviewDate(draft['decision_deadline'].toString());
    }
    if ((draft['first_action_due'] ?? '').toString().isEmpty) {
      draft['first_action_due'] = DecisionDraftHelper.defaultFirstActionDue();
    }
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> setReversibility(String type) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    draft['reversibility'] = {
      'type': type,
      'reversal_cost': type == 'one_way_door' ? 'High' : 'Low',
    };
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> setMustHaves(List<String> values) async {
    await _updateAdequacy('must_haves', values);
  }

  Future<void> setDealBreakers(List<String> values) async {
    await _updateAdequacy('deal_breakers', values);
  }

  Future<void> updateOption(int index, {String? name, String? description}) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final options = _optionList(current.draft);
    if (index < 0 || index >= options.length) return;
    final option = Map<String, dynamic>.from(options[index]);
    if (name != null) option['name'] = name;
    if (description != null) option['description'] = description;
    options[index] = option;
    final rebuilt = DecisionDraftHelper.rebuildOptionIds(options);
    await _updateField('options', rebuilt);
  }

  Future<void> addOption() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final options = _optionList(current.draft);
    options.add({'id': 'opt_${options.length + 1}', 'name': '', 'description': ''});
    final rebuilt = DecisionDraftHelper.rebuildOptionIds(options);
    await _updateField('options', rebuilt);
  }

  Future<void> removeOption(int index) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final options = _optionList(current.draft);
    if (index < 0 || index >= options.length) return;
    options.removeAt(index);
    final rebuilt = DecisionDraftHelper.rebuildOptionIds(options);
    await _updateField('options', rebuilt);
  }

  Future<void> toggleStatusQuo(bool include) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final options = _optionList(current.draft);
    final hasStatus = options.any((o) => (o['name'] ?? '').toString().toLowerCase().contains('status quo'));
    if (include && !hasStatus) {
      options.add({
        'id': 'opt_status_quo',
        'name': 'Status Quo / Delay',
        'description': 'Do nothing / delay the decision',
      });
    } else if (!include && hasStatus) {
      options.removeWhere((o) => (o['name'] ?? '').toString().toLowerCase().contains('status quo'));
    }
    final rebuilt = DecisionDraftHelper.rebuildOptionIds(options);
    await _updateField('options', rebuilt);
  }

  Future<void> updateCriterion(int index, {String? name, int? weight}) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final criteria = _criteriaList(current.draft);
    if (index < 0 || index >= criteria.length) return;
    final criterion = Map<String, dynamic>.from(criteria[index]);
    if (name != null) criterion['name'] = name;
    if (weight != null) criterion['weight'] = weight.clamp(0, 100);
    criteria[index] = criterion;
    await _updateField('criteria', criteria);
  }

  Future<void> addCriterion() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final criteria = _criteriaList(current.draft);
    criteria.add({
      'id': 'crit_${criteria.length + 1}',
      'name': 'New Criterion',
      'weight': 0,
      'why_it_matters': '',
    });
    await _updateField('criteria', criteria);
  }

  Future<void> removeCriterion(int index) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final criteria = _criteriaList(current.draft);
    if (index <= 0 || index >= criteria.length) return;
    criteria.removeAt(index);
    await _updateField('criteria', criteria);
  }

  Future<void> rebalanceCriteriaWeights() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final criteria = _criteriaList(current.draft);
    if (criteria.isEmpty) return;
    final remainder = 100;
    final per = (remainder / criteria.length).floor();
    var running = 0;
    for (var i = 0; i < criteria.length; i += 1) {
      final weight = i == criteria.length - 1 ? remainder - running : per;
      criteria[i]['weight'] = weight;
      running += weight;
    }
    await _updateField('criteria', criteria);
  }

  Future<void> setOpportunityCosts(List<String> values) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    draft['opportunity_cost'] = {
      'foregone_options': values,
    };
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> setAssumptions(List<String> values) async {
    await _updateField('assumptions', values);
  }

  Future<void> setConstraints({double? capacityHours, bool? deadlineIsHard}) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    final existing = (draft['constraints'] as Map?)?.cast<String, dynamic>() ?? {};
    draft['constraints'] = {
      'available_capacity_hours': capacityHours ?? existing['available_capacity_hours'],
      'deadline_is_hard': deadlineIsHard ?? existing['deadline_is_hard'] ?? true,
    };
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> _updateField(String key, dynamic value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    draft[key] = value;
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> _updateAdequacy(String key, List<String> values) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final draft = Map<String, dynamic>.from(current.draft);
    final adequacy = (draft['adequacy_criteria'] as Map?)?.cast<String, dynamic>() ?? {
      'must_haves': <String>[],
      'deal_breakers': <String>[],
    };
    adequacy[key] = values;
    draft['adequacy_criteria'] = adequacy;
    await _saveDraft(current.record, draft, current.userContext);
  }

  Future<void> _saveDraft(
    DecisionDraft record,
    Map<String, dynamic> draft,
    UserContext? userContext,
  ) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final normalized = DecisionDraftHelper.ensureDraft(draft, userContext);
    record.dataJson = jsonEncode(normalized);
    record.updatedAt = DateTime.now();
    await repo.saveDecisionDraft(record);
    state = AsyncValue.data(
      DecisionDraftState(
        sessionId: record.sessionId ?? 0,
        draft: normalized,
        record: record,
        userContext: userContext,
      ),
    );
  }

  List<Map<String, dynamic>> _optionList(Map<String, dynamic> draft) {
    return (draft['options'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList() ?? [];
  }

  List<Map<String, dynamic>> _criteriaList(Map<String, dynamic> draft) {
    return (draft['criteria'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList() ?? [];
  }
}
