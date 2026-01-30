import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/session.dart';
import '../../settings/providers/settings_provider.dart';
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

  Future<int> createSession(String protocolType) async {
    // Create a session with a temporary ID (negative to avoid Isar conflicts)
    final session = Session()
      ..id = -(DateTime.now().millisecondsSinceEpoch % 100000)
      ..uuid = const Uuid().v4()
      ..timestamp = DateTime.now()
      ..protocolType = protocolType
      ..history = [];
    
    _pendingSessions.insert(0, session);
    ref.invalidateSelf();
    return session.id;
  }

  Future<void> deleteSession(int id) async {
    final repo = ref.read(localStorageRepositoryProvider);
    if (id < 0) {
      _pendingSessions.removeWhere((s) => s.id == id);
    } else {
      await repo.deleteSession(id);
    }
    ref.invalidateSelf();
  }

  Future<void> sendMessage(int sessionId, String text) async {
    final repo = ref.read(localStorageRepositoryProvider);
    final sessions = await future;
    
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

    // Generate AI response
    final userContext = await ref.read(settingsControllerProvider.future);
    final gemini = ref.read(geminiProtocolServiceProvider.notifier);
    
    try {
      final responseText = await gemini.generateResponse(
        prompt: text,
        history: session.history.sublist(0, session.history.length - 1),
        userContext: userContext,
        protocolType: session.protocolType,
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
      } catch (e) {
        // Session might have been deleted while generating
        debugPrint('Error updating session after generation: $e');
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
      } catch (innerError) {
        debugPrint('Error saving error message: $innerError');
      }
    }
  }
}
