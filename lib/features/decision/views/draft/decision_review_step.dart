import 'package:flutter/material.dart';
import '../../widgets/draft/draft_section.dart';

class DecisionReviewStep extends StatelessWidget {
  final List<String> validationErrors;
  final VoidCallback onGenerate;
  final bool isGenerating;

  const DecisionReviewStep({
    super.key,
    required this.validationErrors,
    required this.onGenerate,
    required this.isGenerating,
  });

  @override
  Widget build(BuildContext context) {
    final isReady = validationErrors.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DraftSection(
          title: 'Review',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isReady)
                ...validationErrors.map(
                  (error) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '• $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else
                const Text('All required inputs are complete. Generate the Decision Matrix.'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isReady && !isGenerating ? onGenerate : null,
                  child: isGenerating
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Generate Decision Matrix'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
