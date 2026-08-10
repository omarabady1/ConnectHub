import 'dart:convert';
import 'dart:io';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatbotApiService {
  final DatabaseService? _databaseService;

  ChatbotApiService({this._databaseService});

  Future<String> _getWebhookUrl() async {
    if (_databaseService != null) {
      try {
        final data = await _databaseService.getData(
          path: BackendEndpoints.chatbotConfig,
          docId: 'chatbot',
        );

        if (data is Map<String, dynamic>) {
          final url = data['webhook_url'] as String?;
          if (url != null && url.isNotEmpty) {
            return url;
          }
        }
      } catch (_) {}
    }

    final fallbackUrl = dotenv.env['CHATBOT_WEBHOOK_URL'];
    if (fallbackUrl == null || fallbackUrl.isEmpty) {
      throw Exception('Webhook URL is not configured in Firestore or .env');
    }
    return fallbackUrl;
  }

  Future<String> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final client = HttpClient();

    try {
      final webhookUrl = await _getWebhookUrl();
      final uri = Uri.parse(webhookUrl);
      final request = await client.postUrl(uri);

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final body = jsonEncode({'sessionId': sessionId, 'message': message});

      request.write(body);

      final response = await request.close();
      final responseBody = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Chatbot request failed with status ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid chatbot response format');
      }

      final reply = decoded['reply'];
      if (reply is! String || reply.isEmpty) {
        throw Exception('Chatbot response did not include a reply');
      }

      return reply;
    } finally {
      client.close();
    }
  }
}
