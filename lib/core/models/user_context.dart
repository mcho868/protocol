import 'package:isar/isar.dart';

part 'user_context.g.dart';

@collection
class UserContext {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uuid;

  DateTime? lastSyncedAt;

  List<String> coreValues = [];
  
  String? northStarMetric;

  DateTime? updatedAt;
}