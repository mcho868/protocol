const String decisionIntroMessage = '''
DECISION PROTOCOL — TWO STAGE FLOW
1) Intake: we gather missing inputs.
2) Artifact: we generate a DecisionMatrix you can review.

You can answer in one message. If all inputs are present, I’ll compute immediately.

Start with:
- What decision are you making?
- What is the deadline?
- Is this reversible (two-way door) or irreversible (one-way door)?
- Options (>=3)
- Must-haves / deal-breakers
''';
