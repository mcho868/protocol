import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'local_storage_repository.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
LocalStorageRepository localStorageRepository(LocalStorageRepositoryRef ref) {
  return LocalStorageRepository();
}
