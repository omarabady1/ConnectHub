import 'dart:convert';

import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/features/chatbot/data/models/chat_message_model.dart';

class ChatStorageService {
  static const String _storageKeyPrefix = 'chatbot_messages_';

  String _keyFor(String userId) => '$_storageKeyPrefix$userId';

  List<ChatMessageModel> loadMessages(String userId) {
    final raw = Prefs.getString(_keyFor(userId));
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ChatMessageModel.fromJson)
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } on FormatException {
      return [];
    }
  }

  void saveMessages(String userId, List<ChatMessageModel> messages) {
    final serializable = messages
        .where((m) => !m.isLoading)
        .map((m) => m.toJson())
        .toList();

    Prefs.setString(_keyFor(userId), jsonEncode(serializable));
  }

  void clearMessages(String userId) {
    Prefs.removeString(_keyFor(userId));
  }
}
