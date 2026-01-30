import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_provider.dart';
import '../models/session.dart';
import '../models/user_context.dart';

part 'sync_repository.g.dart';

@Riverpod(keepAlive: true)
SyncRepository syncRepository(SyncRepositoryRef ref) {
  return SyncRepository(ref);
}

class SyncRepository {
  final SyncRepositoryRef _ref;
  final _supabase = Supabase.instance.client;

  SyncRepository(this._ref);

  Future<void> syncAll() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return;

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await syncUserContext(user.id);
    await syncSessions(user.id);
  }

  Future<void> syncUserContext(String userId) async {
    final repo = _ref.read(localStorageRepositoryProvider);
    final context = await repo.getUserContext();
    if (context == null) return;

    // Check if local is newer than what we think is on server (simplification)
    // In a real app, we'd fetch the server timestamp first.
    
    await _supabase.from('profiles').upsert({
      'id': userId,
      'core_values': context.coreValues,
      'north_star_metric': context.northStarMetric,
      'updated_at': context.updatedAt?.toIso8601String(),
    });

    context.lastSyncedAt = DateTime.now();
    await repo.saveUserContext(context);
  }

  Future<void> syncSessions(String userId) async {
    final repo = _ref.read(localStorageRepositoryProvider);
    final sessions = await repo.getAllSessions();

    for (final session in sessions) {
      // Only sync if never synced or updated after last sync
      if (session.lastSyncedAt == null || 
          (session.timestamp != null && session.timestamp!.isAfter(session.lastSyncedAt!))) {
        
        // Sync Session
        await _supabase.from('sessions').upsert({
          'uuid': session.uuid,
          'user_id': userId,
          'protocol_type': session.protocolType,
          'created_at': session.timestamp?.toIso8601String(),
          'history': session.history.map((m) => {
            'role': m.role,
            'text': m.text,
            'sent_at': m.sentAt?.toIso8601String(),
          }).toList(),
        }, onConflict: 'uuid');

        session.lastSyncedAt = DateTime.now();
        await repo.saveSession(session);
      }
    }
  }
}
