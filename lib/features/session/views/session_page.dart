import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/models/session.dart';
import '../providers/session_provider.dart';
import 'artifacts/action_plan_widget.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key, required this.sessionId});

  final int sessionId;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  late int _currentId;

  @override
  void initState() {
    super.initState();
    _currentId = widget.sessionId;
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(sessionControllerProvider);
    
    return sessionsAsync.when(
      data: (sessions) {
        // Find session by temporary or permanent ID
        final sessionIndex = sessions.indexWhere((s) => s.id == _currentId);
        
        // If not found, try finding the latest session with the same protocolType (handle ID transition)
        final session = sessionIndex != -1 
          ? sessions[sessionIndex] 
          : sessions.firstWhere(
              (s) => s.id > 0 && s.protocolType == sessions.firstWhere((old) => old.id == _currentId, orElse: () => sessions.first).protocolType,
              orElse: () => sessions.first,
            );

        // Update current ID if it transitioned
        if (session.id != _currentId && session.id > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentId = session.id);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(session.protocolType?.toUpperCase() ?? 'SESSION'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: session.history.length,
                  itemBuilder: (context, index) {
                    final message = session.history[index];
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
        if (data is Map<String, dynamic> && data.containsKey('type')) {
          if (data['type'] == 'action_plan') {
            content = ActionPlanWidget(data: data);
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