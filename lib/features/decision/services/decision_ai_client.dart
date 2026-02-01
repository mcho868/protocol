import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DecisionAiClient {
  Future<String?> callOnce({
    required String prompt,
    Map<String, dynamic>? responseFormat,
    Map<String, dynamic>? generationConfig,
    bool logErrors = false,
  }) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? const String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) {
      if (logErrors) {
        // ignore: avoid_print
        print('DECISION_CALLONCE_NO_API_KEY');
      }
      return null;
    }

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
          'input': prompt,
          if (responseFormat != null) 'response_format': responseFormat,
          if (generationConfig != null) 'generation_config': generationConfig,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final outputs = data['outputs'] as List?;
          if (outputs != null && outputs.isNotEmpty) {
            final textOutput = outputs.firstWhere(
              (o) => o['type'] == 'text',
              orElse: () => null,
            );
            if (textOutput != null && textOutput['text'] != null) {
              return textOutput['text'];
            }
          }
          final content = data['content'];
          if (content is Map && content['text'] != null) {
            return content['text'].toString();
          }
          final outputText = data['output_text'];
          if (outputText != null) {
            return outputText.toString();
          }
          final candidates = data['candidates'];
          if (candidates is List && candidates.isNotEmpty) {
            final candidate = candidates.first as Map?;
            final candContent = candidate?['content'];
            if (candContent is Map) {
              final parts = candContent['parts'];
              if (parts is List && parts.isNotEmpty) {
                final part = parts.first as Map?;
                if (part != null && part['text'] != null) {
                  return part['text'].toString();
                }
              }
            }
          }
        }
        if (logErrors) {
          final body = response.body;
          final snippet = body.length > 800 ? body.substring(0, 800) : body;
          // ignore: avoid_print
          print('DECISION_CALLONCE_NO_TEXT_OUTPUT: body=$snippet');
        }
      } else if (logErrors) {
        final body = response.body;
        final snippet = body.length > 800 ? body.substring(0, 800) : body;
        // ignore: avoid_print
        print('DECISION_CALLONCE_ERROR: status=${response.statusCode} body=$snippet');
      }
    } catch (e) {
      if (logErrors) {
        // ignore: avoid_print
        print('DECISION_CALLONCE_EXCEPTION: $e');
      }
    }
    return null;
  }

  Stream<String>? streamTokens({
    required String prompt,
    Map<String, dynamic>? responseFormat,
    bool includeEvents = false,
    Map<String, dynamic>? generationConfig,
  }) {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? const String.fromEnvironment('GEMINI_API_KEY');
    if (apiKey.isEmpty) return null;

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/interactions?alt=sse',
    );
    final request = http.Request('POST', url)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      })
      ..body = jsonEncode({
        'model': 'gemini-3-flash-preview',
        'input': prompt,
        'stream': true,
        if (responseFormat != null) 'response_format': responseFormat,
        if (generationConfig != null) 'generation_config': generationConfig,
      });

    final client = http.Client();
    final controller = StreamController<String>();

    client.send(request).then((response) {
      final dataLines = <String>[];
      void flushEvent() {
        if (dataLines.isEmpty) return;
        final payload = dataLines.join('\n').trim();
        dataLines.clear();
        if (payload.isEmpty || payload == '[DONE]') return;
        try {
          final data = jsonDecode(payload);
          final parsed = data is List && data.isNotEmpty
              ? (data.first as Map<String, dynamic>)
              : (data as Map<String, dynamic>);

          final eventType = parsed['event_type']?.toString() ?? 'unknown';
          final content = parsed['content'] as Map?;
          final contentType = content?['type']?.toString();

          final delta = parsed['delta'] as Map?;
          final deltaType = delta?['type']?.toString();
          final deltaText = delta?['text']?.toString();
          // Only output text deltas, not thought signatures
          if (deltaText != null && deltaText.isNotEmpty && deltaType == 'text') {
            controller.add(deltaText);
            return;
          }

          final outputs = parsed['outputs'] as List?;
          final textOutput = outputs?.firstWhere(
            (o) => o['type'] == 'text',
            orElse: () => null,
          );
          final text = textOutput?['text']?.toString();
          if (text != null && text.isNotEmpty) {
            controller.add(text);
            return;
          }

          if (includeEvents) {
            final label = contentType != null ? '$eventType:$contentType' : eventType;
            controller.add('[$label]');
          }
        } catch (_) {
          // ignore malformed chunks
        }
      }

      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.isEmpty) {
            flushEvent();
            return;
          }
          if (line.startsWith('data:')) {
            dataLines.add(line.substring(5));
          }
        },
        onDone: () {
          flushEvent();
          controller.close();
          client.close();
        },
        onError: (e) {
          controller.addError(e);
          controller.close();
          client.close();
        },
      );
    }).catchError((e) {
      controller.addError(e);
      controller.close();
      client.close();
    });

    return controller.stream;
  }
}
