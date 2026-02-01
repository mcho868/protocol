import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/protocol_type.dart';
import '../../../core/models/session.dart';
import '../../session/providers/session_provider.dart';
import '../views/decision_draft_chat.dart';

class DecisionProtocolPage extends ConsumerStatefulWidget {
  const DecisionProtocolPage({super.key, required this.sessionId, this.sessionUuid});

  final int sessionId;
  final String? sessionUuid;

  @override
  ConsumerState<DecisionProtocolPage> createState() => _DecisionProtocolPageState();
}

class _DecisionProtocolPageState extends ConsumerState<DecisionProtocolPage> {
  late int _currentId;
  String? _currentUuid;
  @override
  void initState() {
    super.initState();
    _currentId = widget.sessionId;
    _currentUuid = widget.sessionUuid;
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionControllerProvider);

    return sessionsAsync.when(
      data: (sessions) {
        final sessionIndex = sessions.indexWhere((s) => s.id == _currentId);
        Session? session;
        if (sessionIndex != -1) {
          session = sessions[sessionIndex];
          _currentUuid ??= session.uuid;
        } else if (_currentUuid != null) {
          session = sessions.firstWhere(
            (s) => s.uuid == _currentUuid,
            orElse: () => Session(),
          );
          if (session.id != _currentId && session.id != 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _currentId = session!.id);
            });
          }
        }

        if (session == null || session.id == 0) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final resolvedSession = session!;
        if (resolvedSession.protocol != ProtocolType.decision) {
          return const Scaffold(body: Center(child: Text('Not a decision session.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(resolvedSession.protocolLabel.toUpperCase()),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: DecisionDraftChat(session: resolvedSession),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

}
