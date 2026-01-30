import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/models/user_context.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<UserContext?> build() async {
    debugPrint('PROTOCOL: SettingsController building...');
    final repo = ref.watch(localStorageRepositoryProvider);
    final context = await repo.getUserContext();
    debugPrint('PROTOCOL: SettingsController loaded context: $context');
    return context;
  }

  Future<void> updateContext({
    List<String>? coreValues,
    String? northStarMetric,
  }) async {
    final repo = ref.read(localStorageRepositoryProvider);
    var context = await repo.getUserContext();
    
    context ??= UserContext();
    
    if (coreValues != null) context.coreValues = coreValues;
    if (northStarMetric != null) context.northStarMetric = northStarMetric;
    context.updatedAt = DateTime.now();
    
    await repo.saveUserContext(context);
    ref.invalidateSelf();
  }
}
