import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'decision_ai_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/decision_draft.dart';
import '../../../core/models/decision_event.dart';
import '../../../core/models/decision_matrix_record.dart';
import '../../../core/models/session.dart';
import '../../../core/models/user_context.dart';
import '../../../core/services/notification_service.dart';
import '../models/decision_matrix.dart';
import '../validation/decision_matrix_validator.dart';
import 'decision_prompt_builder.dart';
import 'decision_draft_helper.dart';
import 'decision_matrix_schema.dart';

part 'decision_protocol_service.g.dart';

@Riverpod(keepAlive: true)
DecisionProtocolService decisionProtocolService(DecisionProtocolServiceRef ref) {
  return DecisionProtocolService(ref);
}

class DecisionProtocolService {
  final DecisionProtocolServiceRef _ref;
  final DecisionPromptBuilder _promptBuilder = DecisionPromptBuilder();
  final DecisionMatrixValidator _validator = DecisionMatrixValidator();
  final DecisionAiClient _client = DecisionAiClient();
  static const Map<String, dynamic> _artifactGenerationConfig = {
    'temperature': 0.7,
    'max_output_tokens': 8192,
  };

  DecisionProtocolService(this._ref);

  Future<DecisionProtocolResponse> handleMessage({
    required String message,
    required Session session,
    required UserContext? userContext,
  }) async {
    final repo = _ref.read(localStorageRepositoryProvider);
    final draft = await repo.getDecisionDraftBySessionId(session.id);
    final existingDraft = DecisionDraftHelper.decodeDraft(draft?.dataJson);
    final seededDraft = DecisionDraftHelper.seedDraftFromMessage(message, existingDraft);
    final draftJson = jsonEncode(seededDraft);

    final intake = await _runIntake(
      message: message,
      userContext: userContext,
      draftJson: draftJson,
    );

    final updatedDraft = draft ?? DecisionDraft()..sessionId = session.id;
    updatedDraft.dataJson = jsonEncode(intake.draft);
    updatedDraft.missingFields = intake.missingFields;
    updatedDraft.updatedAt = DateTime.now();
    updatedDraft.events = _applyDraftEvents(
      updatedDraft.events,
      intake.draft,
    );
    await repo.saveDecisionDraft(updatedDraft);

    final readyForArtifact = DecisionDraftHelper.hasMinimumDraftForArtifact(intake.draft);
    if (intake.missingFields.isNotEmpty && !readyForArtifact) {
      return DecisionProtocolResponse(
        assistantMessage: intake.nextQuestions.join('\n'),
      );
    }

    final artifactResult = await _generateArtifact(
      draftJson: updatedDraft.dataJson ?? '{}',
      decisionIdOverride: const Uuid().v4(),
      userContext: userContext,
    );

    if (artifactResult == null) {
      return const DecisionProtocolResponse(
        assistantMessage: 'I could not generate a valid DecisionMatrix yet. Try again.',
      );
    }

    final draftMap = DecisionDraftHelper.decodeDraft(updatedDraft.dataJson);
    final draftErrors = _validateAgainstDraft(artifactResult, draftMap);
    final contextErrors = _validateAgainstContext(artifactResult, userContext);
    final repairErrors = [...draftErrors, ...contextErrors];
    if (repairErrors.isNotEmpty) {
      final repaired = await _repairArtifact(
        rawJson: jsonEncode(artifactResult.toJson()),
        errors: repairErrors,
        decisionId: artifactResult.decisionId,
        userContext: userContext,
      );
      if (repaired != null) {
        return _persistAndRespond(
          sessionId: session.id,
          draft: updatedDraft,
          matrix: repaired,
        );
      }
    }

    if (_needsDataGap(artifactResult)) {
      return DecisionProtocolResponse(
        assistantMessage: _dataGapMessage(),
      );
    }

    return _persistAndRespond(
      sessionId: session.id,
      draft: updatedDraft,
      matrix: artifactResult,
    );
  }

  Future<String> handleMessageStream({
    required String message,
    required Session session,
    required UserContext? userContext,
    required void Function(String delta) onDelta,
  }) async {
    final repo = _ref.read(localStorageRepositoryProvider);
    final draft = await repo.getDecisionDraftBySessionId(session.id);
    final existingDraft = (draft?.dataJson?.isNotEmpty ?? false)
        ? jsonDecode(draft!.dataJson!)
        : <String, dynamic>{};
    final seededDraft = DecisionDraftHelper.seedDraftFromMessage(message, existingDraft);
    final draftJson = jsonEncode(seededDraft);

    final intake = await _runIntake(
      message: message,
      userContext: userContext,
      draftJson: draftJson,
    );

    final updatedDraft = draft ?? DecisionDraft()..sessionId = session.id;
    updatedDraft.dataJson = jsonEncode(intake.draft);
    updatedDraft.missingFields = intake.missingFields;
    updatedDraft.updatedAt = DateTime.now();
    updatedDraft.events = _applyDraftEvents(
      updatedDraft.events,
      intake.draft,
    );
    await repo.saveDecisionDraft(updatedDraft);

    final readyForArtifact = DecisionDraftHelper.hasMinimumDraftForArtifact(intake.draft);
    if (intake.missingFields.isNotEmpty && !readyForArtifact) {
      return intake.nextQuestions.join('\n');
    }

    final prompt = _promptBuilder.buildArtifactPrompt(
      draftJson: updatedDraft.dataJson ?? '{}',
      userContext: userContext,
    );

    final buffer = StringBuffer();
    final stream = _client.streamTokens(
      prompt: prompt,
      generationConfig: _artifactGenerationConfig,
      includeEvents: false,
    );
    if (stream != null) {
      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        buffer.write(chunk);
        onDelta(chunk);
      }
    }
    var rawText = buffer.toString().trim();
    if (rawText.isEmpty) {
      rawText = (await _client.callOnce(
            prompt: prompt,
            generationConfig: _artifactGenerationConfig,
            logErrors: true,
          )) ??
          '';
    }
    final finalText = await _finalizeDecisionArtifact(
      rawText: rawText,
      updatedDraft: updatedDraft,
      userContext: userContext,
      sessionId: session.id,
      fallbackPrompt: prompt,
    );

    return finalText;
  }

  Future<String> generateFromDraftStream({
    required Map<String, dynamic> draftMap,
    required Session session,
    required UserContext? userContext,
    required void Function(String delta) onDelta,
  }) async {
    if (!DecisionDraftHelper.hasMinimumDraftForArtifact(draftMap)) {
      return 'Please complete the required decision inputs before generating the matrix.';
    }

    final repo = _ref.read(localStorageRepositoryProvider);
    final updatedDraft = (await repo.getDecisionDraftBySessionId(session.id)) ?? DecisionDraft()
      ..sessionId = session.id;
    updatedDraft.dataJson = jsonEncode(draftMap);
    updatedDraft.updatedAt = DateTime.now();
    updatedDraft.events = _applyDraftEvents(updatedDraft.events, draftMap);
    await repo.saveDecisionDraft(updatedDraft);

    final prompt = _promptBuilder.buildArtifactPrompt(
      draftJson: updatedDraft.dataJson ?? '{}',
      userContext: userContext,
    );

    final buffer = StringBuffer();
    final stream = _client.streamTokens(
      prompt: prompt,
      generationConfig: _artifactGenerationConfig,
      includeEvents: false,
    );
    if (stream != null) {
      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        buffer.write(chunk);
        onDelta(chunk);
      }
    }
    var rawText = buffer.toString().trim();
    if (rawText.isEmpty) {
      rawText = (await _client.callOnce(
            prompt: prompt,
            generationConfig: _artifactGenerationConfig,
            logErrors: true,
          )) ??
          '';
    }

    return _finalizeDecisionArtifact(
      rawText: rawText,
      updatedDraft: updatedDraft,
      userContext: userContext,
      sessionId: session.id,
      fallbackPrompt: prompt,
      preserveDraft: true,
    );
  }

  Future<DecisionReviewUpdate?> submitReview({
    required DecisionMatrixRecord record,
    required String outcome,
    required String notes,
  }) async {
    final prompt = _promptBuilder.buildReviewPrompt(
      decisionJson: record.rawJson ?? '{}',
      outcome: outcome,
      notes: notes,
    );
    final response = await _client.callOnce(prompt: prompt, responseFormat: const {'type': 'object'});
    if (response == null) return null;

    try {
      final data = jsonDecode(_extractJson(response));
      if (data is Map<String, dynamic>) {
        return DecisionReviewUpdate(
          summary: data['review_delta_summary']?.toString() ?? '',
          calibration: data['calibration_update']?.toString() ?? '',
          nextStep: data['next_step']?.toString() ?? '',
        );
      }
    } catch (e) {
      debugPrint('Decision review parse error: $e');
    }
    return null;
  }

  Future<_DecisionIntakeResult> _runIntake({
    required String message,
    required UserContext? userContext,
    required String draftJson,
  }) async {
    final draftMap = DecisionDraftHelper.decodeDraft(draftJson);
    if (DecisionDraftHelper.hasMinimumDraftForArtifact(draftMap)) {
      return _DecisionIntakeResult(
        missingFields: const [],
        nextQuestions: const [],
        draft: draftMap,
      );
    }
    final systemPrompt = _promptBuilder.buildSystemPrompt(userContext);
    final prompt = _promptBuilder.buildIntakePrompt(
      userMessage: message,
      draftJson: draftJson,
      userContext: userContext,
    );
    final response = await _client.callOnce(prompt: '$systemPrompt\n\n$prompt', responseFormat: const {'type': 'object'});
    if (response == null) {
      return _DecisionIntakeResult.fallback();
    }

    try {
      final data = jsonDecode(_extractJson(response));
      if (data is Map<String, dynamic>) {
        return _DecisionIntakeResult.fromJson(data);
      }
    } catch (e) {
      debugPrint('Decision intake parse error: $e');
    }
    return _DecisionIntakeResult.fallback();
  }

  List<String> _validateAgainstContext(DecisionMatrix matrix, UserContext? context) {
    final errors = <String>[];
    final criteriaNames = matrix.criteria.map((c) => c.name.toLowerCase()).toList();
    final hasExactNorthStar = matrix.criteria.any((c) => c.name.trim() == 'North Star Impact');
    if (!hasExactNorthStar) {
      errors.add('criteria must include exact name "North Star Impact"');
    }
    if (criteriaNames.any((name) => name.contains('north star') && name != 'north star impact')) {
      errors.add('north star criterion label must be exactly "North Star Impact" (no extra terms)');
    }
    if (!criteriaNames.any((name) => name.contains('execution'))) {
      errors.add('criteria must include an explicit Execution criterion');
    }
    final coreValues = context?.coreValues ?? [];
    for (final value in coreValues) {
      final lower = value.toLowerCase();
      final mapped = criteriaNames.any((name) => name.contains(lower));
      final assumption = matrix.recommendation.assumptions
          .any((a) => a.toLowerCase().contains(lower));
      if (!mapped && !assumption) {
        errors.add('core value "$value" must map to a criterion or be noted as not relevant');
      }
    }

    // Heuristic: foregone options should read like actions/allocations.
    final verbs = ['allocate', 'delay', 'defer', 'spend', 'skip', 'drop', 'postpone'];
    final hasAction = matrix.opportunityCost.foregoneOptions.any((item) {
      final text = item.toLowerCase();
      return verbs.any(text.contains);
    });
    if (!hasAction && matrix.opportunityCost.foregoneOptions.isNotEmpty) {
      errors.add('opportunity_cost items must be phrased as actions/allocations (e.g., "Allocate 6 hours to X")');
    }

    if (matrix.adequacyCriteria.mustHaves.length < 2) {
      errors.add('adequacy_criteria.must_haves must include a capacity/time constraint');
    }

    final allAssumptionsPrefixed = matrix.recommendation.assumptions.every(
      (a) => a.toLowerCase().startsWith('assumed:'),
    );
    if (!allAssumptionsPrefixed && matrix.recommendation.assumptions.isNotEmpty) {
      errors.add('all recommendation.assumptions must be prefixed with "assumed:"');
    }

    return errors;
  }

  List<String> _validateAgainstDraft(
    DecisionMatrix matrix,
    Map<String, dynamic> draft,
  ) {
    final errors = <String>[];

    final draftDeadline = draft['decision_deadline']?.toString();
    if (draftDeadline != null && draftDeadline.isNotEmpty) {
      if (matrix.decisionDeadline != draftDeadline) {
        errors.add('decision_deadline must match draft value');
      }
    }

    final draftReview = draft['review_date']?.toString();
    if (draftReview != null && draftReview.isNotEmpty) {
      if (matrix.review.reviewDate != draftReview) {
        errors.add('review.review_date must match draft value');
      }
    }

    final draftFirstAction = draft['first_action_due']?.toString();
    if (draftFirstAction != null && draftFirstAction.isNotEmpty) {
      if (matrix.commitment.firstActionDue != draftFirstAction) {
        errors.add('commitment.first_action_due must match draft value');
      }
    }

    final draftAdequacy = draft['adequacy_criteria'];
    if (draftAdequacy is Map) {
      final mustHaves = (draftAdequacy['must_haves'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          <String>[];
      final dealBreakers = (draftAdequacy['deal_breakers'] as List?)
              ?.map((e) => e.toString())
              .where((e) => e.isNotEmpty)
              .toList() ??
          <String>[];

      for (final item in mustHaves) {
        if (!matrix.adequacyCriteria.mustHaves.contains(item)) {
          errors.add('adequacy_criteria.must_haves must include draft item: $item');
        }
      }
      for (final item in dealBreakers) {
        if (!matrix.adequacyCriteria.dealBreakers.contains(item)) {
          errors.add('adequacy_criteria.deal_breakers must include draft item: $item');
        }
      }

      final extraMustHaves = matrix.adequacyCriteria.mustHaves
          .where((e) => !mustHaves.contains(e))
          .toList();
      final extraDealBreakers = matrix.adequacyCriteria.dealBreakers
          .where((e) => !dealBreakers.contains(e))
          .toList();

      for (final extra in [...extraMustHaves, ...extraDealBreakers]) {
        final assumed = matrix.recommendation.assumptions
            .any((a) => a.toLowerCase().contains(extra.toLowerCase()));
        if (!assumed) {
          errors.add('inferred adequacy constraint must be in assumptions: $extra');
        }
      }
    }

    return errors;
  }

  // Draft parsing helpers moved to decision_draft_helper.dart

  Future<DecisionMatrix?> _generateArtifact({
    required String draftJson,
    required String decisionIdOverride,
    required UserContext? userContext,
  }) async {
    final prompt = _promptBuilder.buildArtifactPrompt(
      draftJson: draftJson,
      userContext: userContext,
    );
    var response = await _client.callOnce(
      prompt: prompt,
      responseFormat: decisionMatrixResponseFormat,
      generationConfig: _artifactGenerationConfig,
    );
    if (response == null) return null;

    var jsonText = _extractJson(response);
    DecisionMatrix? matrix;

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final data = jsonDecode(jsonText);
        if (data is Map<String, dynamic>) {
          data['decision_id'] = decisionIdOverride;
          data['schema_version'] ??= '1.0';
          data['type'] ??= 'decision_matrix';
          matrix = DecisionMatrix.fromJson(data);
          final result = _validator.validate(matrix);
          if (result.isValid) {
            return matrix;
          }
          if (attempt == 2) break;
          final repairPrompt = _promptBuilder.buildRepairPrompt(
            rawJson: jsonEncode(data),
            errors: result.errors,
          );
          response = await _client.callOnce(
            prompt: repairPrompt,
            responseFormat: decisionMatrixResponseFormat,
            generationConfig: _artifactGenerationConfig,
          );
          if (response == null) break;
          jsonText = _extractJson(response);
        }
      } catch (e) {
        debugPrint('Decision matrix parse error: $e');
        break;
      }
    }

    return null;
  }

  Future<String> _finalizeDecisionArtifact({
    required String rawText,
    required DecisionDraft updatedDraft,
    required UserContext? userContext,
    required int sessionId,
    required String fallbackPrompt,
    bool preserveDraft = false,
  }) async {
    DecisionMatrix? matrix;
    final extracted = _extractJson(rawText);
    if (_isLikelyCompleteJson(extracted)) {
      try {
        final data = jsonDecode(extracted);
        if (data is Map<String, dynamic>) {
          data['schema_version'] ??= '1.1.0';
          data['type'] ??= 'decision_matrix';
          data['decision_id'] ??= const Uuid().v4();
          matrix = DecisionMatrix.fromJson(data);
        }
      } catch (e) {
        debugPrint('Decision stream parse error: $e');
      }
    }

    if (matrix == null) {
      final fallback = await _client.callOnce(
        prompt: fallbackPrompt,
        responseFormat: decisionMatrixResponseFormat,
        generationConfig: _artifactGenerationConfig,
      );
      if (fallback != null) {
        try {
          final data = jsonDecode(_extractJson(fallback));
          if (data is Map<String, dynamic>) {
            data['schema_version'] ??= '1.1.0';
            data['type'] ??= 'decision_matrix';
            data['decision_id'] ??= const Uuid().v4();
            matrix = DecisionMatrix.fromJson(data);
          }
        } catch (_) {}
      }
    }

    if (matrix == null) {
      return rawText.isNotEmpty ? rawText : 'I could not generate a valid DecisionMatrix yet. Try again.';
    }

    final validation = _validator.validate(matrix);
    if (!validation.isValid) {
      final repaired = await _repairArtifact(
        rawJson: jsonEncode(matrix.toJson()),
        errors: validation.errors,
        decisionId: matrix.decisionId,
        userContext: userContext,
      );
      if (repaired != null) {
        matrix = repaired;
      }
    }

    final draftMap = jsonDecode(updatedDraft.dataJson ?? '{}') as Map<String, dynamic>;
    final repairErrors = [
      ..._validateAgainstDraft(matrix, draftMap),
      ..._validateAgainstContext(matrix, userContext),
    ];

    if (repairErrors.isNotEmpty) {
      final repaired = await _repairArtifact(
        rawJson: jsonEncode(matrix.toJson()),
        errors: repairErrors,
        decisionId: matrix.decisionId,
        userContext: userContext,
      );
      if (repaired != null) {
        matrix = repaired;
      }
    }

    final response = _persistAndRespond(
      sessionId: sessionId,
      draft: updatedDraft,
      matrix: matrix,
      preserveDraft: preserveDraft,
    );

    return response.assistantMessage;
  }


  Future<DecisionMatrix?> _repairArtifact({
    required String rawJson,
    required List<String> errors,
    required String decisionId,
    required UserContext? userContext,
  }) async {
    final repairPrompt = _promptBuilder.buildRepairPrompt(
      rawJson: rawJson,
      errors: errors,
    );
    final response = await _client.callOnce(
      prompt: repairPrompt,
      responseFormat: decisionMatrixResponseFormat,
      generationConfig: _artifactGenerationConfig,
    );
    if (response == null) return null;
    try {
      final data = jsonDecode(_extractJson(response));
      if (data is Map<String, dynamic>) {
        data['decision_id'] = decisionId;
        data['schema_version'] ??= '1.1.0';
        data['type'] ??= 'decision_matrix';
        final matrix = DecisionMatrix.fromJson(data);
        final validation = _validator.validate(matrix);
        if (validation.isValid) {
          final contextErrors = _validateAgainstContext(matrix, userContext);
          if (contextErrors.isEmpty) return matrix;
        }
      }
    } catch (e) {
      debugPrint('Decision repair parse error: $e');
    }
    return null;
  }

  DecisionProtocolResponse _persistAndRespond({
    required int sessionId,
    required DecisionDraft draft,
    required DecisionMatrix matrix,
    bool preserveDraft = false,
  }) {
    final repo = _ref.read(localStorageRepositoryProvider);
    final record = _buildDecisionRecord(
      sessionId: sessionId,
      rawJson: jsonEncode(matrix.toJson()),
      matrix: matrix,
      draftEvents: draft.events,
    );

    repo.saveDecisionMatrix(record);
    if (!preserveDraft) {
      repo.deleteDecisionDraftBySessionId(sessionId);
    }
    _scheduleReminders(record);

    return DecisionProtocolResponse(
      assistantMessage: jsonEncode({
        'type': 'decision_matrix',
        ...matrix.toJson(),
      }),
    );
  }

  // Gemini client methods moved to decision_ai_client.dart

  List<DecisionEvent> _applyDraftEvents(
    List<DecisionEvent> existing,
    Map<String, dynamic> draft,
  ) {
    final events = List<DecisionEvent>.from(existing);
    void ensure(String type) {
      if (events.any((e) => e.type == type)) return;
      events.add(DecisionEvent()
        ..type = type
        ..occurredAt = DateTime.now());
    }

    if ((draft['decision_title'] ?? '').toString().isNotEmpty ||
        (draft['problem_frame'] ?? '').toString().isNotEmpty) {
      ensure('decision_framed');
    }
    if (draft['reversibility'] != null) ensure('reversibility_audited');
    if (draft['adequacy_criteria'] != null) ensure('adequacy_defined');
    if (draft['options'] is List) ensure('options_enumerated');
    if (draft['criteria'] is List) ensure('criteria_defined');
    if (draft['criteria'] is List && (draft['criteria'] as List).isNotEmpty) {
      ensure('criteria_weighted');
    }
    if (draft['scores'] is List) ensure('scores_completed');
    if (draft['tradeoff_audit'] is List) ensure('tradeoff_audited');
    if (draft['recommendation'] != null) ensure('recommendation_generated');
    if (draft['commitment'] != null) {
      ensure('choice_locked');
      ensure('first_action_set');
      ensure('implementation_intentions_set');
    }
    if (draft['review'] != null) ensure('review_scheduled');

    return events;
  }

  DecisionMatrixRecord _buildDecisionRecord({
    required int sessionId,
    required String rawJson,
    required DecisionMatrix matrix,
    required List<DecisionEvent> draftEvents,
  }) {
    final record = DecisionMatrixRecord()
      ..decisionId = matrix.decisionId
      ..sessionId = sessionId
      ..title = matrix.decisionTitle
      ..protocolLabel = 'Decision Protocol'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..rawJson = rawJson
      ..firstActionDue = _parseDateTime(matrix.commitment.firstActionDue)
      ..reviewDate = _parseDateTime(matrix.review.reviewDate)
      ..events = [
        ...draftEvents,
        DecisionEvent()
          ..type = 'artifact_persisted'
          ..occurredAt = DateTime.now()
      ];

    return record;
  }

  bool _needsDataGap(DecisionMatrix matrix) {
    return matrix.reversibility.type == 'two_way_door' &&
        matrix.recommendation.confidence < 0.70;
  }

  String _dataGapMessage() {
    return 'Confidence is below 0.70 for a two-way door. '
        'Collect 2–3 quick facts before locking this:\n'
        '- Talk to a domain expert\n'
        '- Look up comparable outcomes\n'
        '- Run a small experiment\n'
        'Reply with what you find.';
  }

  Future<void> _scheduleReminders(DecisionMatrixRecord record) async {
    final notifications = _ref.read(notificationServiceProvider);
    if (record.firstActionDue != null) {
      await notifications.scheduleDecisionReminder(
        id: record.firstActionDue!.millisecondsSinceEpoch % 100000,
        title: 'First Action Due',
        body: record.title ?? 'Decision first action',
      );
    }
    if (record.reviewDate != null) {
      await notifications.scheduleDecisionReminder(
        id: record.reviewDate!.millisecondsSinceEpoch % 100000,
        title: 'Decision Review',
        body: record.title ?? 'Decision review',
      );
    }
  }

  DateTime? _parseDateTime(String value) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  String _extractJson(String text) {
    if (text.contains('```json')) {
      final start = text.indexOf('```json') + 7;
      final end = text.lastIndexOf('```');
      return text.substring(start, end).trim();
    }
    return text.trim();
  }

  bool _isLikelyCompleteJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) return false;
    var depth = 0;
    var inString = false;
    for (var i = start; i <= end; i += 1) {
      final char = text[i];
      if (char == '"' && (i == 0 || text[i - 1] != '\\')) {
        inString = !inString;
      }
      if (inString) continue;
      if (char == '{') depth += 1;
      if (char == '}') depth -= 1;
    }
    return depth == 0 && !inString;
  }
}

class DecisionProtocolResponse {
  final String assistantMessage;

  const DecisionProtocolResponse({required this.assistantMessage});
}

class DecisionReviewUpdate {
  final String summary;
  final String calibration;
  final String nextStep;

  const DecisionReviewUpdate({
    required this.summary,
    required this.calibration,
    required this.nextStep,
  });
}

class _DecisionIntakeResult {
  final List<String> missingFields;
  final List<String> nextQuestions;
  final Map<String, dynamic> draft;

  _DecisionIntakeResult({
    required this.missingFields,
    required this.nextQuestions,
    required this.draft,
  });

  factory _DecisionIntakeResult.fromJson(Map<String, dynamic> json) {
    return _DecisionIntakeResult(
      missingFields: _stringList(json['missing_fields']),
      nextQuestions: _stringList(json['next_questions']),
      draft: (json['draft'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
    );
  }

  factory _DecisionIntakeResult.fallback() {
    return _DecisionIntakeResult(
      missingFields: const ['decision_title', 'reversibility', 'adequacy_criteria'],
      nextQuestions: const [
        'What decision are you making?',
        'Is this reversible (two-way door) or irreversible (one-way door)?',
        'What are your must-haves and deal-breakers?'
      ],
      draft: <String, dynamic>{},
    );
  }
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
  }
  return <String>[];
}
