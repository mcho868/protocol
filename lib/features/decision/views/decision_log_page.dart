import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/decision_outcome.dart';
import '../providers/decision_log_provider.dart';
import 'decision_review_page.dart';

class DecisionLogPage extends ConsumerWidget {
  const DecisionLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionLogControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('DECISION LOG')),
      body: decisionsAsync.when(
        data: (decisions) {
          if (decisions.isEmpty) {
            return const Center(child: Text('No decisions yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: decisions.length,
            itemBuilder: (context, index) {
              final record = decisions[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  record.title?.toUpperCase() ?? 'DECISION',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text(
                  '${record.reviewDate?.toString().substring(0, 10) ?? 'No review date'} · ${record.outcome.label}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DecisionReviewPage(decisionId: record.decisionId ?? ''),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
