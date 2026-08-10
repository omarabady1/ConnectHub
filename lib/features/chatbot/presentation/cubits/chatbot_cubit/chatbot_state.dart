part of 'chatbot_cubit.dart';

abstract class ChatbotState {
  final List<ChatMessageEntity> messages;
  final bool isWaitingForReply;

  const ChatbotState({required this.messages, this.isWaitingForReply = false});
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial() : super(messages: const []);
}

class ChatbotLoaded extends ChatbotState {
  const ChatbotLoaded({required super.messages, super.isWaitingForReply});
}

class ChatbotError extends ChatbotState {
  final String errorMessage;

  const ChatbotError({
    required super.messages,
    required this.errorMessage,
    super.isWaitingForReply = false,
  });
}
