import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/decision_matrix_record.dart';

part 'decision_log_provider.g.dart';

@riverpod
class DecisionLogController extends _$DecisionLogController {
  @override
  FutureOr<List<DecisionMatrixRecord>> build() async {
    final repo = ref.watch(localStorageRepositoryProvider);
    return repo.getDecisionMatrices();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
