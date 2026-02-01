import 'package:flutter/material.dart';
import '../models/decision_matrix.dart';
import 'decision_section.dart';
import 'decision_key_value.dart';

class CriteriaWeightTable extends StatelessWidget {
  final DecisionMatrix matrix;

  const CriteriaWeightTable({super.key, required this.matrix});

  @override
  Widget build(BuildContext context) {
    final sortedCriteria = [...matrix.criteria]
      ..sort((a, b) {
        final aIsNorthStar = a.name.toLowerCase().contains('north star');
        final bIsNorthStar = b.name.toLowerCase().contains('north star');
        if (aIsNorthStar == bIsNorthStar) return 0;
        return aIsNorthStar ? -1 : 1;
      });

    return DecisionSection(
      title: 'Criteria & Weights',
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.black, width: 1),
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Colors.black),
            children: [
              _Cell(text: 'Criterion', invert: true),
              _Cell(text: 'Weight', invert: true),
              _Cell(text: 'Why It Matters', invert: true),
            ],
          ),
          ...sortedCriteria.map((criterion) => TableRow(
                children: [
                  _Cell(text: criterion.name),
                  _Cell(text: criterion.weight.toString()),
                  _Cell(text: criterion.whyItMatters),
                ],
              )),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool invert;

  const _Cell({required this.text, this.invert = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: invert ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
