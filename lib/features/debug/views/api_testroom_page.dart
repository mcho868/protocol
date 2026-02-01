import 'dart:async';
import 'package:flutter/material.dart';
import '../../../features/decision/services/decision_ai_client.dart';

class ApiTestroomPage extends StatefulWidget {
  const ApiTestroomPage({super.key});

  @override
  State<ApiTestroomPage> createState() => _ApiTestroomPageState();
}

class _ApiTestroomPageState extends State<ApiTestroomPage> {
  final _promptController = TextEditingController();
  final _outputController = TextEditingController();
  StreamSubscription<String>? _sub;

  @override
  void dispose() {
    _promptController.dispose();
    _outputController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API TESTROOM')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Prompt (no system prompt)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startStream,
                  child: const Text('STREAM'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearOutput,
                  child: const Text('CLEAR'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _outputController,
                    readOnly: true,
                    maxLines: null,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Courier',
                      fontSize: 12,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearOutput() {
    _outputController.clear();
  }

  void _startStream() {
    _sub?.cancel();
    _outputController.clear();

    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    final client = DecisionAiClient();
    final stream = client.streamTokens(prompt: prompt, includeEvents: true);
    if (stream == null) {
      _append('No stream (missing API key?)\n');
      return;
    }

    _sub = stream.listen(
      (chunk) => _append(chunk),
      onError: (e) => _append('\n[ERROR] $e\n'),
      onDone: () => _append('\n[STREAM DONE]\n'),
    );
  }

  void _append(String text) {
    _outputController.text += text;
    _outputController.selection = TextSelection.collapsed(
      offset: _outputController.text.length,
    );
    setState(() {});
  }
}
