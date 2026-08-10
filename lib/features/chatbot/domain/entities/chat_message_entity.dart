enum ChatMessageSender { user, ai }

class ChatMessageEntity {
  final String id;
  final ChatMessageSender sender;
  final String text;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessageEntity({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isLoading = false,
  });

  ChatMessageEntity copyWith({
    String? id,
    ChatMessageSender? sender,
    String? text,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
