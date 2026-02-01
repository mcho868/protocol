import 'package:isar/isar.dart';
import 'decision_event.dart';
import 'decision_outcome.dart';

part 'decision_matrix_record.g.dart';

@collection
class DecisionMatrixRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? decisionId;

  int? sessionId;

  String? title;
  String? protocolLabel;

  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? firstActionDue;
  DateTime? reviewDate;
  DateTime? lastReviewedAt;

  @enumerated
  DecisionOutcome outcome = DecisionOutcome.pending;

  String? reviewNotes;
  String? calibrationSummary;
  String? nextStep;

  String? rawJson;

  List<DecisionEvent> events = [];
}
