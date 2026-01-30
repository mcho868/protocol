import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../../../core/models/session.dart';
import '../../../core/models/user_context.dart';

part 'gemini_provider.g.dart';

@riverpod
class GeminiProtocolService extends _$GeminiProtocolService {
  @override
  void build() {}

  Future<String> generateResponse({
    required String prompt,
    required List<ChatMessage> history,
    UserContext? userContext,
    String? protocolType,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? const String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      return 'Error: GEMINI_API_KEY not found.';
    }

    final systemPrompt = _buildSystemPrompt(userContext, protocolType);
    
    // Construct the input array
    final List<Map<String, String>> inputMessages = [];
    
    // Add system prompt as a user message (or system if supported by this specific endpoint logic)
    // The interactions endpoint usually expects a conversation flow.
    // We'll inject the system prompt into the first user message or as a separate turn if allowed.
    // Based on standard patterns, prepending it to the first message or sending it as 'user' usually works.
    // Let's prepend it to the current context for now.
    
    // Add history
    for (final m in history) {
      inputMessages.add({
        'role': m.role == 'user' ? 'user' : 'model',
        'content': m.text ?? '',
      });
    }

    // Add current user prompt
    // Wait, the 'prompt' argument is the new message.
    // Is it already in 'history' passed to this function?
    // In SessionController, we add it to history BEFORE calling this.
    // So 'history' contains the user's latest message at the end?
    // Let's check SessionController. 
    // SessionController calls: history: session.history.sublist(0, session.history.length - 1)
    // AND passes 'prompt' (which is the last message text).
    // So 'history' is everything BEFORE the new message.
    
    // We need to construct the full conversation including the system context.
    // We'll add the system prompt as the very first "user" message context.
    
    final fullInput = <Map<String, String>>[];
    
    // Inject system prompt
    fullInput.add({
      'role': 'user',
      'content': 'SYSTEM INSTRUCTION:\n$systemPrompt\n\nCONTEXT_START'
    });
    
    fullInput.addAll(inputMessages);
    
    fullInput.add({
      'role': 'user',
      'content': prompt
    });

    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/interactions');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode({
          'model': 'gemini-3-flash-preview',
          'input': fullInput,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final outputs = data['outputs'] as List?;
        
        if (outputs != null) {
          // Find the output with type 'text'
          final textOutput = outputs.firstWhere(
            (o) => o['type'] == 'text',
            orElse: () => null,
          );
          
          if (textOutput != null && textOutput['text'] != null) {
            return textOutput['text'];
          }
        }
        return 'No text response received.';
      } else {
        debugPrint('Gemini API Error: ${response.statusCode} - ${response.body}');
        return 'Error: API returned ${response.statusCode}. ${response.body}';
      }
    } catch (e) {
      debugPrint('Gemini Network Error: $e');
      return 'Error: Failed to connect. $e';
    }
  }

  String _buildSystemPrompt(UserContext? context, String? protocolType) {
    final basePrompt = '''
You are "PROTOCOL", a minimalist AI executive coach for systems thinkers. 
Your goal is to help high-performers optimize their systems, decision-making, and execution.

DESIGN LANGUAGE:
- Be concise. No fluff.
- Use sharp, analytical language.
- Focus on second-order effects.
- NEVER say "Protocol initialized" or list current objectives.
- Respond DIRECTLY to the user's input.

USER CONTEXT:
Core Values: ${context?.coreValues.join(', ') ?? 'Not defined'}
North Star Metric: ${context?.northStarMetric ?? 'Not defined'}

CURRENT PROTOCOL: ${protocolType ?? 'General Clarity'}
''';

    if (protocolType == 'Decision Coach') {
      return '$basePrompt\nAnalyze the decision using a weighted matrix. Consider unintended consequences.';
    } else if (protocolType == 'Action Coach') {
      return '$basePrompt\nFocus on high-leverage actions. Apply the 80/20 principle.';
    }
    
    return basePrompt;
  }
}