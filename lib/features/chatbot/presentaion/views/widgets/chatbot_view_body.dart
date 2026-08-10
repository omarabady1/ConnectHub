import 'package:connect_hub/features/chatbot/presentaion/cubits/chatbot_cubit/chatbot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatbotCubit, ChatbotState>(
      listener: (context, state) {
        _scrollToBottom();
      },
      builder: (context, state) {
        final messages = state.messages;
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
                    ...messages.map((message) {
                      return ChatMessageBubble(message: message);
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            ChatbotInputBar(
              onSubmitted: (text) {
                context.read<ChatbotCubit>().sendMessage(text);
              },
            ),
          ],
        );
      },
    );
  }
}
