/// Represents who sent a chat message.
enum ChatMessageSender { user, ai }

/// A single message in the chatbot conversation.
class ChatMessageModel {
  final String id;
  final ChatMessageSender sender;
  final String text;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isLoading = false,
  });

  /// Deserializes a [ChatMessageModel] from a JSON map.
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

  /// Serializes this message to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender == ChatMessageSender.user ? 'user' : 'ai',
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
