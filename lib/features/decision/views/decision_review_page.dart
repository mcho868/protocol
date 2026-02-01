import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/decision_event.dart';
import '../../../core/models/decision_matrix_record.dart';
import '../../../core/models/decision_outcome.dart';
import '../services/decision_protocol_service.dart';

class DecisionReviewPage extends ConsumerStatefulWidget {
  final String decisionId;

  const DecisionReviewPage({super.key, required this.decisionId});

  @override
  ConsumerState<DecisionReviewPage> createState() => _DecisionReviewPageState();
}

class _DecisionReviewPageState extends ConsumerState<DecisionReviewPage> {
  final _notesController = TextEditingController();
  DecisionOutcome _outcome = DecisionOutcome.success;
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REVIEW OUTCOME')),
      body: FutureBuilder<DecisionMatrixRecord?>(
        future: _loadRecord(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final record = snapshot.data;
          if (record == null) {
            return const Center(child: Text('Decision not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title?.toUpperCase() ?? 'DECISION',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<DecisionOutcome>(
                  value: _outcome,
                  items: DecisionOutcome.values
                      .where((o) => o != DecisionOutcome.pending)
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(value.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _outcome = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'What happened? Be specific.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (record.calibrationSummary != null && record.calibrationSummary!.isNotEmpty)
                  Text(
                    record.calibrationSummary!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : () => _save(record),
                    child: Text(_saving ? 'SAVING...' : 'SAVE REVIEW'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<DecisionMatrixRecord?> _loadRecord() async {
    final repo = ref.read(localStorageRepositoryProvider);
    return repo.getDecisionMatrixByDecisionId(widget.decisionId);
  }

  Future<void> _save(DecisionMatrixRecord record) async {
    setState(() => _saving = true);
    final repo = ref.read(localStorageRepositoryProvider);
    record.outcome = _outcome;
    record.reviewNotes = _notesController.text.trim();
    record.lastReviewedAt = DateTime.now();
    record.events = [
      ...record.events,
      DecisionEvent()
        ..type = 'review_outcome_recorded'
        ..occurredAt = DateTime.now()
    ];

    final update = await ref.read(decisionProtocolServiceProvider).submitReview(
          record: record,
          outcome: _outcome.label,
          notes: record.reviewNotes ?? '',
        );
    if (update != null) {
      record.calibrationSummary = update.calibration;
      record.nextStep = update.nextStep;
    }

    await repo.updateDecisionMatrix(record);
    if (!mounted) return;
    if (update != null) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Review Update'),
          content: Text(
            '${update.summary}\n\n${update.calibration}\n\nNext: ${update.nextStep}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }
}
