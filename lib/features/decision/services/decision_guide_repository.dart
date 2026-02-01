import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'decision_guide_repository.g.dart';

@Riverpod(keepAlive: true)
DecisionGuideRepository decisionGuideRepository(DecisionGuideRepositoryRef ref) {
  return DecisionGuideRepository();
}

class DecisionGuideRepository {
  final _supabase = Supabase.instance.client;

  Future<bool> hasAnySessions() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('sessions')
        .select('uuid')
        .eq('user_id', user.id)
        .limit(1);

    if (response is List) {
      return response.isNotEmpty;
    }

    return false;
  }
}
