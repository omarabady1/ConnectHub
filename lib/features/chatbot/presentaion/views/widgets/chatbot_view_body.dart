import 'package:connect_hub/features/chatbot/domain/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'chat_message_bubble.dart';
import 'chatbot_input_bar.dart';
import 'chatbot_welcome_header.dart';

class ChatbotViewBody extends StatefulWidget {
  const ChatbotViewBody({super.key});

  @override
  State<ChatbotViewBody> createState() => _ChatbotViewBodyState();
}

class _ChatbotViewBodyState extends State<ChatbotViewBody> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageModel> _messages = [
    const ChatMessageModel(
      id: 'welcome_loading',
      sender: ChatMessageSender.ai,
      text: '',
      isLoading: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.removeWhere((m) => m.isLoading);
          _messages.add(
            const ChatMessageModel(
              id: 'welcome_msg',
              sender: ChatMessageSender.ai,
              text: 'Welcome back! How can I help you today?',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: ChatMessageSender.user,
          text: text,
        ),
      );
      _messages.add(
        ChatMessageModel(
          id: '${DateTime.now().millisecondsSinceEpoch}_loading',
          sender: ChatMessageSender.ai,
          text: '',
          isLoading: true,
        ),
      );
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _messages.removeWhere((m) => m.isLoading);
          _messages.add(
            ChatMessageModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              sender: ChatMessageSender.ai,
              text: "Ok, I can help you with that.....",
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChatbotWelcomeHeader(),
                ..._messages.map((message) {
                  return ChatMessageBubble(message: message);
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        ChatbotInputBar(onSubmitted: _onSendMessage),
      ],
    );
  }
}
