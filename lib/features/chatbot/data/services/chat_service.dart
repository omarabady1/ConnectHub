import 'dart:convert';

import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';

class ChatService {
  String resolveSessionId() {
    final userJson = Prefs.getString(kUserData);
    if (userJson == null || userJson.isEmpty) {
      return 'anonymous-session';
    }

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic>) {
        final uid = decoded['userID'];
        if (uid is String && uid.isNotEmpty) return uid;
      }
    } on FormatException {
      // Ignore malformed JSON.
    }

    return 'anonymous-session';
  }
}
