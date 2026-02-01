import 'package:isar/isar.dart';
import 'decision_event.dart';

part 'decision_draft.g.dart';

@collection
class DecisionDraft {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  int? sessionId;

  String? dataJson;

  List<String> missingFields = [];

  List<DecisionEvent> events = [];

  DateTime? updatedAt;
}
