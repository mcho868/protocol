import 'package:isar/isar.dart';
import 'protocol_type.dart';

part 'session.g.dart';

@collection
class Session {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uuid;

  DateTime? lastSyncedAt;

  @Index()
  DateTime? timestamp;

  @enumerated
  ProtocolType protocol = ProtocolType.clarity;

  String? protocolType;

  List<ChatMessage> history = [];

  String get protocolLabel => protocolType ?? protocol.label;
}

@embedded
class ChatMessage {
  String? role; // 'user' or 'model'
  String? text;
  DateTime? sentAt;
}
