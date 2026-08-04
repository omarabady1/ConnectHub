import 'dart:convert';
import 'dart:io';

import 'package:connect_hub/core/services/cloud_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImagebbApiService implements CloudStorageService {
  static const String _uploadHost = 'api.imgbb.com';
  static const String _uploadPath = '/1/upload';
  static const String _apiKeyEnvName = 'IMGBB_API_KEY';

  @override
  Future<String> uploadFile(File file, String path) async {
    final client = HttpClient();

    try {
      final uri = Uri.https(_uploadHost, _uploadPath, {'key': _apiKey});
      final request = await client.postUrl(uri);
      final boundary =
          '----connect-hub-${DateTime.now().microsecondsSinceEpoch}';

      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary',
      );

      final fileName = _fileNameFromPath(file.path);
      request.add(
        utf8.encode(
          '--$boundary\r\n'
          'Content-Disposition: form-data; name="image"; '
          'filename="$fileName"\r\n'
          'Content-Type: ${_contentTypeFor(fileName)}\r\n\r\n',
        ),
      );
      await request.addStream(file.openRead());
      request.add(utf8.encode('\r\n--$boundary--\r\n'));

      final response = await request.close();
      final responseBody = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Image upload failed with status ${response.statusCode}',
        );
      }

      final decodedResponse = jsonDecode(responseBody);
      if (decodedResponse is! Map<String, dynamic>) {
        throw Exception('Invalid image upload response');
      }

      final data = decodedResponse['data'];
      if (decodedResponse['success'] != true || data is! Map<String, dynamic>) {
        throw Exception('Image upload failed');
      }

      final imageUrl = data['url'] ?? data['display_url'];
      if (imageUrl is! String || imageUrl.isEmpty) {
        throw Exception('Image upload response did not include an image URL');
      }

      return imageUrl;
    } finally {
      client.close();
    }
  }

  String _fileNameFromPath(String path) {
    final normalizedPath = path.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  String get _apiKey {
    final apiKey = dotenv.env[_apiKeyEnvName];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing $_apiKeyEnvName in .env');
    }

    return apiKey;
  }

  String _contentTypeFor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'application/octet-stream',
    };
  }
}
