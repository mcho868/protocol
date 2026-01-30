import 'package:isar/isar.dart';

part 'session.g.dart';

@collection
class Session {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uuid;

  DateTime? lastSyncedAt;

  @Index()
  DateTime? timestamp;

  String? protocolType;

  List<ChatMessage> history = [];
}

@embedded
class ChatMessage {
  String? role; // 'user' or 'model'
  String? text;
  DateTime? sentAt;
}