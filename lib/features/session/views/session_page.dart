import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/session.dart';
import '../providers/session_provider.dart';
import 'artifacts/action_plan_widget.dart';
import '../../decision/models/decision_matrix.dart';
import '../../decision/views/decision_matrix_view.dart';
import '../../../core/models/protocol_type.dart';
import '../../decision/services/decision_guide_repository.dart';
import '../../decision/widgets/decision_guide_modal.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key, required this.sessionId, this.sessionUuid});

  final int sessionId;
  final String? sessionUuid;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  late int _currentId;
  String? _currentUuid;
  bool _guideChecked = false;

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
        // Find session by temporary or permanent ID
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

        // Update current ID if it transitioned
        if (resolvedSession.id != _currentId && resolvedSession.id > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentId = resolvedSession.id);
          });
        }

        _maybeShowDecisionGuide(resolvedSession);

        return Scaffold(
          appBar: AppBar(
            title: Text(resolvedSession.protocolLabel.toUpperCase()),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: resolvedSession.protocol == ProtocolType.decision
                ? [
                    TextButton(
                      onPressed: () => _showGuide(context),
                      child: const Text('GUIDE', style: TextStyle(color: Colors.black)),
                    ),
                  ]
                : null,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: resolvedSession.history.length,
                  itemBuilder: (context, index) {
                    final message = resolvedSession.history[index];
                    return _ChatMessageWidget(message: message);
                  },
                ),
              ),
              _MessageInput(sessionId: _currentId),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  void _showGuide(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const DecisionGuideModal(),
    );
  }

  void _maybeShowDecisionGuide(Session session) {
    if (_guideChecked || session.protocol != ProtocolType.decision) return;
    _guideChecked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(decisionGuideRepositoryProvider);
      bool hasRemoteSessions = false;
      try {
        hasRemoteSessions = await repo.hasAnySessions();
      } catch (_) {
        hasRemoteSessions = true;
      }
      if (!hasRemoteSessions && mounted) {
        _showGuide(context);
      }
    });
  }
}

class _ChatMessageWidget extends StatelessWidget {
  const _ChatMessageWidget({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final text = message.text ?? '';
    
    // Check for JSON artifact
    Widget content;
    if (!isUser && _isJson(text)) {
      try {
        final data = jsonDecode(_extractJson(text));
        if (data is Map<String, dynamic>) {
          if (data['type'] == 'action_plan') {
            content = ActionPlanWidget(data: data);
          } else if (data['type'] == 'decision_matrix' ||
              (data.containsKey('decision_id') && data.containsKey('criteria'))) {
            try {
              content = DecisionMatrixView(matrix: DecisionMatrix.fromJson(data));
            } catch (e) {
              content = _buildDefaultMarkdown(text, isUser);
            }
          } else {
            content = _buildDefaultMarkdown(text, isUser);
          }
        } else {
          content = _buildDefaultMarkdown(text, isUser);
        }
      } catch (e) {
        content = _buildDefaultMarkdown(text, isUser);
      }
    } else {
      content = _buildDefaultMarkdown(text, isUser);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isUser ? 'YOU' : 'PROTOCOL',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildDefaultMarkdown(String text, bool isUser) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  bool _isJson(String text) {
    return text.contains('```json') || (text.trim().startsWith('{') && text.trim().endsWith('}'));
  }

  String _extractJson(String text) {
    if (text.contains('```json')) {
      final start = text.indexOf('```json') + 7;
      final end = text.lastIndexOf('```');
      return text.substring(start, end).trim();
    }
    return text.trim();
  }
}

class _MessageInput extends ConsumerStatefulWidget {
  const _MessageInput({required this.sessionId});

  final int sessionId;

  @override
  ConsumerState<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<_MessageInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Execute protocol...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward, color: Colors.black),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    final text = _controller.text.trim();
    _controller.clear();
    ref.read(sessionControllerProvider.notifier).sendMessage(widget.sessionId, text);
  }
}
