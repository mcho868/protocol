import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_context.dart';
import '../models/session.dart';

class LocalStorageRepository {
  late Isar _isar;

  Future<void> init() async {
    if (Isar.instanceNames.isNotEmpty) {
      debugPrint('PROTOCOL: Isar already initialized.');
      _isar = Isar.getInstance()!;
      return;
    }

    debugPrint('PROTOCOL: Getting docs dir...');
    final dir = await getApplicationDocumentsDirectory();
    debugPrint('PROTOCOL: Opening Isar at ${dir.path}...');
    _isar = await Isar.open(
      [UserContextSchema, SessionSchema],
      directory: dir.path,
    );
    debugPrint('PROTOCOL: Isar opened.');
  }

  // User Context
  Future<UserContext?> getUserContext() async {
    return await _isar.userContexts.where().findFirst();
  }

  Future<void> saveUserContext(UserContext context) async {
    await _isar.writeTxn(() async {
      await _isar.userContexts.put(context);
    });
  }

  // Sessions
  Future<List<Session>> getAllSessions() async {
    return await _isar.sessions.where().sortByTimestampDesc().findAll();
  }

  Future<void> saveSession(Session session) async {
    await _isar.writeTxn(() async {
      await _isar.sessions.put(session);
    });
  }

  Future<Session?> getSession(Id id) async {
    return await _isar.sessions.get(id);
  }
  
  Future<void> deleteSession(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.sessions.delete(id);
    });
  }
}
