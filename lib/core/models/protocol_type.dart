enum ProtocolType {
  clarity,
  decision,
  action,
  weeklyReview,
}

extension ProtocolTypeLabel on ProtocolType {
  String get label {
    switch (this) {
      case ProtocolType.clarity:
        return 'Clarity Protocol';
      case ProtocolType.decision:
        return 'Decision Protocol';
      case ProtocolType.action:
        return 'Action Protocol';
      case ProtocolType.weeklyReview:
        return 'Weekly Review Protocol';
    }
  }
}
