enum ChatMessageSender { user, ai }

class ChatMessageModel {
  final String id;
  final ChatMessageSender sender;
  final String text;
  final bool isLoading;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.text,
    this.isLoading = false,
  });
}
