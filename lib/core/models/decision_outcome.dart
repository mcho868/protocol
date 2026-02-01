enum DecisionOutcome {
  pending,
  success,
  failure,
  ambiguous,
}

extension DecisionOutcomeLabel on DecisionOutcome {
  String get label {
    switch (this) {
      case DecisionOutcome.pending:
        return 'PENDING';
      case DecisionOutcome.success:
        return 'SUCCESS';
      case DecisionOutcome.failure:
        return 'FAILURE';
      case DecisionOutcome.ambiguous:
        return 'AMBIGUOUS';
    }
  }
}
