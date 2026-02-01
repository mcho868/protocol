import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_service.dart';
import 'sync_repository.dart';

class SyncListener extends ConsumerWidget {
  final Widget child;

  const SyncListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      final prevUserId = prev?.value?.session?.user.id;
      final nextUserId = next.value?.session?.user.id;
      if (nextUserId != null && nextUserId != prevUserId) {
        unawaited(ref.read(syncRepositoryProvider).syncAll());
      }
    });

    return child;
  }
}
