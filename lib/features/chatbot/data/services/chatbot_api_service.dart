import 'dart:convert';
import 'dart:io';

class ChatbotApiService {
  static const String _webhookUrl =
      'https://newacc111.app.n8n.cloud/webhook-test/'
      'post-idea-chatbot';

  Future<String> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(_webhookUrl);
      final request = await client.postUrl(uri);

      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json',
      );

      final body = jsonEncode({
        'sessionId': sessionId,
        'message': message,
      });

      request.write(body);

      final response = await request.close();
      final responseBody =
          await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Chatbot request failed with status '
          '${response.statusCode}',
        );
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid chatbot response format');
      }

      final reply = decoded['reply'];
      if (reply is! String || reply.isEmpty) {
        throw Exception(
          'Chatbot response did not include a reply',
        );
      }

      return reply;
    } finally {
      client.close();
    }
  }
}
