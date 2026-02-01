import 'package:isar/isar.dart';

part 'decision_event.g.dart';

@embedded
class DecisionEvent {
  late String type;
  DateTime? occurredAt;
  String? note;
}
