import 'dart:developer';
import 'package:connect_hub/core/errors/failures.dart';
import 'package:connect_hub/features/chatbot/data/models/chat_message_model.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_storage_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chatbot_api_service.dart';
import 'package:connect_hub/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:connect_hub/features/chatbot/domain/repos/chatbot_repo.dart';
import 'package:dartz/dartz.dart';

class ChatbotRepoImpl implements ChatbotRepo {
  final ChatbotApiService apiService;
  final ChatStorageService storageService;
  final ChatService chatService;

  ChatbotRepoImpl({
    required this.apiService,
    required this.storageService,
    required this.chatService,
  });

  @override
  String resolveSessionId() {
    return chatService.resolveSessionId();
  }

  @override
  List<ChatMessageEntity> loadMessages(String userId) {
    return storageService.loadMessages(userId);
  }

  @override
  Future<Either<Failure, String>> sendMessage({
    required String sessionId,
    required String message,
  }) async {
    try {
      final reply = await apiService.sendMessage(
        sessionId: sessionId,
        message: message,
      );
      return Right(reply);
    } catch (e, stackTrace) {
      log(
        'Exception in ChatbotRepoImpl.sendMessage: $e',
        stackTrace: stackTrace,
      );
      return Left(
        ServerFailure('Sorry, something went wrong. Please try again.'),
      );
    }
  }

  @override
  void saveMessages(String userId, List<ChatMessageEntity> messages) {
    final models = messages.map(ChatMessageModel.fromEntity).toList();
    storageService.saveMessages(userId, models);
  }

  @override
  void clearMessages(String userId) {
    storageService.clearMessages(userId);
  }
}
