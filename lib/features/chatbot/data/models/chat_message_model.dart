import 'package:connect_hub/features/chatbot/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.sender,
    required super.text,
    required super.timestamp,
    super.isLoading = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      sender: json['sender'] == 'user'
          ? ChatMessageSender.user
          : ChatMessageSender.ai,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender == ChatMessageSender.user ? 'user' : 'ai',
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      sender: entity.sender,
      text: entity.text,
      timestamp: entity.timestamp,
      isLoading: entity.isLoading,
    );
  }
}
