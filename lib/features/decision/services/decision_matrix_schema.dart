const Map<String, dynamic> decisionMatrixResponseFormat = {
  'type': 'object',
  'properties': {
    'type': {
      'type': 'string',
      'enum': ['decision_matrix'],
    },
    'schema_version': {'type': 'string'},
    'decision_id': {'type': 'string'},
    'decision_title': {'type': 'string'},
    'decision_deadline': {'type': 'string'},
    'problem_frame': {'type': 'string'},
    'reversibility': {
      'type': 'object',
      'properties': {
        'type': {
          'type': 'string',
          'enum': ['two_way_door', 'one_way_door'],
        },
        'reversal_cost': {'type': 'string'},
      },
      'required': ['type', 'reversal_cost'],
    },
    'adequacy_criteria': {
      'type': 'object',
      'properties': {
        'must_haves': {'type': 'array', 'items': {'type': 'string'}},
        'deal_breakers': {'type': 'array', 'items': {'type': 'string'}},
      },
      'required': ['must_haves', 'deal_breakers'],
    },
    'opportunity_cost': {
      'type': 'object',
      'properties': {
        'foregone_options': {'type': 'array', 'items': {'type': 'string'}},
      },
      'required': ['foregone_options'],
    },
    'options': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'id': {'type': 'string'},
          'name': {'type': 'string'},
          'description': {'type': 'string'},
        },
        'required': ['id', 'name', 'description'],
      },
    },
    'criteria': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'id': {'type': 'string'},
          'name': {'type': 'string'},
          'weight': {'type': 'integer'},
          'why_it_matters': {'type': 'string'},
        },
        'required': ['id', 'name', 'weight', 'why_it_matters'],
      },
    },
    'scores': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'option_id': {'type': 'string'},
          'criterion_id': {'type': 'string'},
          'score': {'type': 'integer'},
          'rationale': {'type': 'string'},
        },
        'required': ['option_id', 'criterion_id', 'score', 'rationale'],
      },
    },
    'totals': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'option_id': {'type': 'string'},
          'weighted_total': {'type': 'number'},
        },
        'required': ['option_id', 'weighted_total'],
      },
    },
    'totals_scale': {'type': 'string'},
    'tradeoff_audit': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'option_id': {'type': 'string'},
          'primary_sacrifice': {'type': 'string'},
        },
        'required': ['option_id', 'primary_sacrifice'],
      },
    },
    'recommendation': {
      'type': 'object',
      'properties': {
        'winning_option_id': {'type': 'string'},
        'reasoning_bullets': {'type': 'array', 'items': {'type': 'string'}},
        'confidence': {'type': 'number'},
        'assumptions': {'type': 'array', 'items': {'type': 'string'}},
      },
      'required': ['winning_option_id', 'reasoning_bullets', 'confidence', 'assumptions'],
    },
    'risks': {
      'type': 'array',
      'items': {
        'type': 'object',
        'properties': {
          'risk': {'type': 'string'},
          'likelihood': {'type': 'string', 'enum': ['low', 'med', 'high']},
          'impact': {'type': 'string', 'enum': ['low', 'med', 'high']},
          'mitigation': {'type': 'string'},
        },
        'required': ['risk', 'likelihood', 'impact', 'mitigation'],
      },
    },
    'commitment': {
      'type': 'object',
      'properties': {
        'locked_choice_option_id': {'type': 'string'},
        'first_action': {'type': 'string'},
        'first_action_due': {'type': 'string'},
        'implementation_intentions': {'type': 'array', 'items': {'type': 'string'}},
      },
      'required': ['locked_choice_option_id', 'first_action', 'first_action_due', 'implementation_intentions'],
    },
    'review': {
      'type': 'object',
      'properties': {
        'review_date': {'type': 'string'},
        'exit_criteria': {'type': 'array', 'items': {'type': 'string'}},
        'check_in_question': {'type': 'string'},
      },
      'required': ['review_date', 'exit_criteria', 'check_in_question'],
    },
    'memory_links': {
      'type': 'object',
      'properties': {
        'core_values_used': {'type': 'array', 'items': {'type': 'string'}},
        'north_star_metric_used': {'type': 'string'},
      },
      'required': ['core_values_used', 'north_star_metric_used'],
    },
  },
  'required': [
    'type',
    'schema_version',
    'decision_id',
    'decision_title',
    'decision_deadline',
    'problem_frame',
    'reversibility',
    'adequacy_criteria',
    'opportunity_cost',
    'options',
    'criteria',
    'scores',
    'totals',
    'totals_scale',
    'tradeoff_audit',
    'recommendation',
    'risks',
    'commitment',
    'review',
    'memory_links',
  ],
};
