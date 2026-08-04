import 'package:connect_hub/features/chatbot/domain/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'build_ai_bubble.dart';
import 'build_loading_bubble.dart';
import 'build_user_bubble.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (message.isLoading) {
      content = const BuildLoadingBubble();
    } else if (message.sender == ChatMessageSender.user) {
      content = BuildUserBubble(message: message);
    } else {
      content = BuildAiBubble(message: message);
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey(message.id),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.85 + (value * 0.15),
            alignment: message.sender == ChatMessageSender.user
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            child: child,
          ),
        );
      },
      child: content,
    );
  }
}
