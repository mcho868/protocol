import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/session.dart';
import '../../session/providers/session_provider.dart';
import '../providers/decision_draft_provider.dart';
import 'draft/decision_options_step.dart';
import 'draft/decision_criteria_step.dart';
import 'draft/decision_opportunity_step.dart';
import 'draft/decision_review_step.dart';
import '../utils/date_format.dart';
import '../models/decision_matrix.dart';
import '../views/decision_matrix_view.dart';

class DecisionDraftChat extends ConsumerStatefulWidget {
  final Session session;

  const DecisionDraftChat({super.key, required this.session});

  @override
  ConsumerState<DecisionDraftChat> createState() => _DecisionDraftChatState();
}

class _DecisionDraftChatState extends ConsumerState<DecisionDraftChat> {
  int _stepIndex = 0;
  int _lastPromptedStep = -1;
  bool _isPrompting = false;
  bool _isGenerating = false;
  final _decisionController = TextEditingController();
  final _mustHaveController = TextEditingController();

  @override
  void dispose() {
    _decisionController.dispose();
    _mustHaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxInputHeight = MediaQuery.of(context).size.height * 0.45;
    final draftAsync = ref.watch(decisionDraftControllerProvider(widget.session.id));

    return draftAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Failed to load draft: $err')),
      data: (state) {
        final draft = state.draft;
        final session = widget.session;
        final options = (draft['options'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList() ?? [];
        final criteria = (draft['criteria'] as List?)?.map((e) => (e as Map).cast<String, dynamic>()).toList() ?? [];
        final includeStatusQuo = options.any(
          (o) => (o['name'] ?? '').toString().toLowerCase().contains('status quo'),
        );
        final opportunityCosts = ((draft['opportunity_cost'] as Map?)?['foregone_options'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[];
        final assumptions = (draft['assumptions'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
        final constraints = (draft['constraints'] as Map?)?.cast<String, dynamic>() ?? {};
        final capacity = constraints['available_capacity_hours'] as num?;
        final deadlineIsHard = constraints['deadline_is_hard'] as bool? ?? true;

        final introDone = draft['intro_done'] == true;
        if (!introDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await ref.read(sessionControllerProvider.notifier).appendModelMessage(
                  session.id,
                  'Let’s work through a decision together.',
                );
            await ref.read(sessionControllerProvider.notifier).appendModelMessage(
                  session.id,
                  'This process will help you move from uncertainty to action, using your values and your North Star.',
                );
            await ref.read(sessionControllerProvider.notifier).appendModelMessage(
                  session.id,
                  'We’ll take this step by step.',
                );
            await ref.read(sessionControllerProvider.notifier).appendModelMessage(
                  session.id,
                  _promptForStep(0) ?? 'First — what decision are you trying to make?',
                );
            await ref
                .read(decisionDraftControllerProvider(session.id).notifier)
                .updateDraft({...draft, 'intro_done': true, 'chat_prompt_step': 0});
          });
        } else {
        _stepIndex = _computeStep(draft);
        _ensurePrompts(session, draft);
        }

        final draftTitle = (draft['decision_title'] ?? '').toString();
        if (_decisionController.text != draftTitle) {
          _decisionController.text = draftTitle;
        }

        final showDraftOptionsBubble = _stepIndex == 1;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: session.history.length + (showDraftOptionsBubble ? 1 : 0),
                itemBuilder: (context, index) {
                  if (showDraftOptionsBubble && index == session.history.length) {
                    return _UserDraftOptionsBubble(sessionId: session.id);
                  }
                  final message = session.history[index];
                  return _ChatMessageWidget(message: message);
                },
              ),
            ),
            _ChatInputPanel(
              maxHeight: maxInputHeight,
              child: _buildStepInput(
                draft: draft,
                options: options,
                criteria: criteria,
                includeStatusQuo: includeStatusQuo,
                opportunityCosts: opportunityCosts,
                assumptions: assumptions,
                capacity: capacity?.toDouble(),
                deadlineIsHard: deadlineIsHard,
              ),
              onPrimary: _stepIndex >= 7 ? () => _generateMatrix(context, draft) : () => _handlePrimary(draft),
              isGenerating: _isGenerating,
              isLast: _stepIndex >= 7,
            ),
          ],
        );
      },
    );
  }

  void _ensurePrompts(Session session, Map<String, dynamic> draft) {
    if (draft['intro_done'] != true) return;
    final storedPromptStep = (draft['chat_prompt_step'] as int?) ?? -1;
    if (storedPromptStep >= 1 && _stepIndex == 1) {
      return;
    }
    if (_lastPromptedStep == _stepIndex || storedPromptStep == _stepIndex || _isPrompting) {
      return;
    }
    final prompt = _promptForStep(_stepIndex);
    if (prompt == null) return;
    _isPrompting = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final last = session.history.isNotEmpty ? session.history.last.text?.trim() : '';
      if (last == prompt.trim()) {
        _isPrompting = false;
        return;
      }
      await ref.read(sessionControllerProvider.notifier).appendModelMessage(
            session.id,
            prompt,
          );
      await ref
          .read(decisionDraftControllerProvider(session.id).notifier)
          .updateDraft({...draft, 'chat_prompt_step': _stepIndex});
      _lastPromptedStep = _stepIndex;
      _isPrompting = false;
    });
  }

  Widget _buildStepInput({
    required Map<String, dynamic> draft,
    required List<Map<String, dynamic>> options,
    required List<Map<String, dynamic>> criteria,
    required bool includeStatusQuo,
    required List<String> opportunityCosts,
    required List<String> assumptions,
    required double? capacity,
    required bool deadlineIsHard,
  }) {
    switch (_stepIndex) {
      case 0:
        return TextField(
          controller: _decisionController,
          minLines: 1,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Type the decision here…',
            border: OutlineInputBorder(),
          ),
        );
      case 1:
        return const SizedBox.shrink();
      case 2:
        final deadlineIso = (draft['decision_deadline'] ?? '').toString();
        return _DeadlinePicker(
          value: deadlineIso,
          onPick: (value) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setDecisionDeadline(value),
        );
      case 3:
        final reversibility = (draft['reversibility'] as Map?)?['type']?.toString() ?? 'two_way_door';
        return ToggleButtons(
          isSelected: [reversibility == 'two_way_door', reversibility == 'one_way_door'],
          onPressed: (index) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setReversibility(index == 0 ? 'two_way_door' : 'one_way_door'),
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
        );
      case 4:
        return _MustHaveInput(
          controller: _mustHaveController,
          draft: draft,
          onUpdate: (values) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setMustHaves(values),
        );
      case 5:
        return DecisionCriteriaStep(
          criteria: criteria,
          onAddCriterion: () => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .addCriterion(),
          onRemoveCriterion: (index) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .removeCriterion(index),
          onNameChanged: (index, value) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .updateCriterion(index, name: value),
          onWeightChanged: (index, value) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .updateCriterion(index, weight: value),
          onRebalance: () => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .rebalanceCriteriaWeights(),
        );
      case 6:
        return DecisionOpportunityStep(
          opportunityCosts: opportunityCosts,
          assumptions: assumptions,
          capacityHours: capacity,
          deadlineIsHard: deadlineIsHard,
          onOpportunityChanged: (value) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setOpportunityCosts(value),
          onAssumptionsChanged: (value) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setAssumptions(value),
          onConstraintsChanged: (hours, deadline) => ref
              .read(decisionDraftControllerProvider(widget.session.id).notifier)
              .setConstraints(capacityHours: hours, deadlineIsHard: deadline),
        );
      default:
        return DecisionReviewStep(
          validationErrors: const [],
          isGenerating: _isGenerating,
          onGenerate: () => _generateMatrix(context, draft),
        );
    }
  }

  int _computeStep(Map<String, dynamic> draft) {
    final title = (draft['decision_title'] ?? '').toString().trim();
    if (title.isEmpty) return 0;

    final optionCount = (draft['options'] as List?)
            ?.where((o) => (o as Map)['name']?.toString().trim().isNotEmpty ?? false)
            .length ??
        0;
    if (optionCount < 3) return 1;

    final deadline = (draft['decision_deadline'] ?? '').toString().trim();
    if (deadline.isEmpty) return 2;

    final reversibility = (draft['reversibility'] as Map?)?['type']?.toString();
    if (reversibility == null || reversibility.isEmpty) return 3;

    final adequacy = (draft['adequacy_criteria'] as Map?) ?? {};
    final mustHaves = (adequacy['must_haves'] as List?)
            ?.where((e) => e.toString().trim().isNotEmpty)
            .toList() ??
        <dynamic>[];
    if (mustHaves.isEmpty) return 4;

    final criteria = (draft['criteria'] as List?) ?? [];
    final weightSum = criteria.fold<int>(
      0,
      (sum, c) => sum + (int.tryParse((c as Map)['weight'].toString()) ?? 0),
    );
    if (criteria.isEmpty || weightSum != 100) return 5;

    final confirmed = draft['opportunity_confirmed'] == true;
    return confirmed ? 7 : 6;
  }

  Future<void> _handlePrimary(Map<String, dynamic> draft) async {
    if (_stepIndex < 6 && !_canContinue(draft)) return;

    switch (_stepIndex) {
      case 0:
        final text = _decisionController.text.trim();
        if (text.isEmpty) return;
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .setDecisionTitle(text);
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              text,
            );
        await ref.read(sessionControllerProvider.notifier).appendModelMessage(
              widget.session.id,
              'Now let’s look at the choices involved.',
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 0});
        break;
      case 1:
        final options = (draft['options'] as List?)
                ?.map((o) => (o as Map)['name']?.toString() ?? '')
                .where((e) => e.trim().isNotEmpty)
                .toList() ??
            [];
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              '[OPTIONS_UI]',
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 1});
        break;
      case 2:
        final deadlineIso = (draft['decision_deadline'] ?? '').toString();
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              formatDecisionDate(deadlineIso),
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 2});
        break;
      case 3:
        final reversibility = (draft['reversibility'] as Map?)?['type']?.toString() ?? '';
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              reversibility,
            );
        await ref.read(sessionControllerProvider.notifier).appendModelMessage(
              widget.session.id,
              reversibility == 'two_way_door'
                  ? 'Okay. That means we can prioritize speed and learning.'
                  : 'Understood. That means we’ll be more deliberate.',
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 3});
        break;
      case 4:
        final adequacy = (draft['adequacy_criteria'] as Map?) ?? {};
        final mustHaves = (adequacy['must_haves'] as List?)?.join(', ') ?? '';
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              mustHaves,
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 4});
        break;
      case 5:
        final criteria = (draft['criteria'] as List?)
                ?.map((c) => (c as Map)['name']?.toString() ?? '')
                .where((e) => e.trim().isNotEmpty)
                .toList() ??
            [];
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              criteria.join(', '),
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 5});
        break;
      case 6:
        await ref.read(sessionControllerProvider.notifier).appendUserMessage(
              widget.session.id,
              'Opportunity costs / assumptions captured.',
            );
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({
          ...draft,
          'opportunity_confirmed': true,
        });
        await ref
            .read(decisionDraftControllerProvider(widget.session.id).notifier)
            .updateDraft({...draft, 'chat_prompt_step': 6});
        break;
      default:
        break;
    }

    setState(() {
      _stepIndex = _computeStep(draft);
    });
  }

  bool _canContinue(Map<String, dynamic> draft) {
    switch (_stepIndex) {
      case 0:
        return _decisionController.text.trim().isNotEmpty;
      case 1:
        final count = (draft['options'] as List?)
                ?.where((o) => (o as Map)['name']?.toString().trim().isNotEmpty ?? false)
                .length ??
            0;
        return count >= 3;
      case 2:
        return (draft['decision_deadline'] ?? '').toString().trim().isNotEmpty;
      case 3:
        final reversibility = (draft['reversibility'] as Map?)?['type']?.toString();
        return reversibility != null && reversibility.isNotEmpty;
      case 4:
        final adequacy = (draft['adequacy_criteria'] as Map?) ?? {};
        final mustHaves = (adequacy['must_haves'] as List?)
                ?.where((e) => e.toString().trim().isNotEmpty)
                .toList() ??
            <dynamic>[];
        return mustHaves.isNotEmpty;
      case 5:
        final criteria = (draft['criteria'] as List?) ?? [];
        final weightSum = criteria.fold<int>(
          0,
          (sum, c) => sum + (int.tryParse((c as Map)['weight'].toString()) ?? 0),
        );
        return criteria.isNotEmpty && weightSum == 100;
      default:
        return true;
    }
  }

  String? _promptForStep(int step) {
    switch (step) {
      case 0:
        return 'First — what decision are you trying to make?';
      case 1:
        return 'What options are you currently considering?\n\nYou can start with what’s obvious. We can refine later.';
      case 2:
        return 'By when does this decision need to be acted on?\n\nA clear deadline keeps this from dragging.';
      case 3:
        return 'Is this decision reversible?\n\nIn other words: is it a two-way door, or a one-way door?';
      case 4:
        return 'What must be true for this decision to count as a success?\n\nThis sets the minimum bar. Anything below it fails.';
      case 5:
        return 'Now let’s decide how we’ll evaluate the options.\n\nYour values and your North Star will be included here.';
      case 6:
        return 'Choosing one option means not choosing others.\n\nWhat are you giving up by committing to this?\n\nAnd are there any assumptions we’re making?';
      case 7:
        return 'All inputs are in.\n\nWhen you generate, this will result in a clear recommendation and a first action.';
      default:
        return 'Ready to generate the Decision Matrix.';
    }
  }

  Future<void> _generateMatrix(BuildContext context, Map<String, dynamic> draft) async {
    setState(() => _isGenerating = true);
    try {
      await ref.read(sessionControllerProvider.notifier).generateDecisionMatrix(
            widget.session.id,
            jsonDecode(jsonEncode(draft)) as Map<String, dynamic>,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Decision Matrix generated.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}

class _ChatMessageWidget extends StatelessWidget {
  const _ChatMessageWidget({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final text = message.text ?? '';

    Widget content;
    if (isUser && text.trim() == '[OPTIONS_UI]') {
      content = _UserOptionsBubble();
    } else if (!isUser && _isJson(text)) {
      try {
        final data = jsonDecode(_extractJson(text));
        if (data is Map<String, dynamic> &&
            (data['type'] == 'decision_matrix' ||
                (data.containsKey('decision_id') && data.containsKey('criteria')))) {
          content = DecisionMatrixView(matrix: DecisionMatrix.fromJson(data));
        } else {
          content = _buildDefaultMarkdown(text, isUser);
        }
      } catch (_) {
        content = _buildDefaultMarkdown(text, isUser);
      }
    } else {
      content = _buildDefaultMarkdown(text, isUser);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isUser ? 'YOU' : 'PROTOCOL',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildDefaultMarkdown(String text, bool isUser) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  bool _isJson(String text) {
    return text.contains('```json') || (text.trim().startsWith('{') && text.trim().endsWith('}'));
  }

  String _extractJson(String text) {
    if (text.contains('```json')) {
      final start = text.indexOf('```json') + 7;
      final end = text.lastIndexOf('```');
      return text.substring(start, end).trim();
    }
    return text.trim();
  }
}

class _UserOptionsBubble extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = context.findAncestorStateOfType<_DecisionDraftChatState>();
    if (chat == null) {
      return const SizedBox.shrink();
    }
    final draftAsync = ref.watch(decisionDraftControllerProvider(chat.widget.session.id));
    return draftAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) {
        final draft = state.draft;
        final options = (draft['options'] as List?)
                ?.map((e) => (e as Map).cast<String, dynamic>())
                .toList() ??
            [];
        final includeStatusQuo = options.any(
          (o) => (o['name'] ?? '').toString().toLowerCase().contains('status quo'),
        );
        return DecisionOptionsStep(
          options: options,
          includeStatusQuo: includeStatusQuo,
          onNameChanged: (index, value) => ref
              .read(decisionDraftControllerProvider(chat.widget.session.id).notifier)
              .updateOption(index, name: value),
          onDescriptionChanged: (index, value) => ref
              .read(decisionDraftControllerProvider(chat.widget.session.id).notifier)
              .updateOption(index, description: value),
          onAddOption: () => ref
              .read(decisionDraftControllerProvider(chat.widget.session.id).notifier)
              .addOption(),
          onRemoveOption: (index) => ref
              .read(decisionDraftControllerProvider(chat.widget.session.id).notifier)
              .removeOption(index),
          onToggleStatusQuo: (value) => ref
              .read(decisionDraftControllerProvider(chat.widget.session.id).notifier)
              .toggleStatusQuo(value),
        );
      },
    );
  }
}

class _UserDraftOptionsBubble extends ConsumerWidget {
  final int sessionId;

  const _UserDraftOptionsBubble({required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(decisionDraftControllerProvider(sessionId));
    return draftAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) {
        final draft = state.draft;
        final options = (draft['options'] as List?)
                ?.map((e) => (e as Map).cast<String, dynamic>())
                .toList() ??
            [];
        final includeStatusQuo = options.any(
          (o) => (o['name'] ?? '').toString().toLowerCase().contains('status quo'),
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'YOU',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: DecisionOptionsStep(
                  options: options,
                  includeStatusQuo: includeStatusQuo,
                  onNameChanged: (index, value) => ref
                      .read(decisionDraftControllerProvider(sessionId).notifier)
                      .updateOption(index, name: value),
                  onDescriptionChanged: (index, value) => ref
                      .read(decisionDraftControllerProvider(sessionId).notifier)
                      .updateOption(index, description: value),
                  onAddOption: () => ref
                      .read(decisionDraftControllerProvider(sessionId).notifier)
                      .addOption(),
                  onRemoveOption: (index) => ref
                      .read(decisionDraftControllerProvider(sessionId).notifier)
                      .removeOption(index),
                  onToggleStatusQuo: (value) => ref
                      .read(decisionDraftControllerProvider(sessionId).notifier)
                      .toggleStatusQuo(value),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatInputPanel extends StatelessWidget {
  final Widget child;
  final VoidCallback onPrimary;
  final bool isGenerating;
  final bool isLast;
  final double maxHeight;

  const _ChatInputPanel({
    required this.child,
    required this.onPrimary,
    required this.isGenerating,
    required this.isLast,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1))),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLast ? (isGenerating ? null : onPrimary) : onPrimary,
                  child: isLast
                      ? (isGenerating
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Generate Decision Matrix'))
                      : const Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeadlinePicker extends StatelessWidget {
  final String value;
  final ValueChanged<DateTime> onPick;

  const _DeadlinePicker({required this.value, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Text(
              value.isEmpty ? 'Select a deadline' : formatDecisionDate(value),
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
    onPick(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}

class _MustHaveInput extends StatelessWidget {
  final Map<String, dynamic> draft;
  final ValueChanged<List<String>> onUpdate;
  final TextEditingController controller;

  const _MustHaveInput({
    required this.draft,
    required this.onUpdate,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final adequacy = (draft['adequacy_criteria'] as Map?) ?? {};
    final mustHaves = (adequacy['must_haves'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Add a must-have constraint',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isEmpty) return;
            onUpdate([...mustHaves, value.trim()]);
            controller.clear();
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < mustHaves.length; i += 1)
              Chip(
                label: Text(mustHaves[i]),
                onDeleted: () {
                  final updated = [...mustHaves]..removeAt(i);
                  onUpdate(updated);
                },
              ),
          ],
        ),
      ],
    );
  }
}
