import 'package:connect_hub/core/errors/failures.dart';
import 'package:connect_hub/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatbotRepo {
  String resolveSessionId();
  List<ChatMessageEntity> loadMessages(String userId);
  Future<Either<Failure, String>> sendMessage({
    required String sessionId,
    required String message,
  });
  void saveMessages(String userId, List<ChatMessageEntity> messages);
  void clearMessages(String userId);
}
