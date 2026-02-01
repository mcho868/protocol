import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_section.dart';

class OptionScoreMatrix extends StatelessWidget {
  final DecisionMatrix matrix;

  const OptionScoreMatrix({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final winningId = matrix.recommendation.winningOptionId;
    final criteria = matrix.criteria;
    final totalsByOption = {
      for (final total in matrix.totals) total.optionId: total.weightedTotal,
    };

    return DecisionSection(
      title: 'Option Score Matrix',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.black),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.black;
            return Colors.white;
          }),
          columnSpacing: 16,
          horizontalMargin: 12,
          columns: [
            const DataColumn(
              label: _HeaderCell(text: 'Option'),
            ),
            ...criteria.map((c) => DataColumn(label: _HeaderCell(text: c.name))),
            const DataColumn(
              label: _HeaderCell(text: 'Total'),
            ),
          ],
          rows: matrix.options.map((option) {
            final isWinner = option.id == winningId;
            final scoresByCriterion = {
              for (final score in matrix.scores.where((s) => s.optionId == option.id))
                score.criterionId: score.score,
            };
            return DataRow(
              selected: isWinner,
              cells: [
                DataCell(_BodyCell(text: option.name, invert: isWinner)),
                ...criteria.map((c) => DataCell(
                      _BodyCell(
                        text: (scoresByCriterion[c.id] ?? 0).toString(),
                        invert: isWinner,
                      ),
                    )),
                DataCell(
                  _BodyCell(
                    text: (totalsByOption[option.id] ?? 0).toStringAsFixed(1),
                    invert: isWinner,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  final bool invert;

  const _BodyCell({required this.text, required this.invert});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90),
      child: Text(
        text,
        style: TextStyle(
          color: invert ? Colors.white : Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
