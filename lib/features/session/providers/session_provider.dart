import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/protocol_type.dart';
import '../../../core/models/session.dart';
import '../../settings/providers/settings_provider.dart';
import '../../decision/services/decision_protocol_service.dart';
import '../../decision/decision_intro.dart';
import '../../../core/services/sync_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'gemini_provider.dart';

part 'session_provider.g.dart';

@riverpod
class SessionController extends _$SessionController {
  // In-memory sessions that haven't been saved yet
  final List<Session> _pendingSessions = [];

  @override
  FutureOr<List<Session>> build() async {
    final repo = ref.watch(localStorageRepositoryProvider);
    final savedSessions = await repo.getAllSessions();
    return [..._pendingSessions, ...savedSessions];
  }

  Future<SessionRef> createSession(ProtocolType protocolType) async {
    // Create a session with a temporary ID (negative to avoid Isar conflicts)
    final session = Session()
      ..id = -(DateTime.now().millisecondsSinceEpoch % 100000)
      ..uuid = const Uuid().v4()
      ..timestamp = DateTime.now()
      ..protocol = protocolType
      ..protocolType = protocolType.label
      ..history = [];

    if (protocolType == ProtocolType.decision) {
      session.history.add(
        ChatMessage()
          ..role = 'model'
          ..text = decisionIntroMessage
          ..sentAt = DateTime.now(),
      );
    }

    _pendingSessions.insert(0, session);
    ref.invalidateSelf();
    return SessionRef(id: session.id, uuid: session.uuid ?? '');
  }

  Future<void> deleteSession(int id) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final syncRepository = ref.read(syncRepositoryProvider);
    final supabaseUser = sb.Supabase.instance.client.auth.currentUser;
    if (id < 0) {
      _pendingSessions.removeWhere((s) => s.id == id);
    } else {
      final session = await repo.getSession(id);
      await repo.deleteSession(id);
      if (supabaseUser != null && session?.uuid != null) {
        await syncRepository.deleteSessionRemote(
          userId: supabaseUser.id,
          sessionUuid: session!.uuid!,
        );
      }
    }
    ref.invalidateSelf();
  }

  Future<void> appendUserMessage(int sessionId, String text) async {
    await _appendMessage(sessionId, 'user', text);
  }

  Future<void> appendModelMessage(int sessionId, String text) async {
    await _appendMessage(sessionId, 'model', text);
  }

  Future<void> _appendMessage(int sessionId, String role, String text) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final syncRepository = ref.read(syncRepositoryProvider);
    final supabaseUser = sb.Supabase.instance.client.auth.currentUser;
    var targetId = sessionId;

    final pendingMatch = _pendingSessions.where((s) => s.id == sessionId).toList();
    if (pendingMatch.isNotEmpty) {
      final pending = pendingMatch.first;
      _pendingSessions.removeWhere((s) => s.id == sessionId);
      pending.id = Isar.autoIncrement;
      await repo.saveSession(pending);
      ref.invalidateSelf();
      final stored = await repo.getSession(pending.id);
      if (stored == null) return;
      targetId = stored.id;
    }

    final freshSessions = await future;
    Session? session = freshSessions.firstWhere(
      (s) => s.id == targetId,
      orElse: () => Session(),
    );
    if (session.id == 0) {
      session = await repo.getSession(targetId);
    }
    if (session == null) {
      return;
    }

    final message = ChatMessage()
      ..role = role
      ..text = text
      ..sentAt = DateTime.now();

    session.history = [...session.history, message];
    await repo.saveSession(session);
    ref.invalidateSelf();
    if (supabaseUser != null) {
      await syncRepository.syncSessions(supabaseUser.id);
    }
  }

  Future<void> sendMessage(int sessionId, String text) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final sessions = await future;
    final syncRepository = ref.read(syncRepositoryProvider);
    final supabaseUser = sb.Supabase.instance.client.auth.currentUser;
    
    // Find session or return if not found
    final session = sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => throw Exception('Session not found'),
    );

    // Add user message
    final userMessage = ChatMessage()
      ..role = 'user'
      ..text = text
      ..sentAt = DateTime.now();
    
    session.history = [...session.history, userMessage];

    // If it's a pending session, save it to Isar for the first time
    if (sessionId < 0) {
      _pendingSessions.removeWhere((s) => s.id == sessionId);
      session.id = Isar.autoIncrement; // Reset to let Isar handle it
      await repo.saveSession(session);
    } else {
      await repo.saveSession(session);
    }
    
    ref.invalidateSelf();
    final newId = session.id; // Get the real ID from Isar if it was just saved
    if (supabaseUser != null) {
      await syncRepository.syncSessions(supabaseUser.id);
    }

    // Generate AI response
    final userContext = await ref.read(settingsControllerProvider.future);
    final gemini = ref.read(geminiProtocolServiceProvider.notifier);
    final decisionProtocol = ref.read(decisionProtocolServiceProvider);
    
    try {
      final isDecision = session.protocol == ProtocolType.decision ||
          session.protocolType == ProtocolType.decision.label;

      if (isDecision) {
        final aiMessage = ChatMessage()
          ..role = 'model'
          ..text = ''
          ..sentAt = DateTime.now();

        final currentSessions = await future;
        final currentSession = currentSessions.firstWhere((s) => s.id == newId);
        currentSession.history = [...currentSession.history, aiMessage];
        state = AsyncData(List<Session>.from(currentSessions));

        final responseText = await decisionProtocol.handleMessageStream(
          message: text,
          session: currentSession,
          userContext: userContext,
          onDelta: (delta) {
            aiMessage.text = (aiMessage.text ?? '') + delta;
            state = AsyncData(List<Session>.from(currentSessions));
          },
        );

        aiMessage.text = responseText;
        await repo.saveSession(currentSession);
        state = AsyncData(List<Session>.from(currentSessions));
        if (supabaseUser != null) {
          await syncRepository.syncSessions(supabaseUser.id);
        }
      } else {
        final responseText = await gemini.generateResponse(
          prompt: text,
          history: session.history.sublist(0, session.history.length - 1),
          userContext: userContext,
          protocolType: session.protocol,
        );

        final aiMessage = ChatMessage()
          ..role = 'model'
          ..text = responseText
          ..sentAt = DateTime.now();

        // Fetch latest session state (in case of ID change)
        final currentSessions = await future;
        try {
          final currentSession = currentSessions.firstWhere((s) => s.id == newId);
          currentSession.history = [...currentSession.history, aiMessage];
          await repo.saveSession(currentSession);
          ref.invalidateSelf();
          if (supabaseUser != null) {
            await syncRepository.syncSessions(supabaseUser.id);
          }
        } catch (e) {
          // Session might have been deleted while generating
          debugPrint('Error updating session after generation: $e');
        }
      }
    } catch (e) {
      final errorMessage = ChatMessage()
        ..role = 'model'
        ..text = 'ERROR: Failed to reach Protocol. Check API key. Details: $e'
        ..sentAt = DateTime.now();
      
      try {
        final currentSessions = await future;
        final currentSession = currentSessions.firstWhere((s) => s.id == newId);
        currentSession.history = [...currentSession.history, errorMessage];
        await repo.saveSession(currentSession);
        ref.invalidateSelf();
        if (supabaseUser != null) {
          await syncRepository.syncSessions(supabaseUser.id);
        }
      } catch (innerError) {
        debugPrint('Error saving error message: $innerError');
      }
    }
  }

  Future<void> generateDecisionMatrix(int sessionId, Map<String, dynamic> draft) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final sessions = await future;
    final syncRepository = ref.read(syncRepositoryProvider);
    final supabaseUser = sb.Supabase.instance.client.auth.currentUser;

    final session = sessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => throw Exception('Session not found'),
    );

    if (sessionId < 0) {
      _pendingSessions.removeWhere((s) => s.id == sessionId);
      session.id = Isar.autoIncrement;
      await repo.saveSession(session);
    } else {
      await repo.saveSession(session);
    }

    ref.invalidateSelf();
    final newId = session.id;
    if (supabaseUser != null) {
      await syncRepository.syncSessions(supabaseUser.id);
    }

    final userContext = await ref.read(settingsControllerProvider.future);
    final decisionProtocol = ref.read(decisionProtocolServiceProvider);

    final aiMessage = ChatMessage()
      ..role = 'model'
      ..text = ''
      ..sentAt = DateTime.now();

    final currentSessions = await future;
    final currentSession = currentSessions.firstWhere((s) => s.id == newId);
    currentSession.history = [...currentSession.history, aiMessage];
    await repo.saveSession(currentSession);
    state = AsyncData(List<Session>.from(currentSessions));

    try {
      final responseText = await decisionProtocol.generateFromDraftStream(
        draftMap: draft,
        session: currentSession,
        userContext: userContext,
        onDelta: (delta) {
          aiMessage.text = (aiMessage.text ?? '') + delta;
          // Force immediate UI update by setting state directly
          state = AsyncData(List<Session>.from(currentSessions));
        },
      );

      aiMessage.text = responseText;
      await repo.saveSession(currentSession);
      state = AsyncData(List<Session>.from(currentSessions));
      if (supabaseUser != null) {
        await syncRepository.syncSessions(supabaseUser.id);
      }
    } catch (e) {
      aiMessage.text = 'ERROR: Failed to generate DecisionMatrix. Details: $e';
      await repo.saveSession(currentSession);
      ref.invalidateSelf();
    }
  }
}

class SessionRef {
  final int id;
  final String uuid;

  const SessionRef({required this.id, required this.uuid});
}
