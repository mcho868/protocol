class DecisionMatrix {
  final String schemaVersion;
  final String decisionId;
  final String decisionTitle;
  final String? decisionDeadline;
  final String problemFrame;
  final Reversibility reversibility;
  final AdequacyCriteria adequacyCriteria;
  final OpportunityCost opportunityCost;
  final List<DecisionOption> options;
  final List<DecisionCriterion> criteria;
  final List<DecisionScore> scores;
  final List<DecisionTotal> totals;
  final String? totalsScale;
  final List<TradeoffAudit> tradeoffAudit;
  final DecisionRecommendation recommendation;
  final List<DecisionRisk> risks;
  final DecisionCommitment commitment;
  final DecisionReview review;
  final DecisionMemoryLinks memoryLinks;

  DecisionMatrix({
    required this.schemaVersion,
    required this.decisionId,
    required this.decisionTitle,
    required this.decisionDeadline,
    required this.problemFrame,
    required this.reversibility,
    required this.adequacyCriteria,
    required this.opportunityCost,
    required this.options,
    required this.criteria,
    required this.scores,
    required this.totals,
    required this.totalsScale,
    required this.tradeoffAudit,
    required this.recommendation,
    required this.risks,
    required this.commitment,
    required this.review,
    required this.memoryLinks,
  });

  factory DecisionMatrix.fromJson(Map<String, dynamic> json) {
    return DecisionMatrix(
      schemaVersion: json['schema_version']?.toString() ?? '1.0',
      decisionId: json['decision_id']?.toString() ?? '',
      decisionTitle: json['decision_title']?.toString() ?? '',
      decisionDeadline: json['decision_deadline']?.toString(),
      problemFrame: json['problem_frame']?.toString() ?? '',
      reversibility: Reversibility.fromJson(json['reversibility'] as Map? ?? {}),
      adequacyCriteria: AdequacyCriteria.fromJson(json['adequacy_criteria'] as Map? ?? {}),
      opportunityCost: OpportunityCost.fromJson(json['opportunity_cost'] as Map? ?? {}),
      options: _listFrom(json['options'], DecisionOption.fromJson),
      criteria: _listFrom(json['criteria'], DecisionCriterion.fromJson),
      scores: _listFrom(json['scores'], DecisionScore.fromJson),
      totals: _listFrom(json['totals'], DecisionTotal.fromJson),
      totalsScale: json['totals_scale']?.toString(),
      tradeoffAudit: _listFrom(json['tradeoff_audit'], TradeoffAudit.fromJson),
      recommendation: DecisionRecommendation.fromJson(json['recommendation'] as Map? ?? {}),
      risks: _listFrom(json['risks'], DecisionRisk.fromJson),
      commitment: DecisionCommitment.fromJson(json['commitment'] as Map? ?? {}),
      review: DecisionReview.fromJson(json['review'] as Map? ?? {}),
      memoryLinks: DecisionMemoryLinks.fromJson(json['memory_links'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'decision_id': decisionId,
      'decision_title': decisionTitle,
      'decision_deadline': decisionDeadline,
      'problem_frame': problemFrame,
      'reversibility': reversibility.toJson(),
      'adequacy_criteria': adequacyCriteria.toJson(),
      'opportunity_cost': opportunityCost.toJson(),
      'options': options.map((o) => o.toJson()).toList(),
      'criteria': criteria.map((c) => c.toJson()).toList(),
      'scores': scores.map((s) => s.toJson()).toList(),
      'totals': totals.map((t) => t.toJson()).toList(),
      if (totalsScale != null) 'totals_scale': totalsScale,
      'tradeoff_audit': tradeoffAudit.map((t) => t.toJson()).toList(),
      'recommendation': recommendation.toJson(),
      'risks': risks.map((r) => r.toJson()).toList(),
      'commitment': commitment.toJson(),
      'review': review.toJson(),
      'memory_links': memoryLinks.toJson(),
    };
  }
}

class Reversibility {
  final String type;
  final String reversalCost;

  Reversibility({required this.type, required this.reversalCost});

  factory Reversibility.fromJson(Map<dynamic, dynamic> json) {
    return Reversibility(
      type: json['type']?.toString() ?? '',
      reversalCost: json['reversal_cost']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'reversal_cost': reversalCost,
      };
}

class AdequacyCriteria {
  final List<String> mustHaves;
  final List<String> dealBreakers;

  AdequacyCriteria({required this.mustHaves, required this.dealBreakers});

  factory AdequacyCriteria.fromJson(Map<dynamic, dynamic> json) {
    return AdequacyCriteria(
      mustHaves: _stringList(json['must_haves']),
      dealBreakers: _stringList(json['deal_breakers']),
    );
  }

  Map<String, dynamic> toJson() => {
        'must_haves': mustHaves,
        'deal_breakers': dealBreakers,
      };
}

class OpportunityCost {
  final List<String> foregoneOptions;

  OpportunityCost({required this.foregoneOptions});

  factory OpportunityCost.fromJson(Map<dynamic, dynamic> json) {
    return OpportunityCost(
      foregoneOptions: _stringList(json['foregone_options']),
    );
  }

  Map<String, dynamic> toJson() => {
        'foregone_options': foregoneOptions,
      };
}

class DecisionOption {
  final String id;
  final String name;
  final String description;

  DecisionOption({required this.id, required this.name, required this.description});

  factory DecisionOption.fromJson(Map<dynamic, dynamic> json) {
    return DecisionOption(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}

class DecisionCriterion {
  final String id;
  final String name;
  final int weight;
  final String whyItMatters;

  DecisionCriterion({
    required this.id,
    required this.name,
    required this.weight,
    required this.whyItMatters,
  });

  factory DecisionCriterion.fromJson(Map<dynamic, dynamic> json) {
    return DecisionCriterion(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      weight: _parseInt(json['weight']),
      whyItMatters: json['why_it_matters']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'weight': weight,
        'why_it_matters': whyItMatters,
      };
}

class DecisionScore {
  final String optionId;
  final String criterionId;
  final int score;
  final String rationale;

  DecisionScore({
    required this.optionId,
    required this.criterionId,
    required this.score,
    required this.rationale,
  });

  factory DecisionScore.fromJson(Map<dynamic, dynamic> json) {
    return DecisionScore(
      optionId: json['option_id']?.toString() ?? '',
      criterionId: json['criterion_id']?.toString() ?? '',
      score: _parseInt(json['score']),
      rationale: json['rationale']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'option_id': optionId,
        'criterion_id': criterionId,
        'score': score,
        'rationale': rationale,
      };
}

class DecisionTotal {
  final String optionId;
  final double weightedTotal;

  DecisionTotal({required this.optionId, required this.weightedTotal});

  factory DecisionTotal.fromJson(Map<dynamic, dynamic> json) {
    return DecisionTotal(
      optionId: json['option_id']?.toString() ?? '',
      weightedTotal: _parseDouble(json['weighted_total']),
    );
  }

  Map<String, dynamic> toJson() => {
        'option_id': optionId,
        'weighted_total': weightedTotal,
      };
}

class TradeoffAudit {
  final String optionId;
  final String primarySacrifice;

  TradeoffAudit({required this.optionId, required this.primarySacrifice});

  factory TradeoffAudit.fromJson(Map<dynamic, dynamic> json) {
    return TradeoffAudit(
      optionId: json['option_id']?.toString() ?? '',
      primarySacrifice: json['primary_sacrifice']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'option_id': optionId,
        'primary_sacrifice': primarySacrifice,
      };
}

class DecisionRecommendation {
  final String winningOptionId;
  final List<String> reasoningBullets;
  final double confidence;
  final List<String> assumptions;

  DecisionRecommendation({
    required this.winningOptionId,
    required this.reasoningBullets,
    required this.confidence,
    required this.assumptions,
  });

  factory DecisionRecommendation.fromJson(Map<dynamic, dynamic> json) {
    return DecisionRecommendation(
      winningOptionId: json['winning_option_id']?.toString() ?? '',
      reasoningBullets: _stringList(json['reasoning_bullets']),
      confidence: _parseDouble(json['confidence']),
      assumptions: _stringList(json['assumptions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'winning_option_id': winningOptionId,
        'reasoning_bullets': reasoningBullets,
        'confidence': confidence,
        'assumptions': assumptions,
      };
}

class DecisionRisk {
  final String risk;
  final String likelihood;
  final String impact;
  final String mitigation;

  DecisionRisk({
    required this.risk,
    required this.likelihood,
    required this.impact,
    required this.mitigation,
  });

  factory DecisionRisk.fromJson(Map<dynamic, dynamic> json) {
    return DecisionRisk(
      risk: json['risk']?.toString() ?? '',
      likelihood: json['likelihood']?.toString() ?? '',
      impact: json['impact']?.toString() ?? '',
      mitigation: json['mitigation']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'risk': risk,
        'likelihood': likelihood,
        'impact': impact,
        'mitigation': mitigation,
      };
}

class DecisionCommitment {
  final String lockedChoiceOptionId;
  final String firstAction;
  final String firstActionDue;
  final List<String> implementationIntentions;

  DecisionCommitment({
    required this.lockedChoiceOptionId,
    required this.firstAction,
    required this.firstActionDue,
    required this.implementationIntentions,
  });

  factory DecisionCommitment.fromJson(Map<dynamic, dynamic> json) {
    return DecisionCommitment(
      lockedChoiceOptionId: json['locked_choice_option_id']?.toString() ?? '',
      firstAction: json['first_action']?.toString() ?? '',
      firstActionDue: json['first_action_due']?.toString() ?? '',
      implementationIntentions: _stringList(json['implementation_intentions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'locked_choice_option_id': lockedChoiceOptionId,
        'first_action': firstAction,
        'first_action_due': firstActionDue,
        'implementation_intentions': implementationIntentions,
      };
}

class DecisionReview {
  final String reviewDate;
  final List<String> exitCriteria;
  final String checkInQuestion;

  DecisionReview({
    required this.reviewDate,
    required this.exitCriteria,
    required this.checkInQuestion,
  });

  factory DecisionReview.fromJson(Map<dynamic, dynamic> json) {
    return DecisionReview(
      reviewDate: json['review_date']?.toString() ?? '',
      exitCriteria: _stringList(json['exit_criteria']),
      checkInQuestion: json['check_in_question']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'review_date': reviewDate,
        'exit_criteria': exitCriteria,
        'check_in_question': checkInQuestion,
      };
}

class DecisionMemoryLinks {
  final List<String> coreValuesUsed;
  final String northStarMetricUsed;

  DecisionMemoryLinks({required this.coreValuesUsed, required this.northStarMetricUsed});

  factory DecisionMemoryLinks.fromJson(Map<dynamic, dynamic> json) {
    return DecisionMemoryLinks(
      coreValuesUsed: _stringList(json['core_values_used']),
      northStarMetricUsed: json['north_star_metric_used']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'core_values_used': coreValuesUsed,
        'north_star_metric_used': northStarMetricUsed,
      };
}

List<T> _listFrom<T>(dynamic value, T Function(Map<dynamic, dynamic>) parser) {
  if (value is List) {
    return value.whereType<Map>().map((e) => parser(e)).toList();
  }
  return <T>[];
}

List<String> _stringList(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
  }
  return <String>[];
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
