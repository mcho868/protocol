import '../models/decision_matrix.dart';

class DecisionMatrixValidationResult {
  final bool isValid;
  final List<String> errors;

  const DecisionMatrixValidationResult(this.isValid, this.errors);
}

class DecisionMatrixValidator {
  DecisionMatrixValidationResult validate(DecisionMatrix matrix) {
    final errors = <String>[];

    if (matrix.decisionTitle.trim().isEmpty) {
      errors.add('decision_title is required');
    }
    if (matrix.problemFrame.trim().isEmpty) {
      errors.add('problem_frame is required');
    }
    if (matrix.reversibility.type != 'two_way_door' && matrix.reversibility.type != 'one_way_door') {
      errors.add('reversibility.type must be two_way_door or one_way_door');
    }
    if (matrix.options.length < 3) {
      errors.add('options must include at least 3 items');
    }
    if (matrix.criteria.isEmpty) {
      errors.add('criteria must include at least 1 item');
    }

    final weightSum = matrix.criteria.fold<int>(0, (sum, c) => sum + c.weight);
    if (weightSum != 100) {
      errors.add('criteria weights must sum to 100');
    }

    final optionIds = matrix.options.map((o) => o.id).toSet();
    final criterionIds = matrix.criteria.map((c) => c.id).toSet();

    for (final optionId in optionIds) {
      for (final criterionId in criterionIds) {
        final hasScore = matrix.scores.any(
          (s) => s.optionId == optionId && s.criterionId == criterionId,
        );
        if (!hasScore) {
          errors.add('scores missing for option $optionId and criterion $criterionId');
        }
      }
    }

    if (matrix.commitment.firstAction.trim().isEmpty) {
      errors.add('commitment.first_action is required');
    }
    if (matrix.commitment.firstActionDue.trim().isEmpty) {
      errors.add('commitment.first_action_due is required');
    }

    if (matrix.review.reviewDate.trim().isEmpty) {
      errors.add('review.review_date is required');
    }
    if (matrix.recommendation.confidence < 0 || matrix.recommendation.confidence > 1) {
      errors.add('recommendation.confidence must be between 0 and 1');
    }
    if (matrix.totalsScale == null || matrix.totalsScale!.trim().isEmpty) {
      errors.add('totals_scale is required');
    }

    return DecisionMatrixValidationResult(errors.isEmpty, errors);
  }
}
