import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_context.dart';
import '../models/session.dart';
import '../models/decision_draft.dart';
import '../models/decision_matrix_record.dart';

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
      [UserContextSchema, SessionSchema, DecisionDraftSchema, DecisionMatrixRecordSchema],
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

  // Decision Drafts
  Future<DecisionDraft?> getDecisionDraftBySessionId(int sessionId) async {
    return await _isar.decisionDrafts.filter().sessionIdEqualTo(sessionId).findFirst();
  }

  Future<void> saveDecisionDraft(DecisionDraft draft) async {
    await _isar.writeTxn(() async {
      await _isar.decisionDrafts.put(draft);
    });
  }

  Future<void> deleteDecisionDraftBySessionId(int sessionId) async {
    await _isar.writeTxn(() async {
      await _isar.decisionDrafts.filter().sessionIdEqualTo(sessionId).deleteAll();
    });
  }

  // Decision Matrices
  Future<void> saveDecisionMatrix(DecisionMatrixRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.decisionMatrixRecords.put(record);
    });
  }

  Future<void> updateDecisionMatrix(DecisionMatrixRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.decisionMatrixRecords.put(record);
    });
  }

  Future<DecisionMatrixRecord?> getDecisionMatrixByDecisionId(String decisionId) async {
    return await _isar.decisionMatrixRecords.filter().decisionIdEqualTo(decisionId).findFirst();
  }

  Future<List<DecisionMatrixRecord>> getDecisionMatrices() async {
    return await _isar.decisionMatrixRecords.where().sortByCreatedAtDesc().findAll();
  }
}
