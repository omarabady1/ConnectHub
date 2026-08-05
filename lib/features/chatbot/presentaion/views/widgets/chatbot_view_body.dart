import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chat_storage_service.dart';
import 'package:connect_hub/features/chatbot/data/services/chatbot_api_service.dart';
import 'package:connect_hub/features/chatbot/domain/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'chat_message_bubble.dart';
import 'chatbot_input_bar.dart';
import 'chatbot_welcome_header.dart';

class ChatbotViewBody extends StatefulWidget {
  const ChatbotViewBody({super.key});

  @override
  State<ChatbotViewBody> createState() =>
      ChatbotViewBodyState();
}

class ChatbotViewBodyState extends State<ChatbotViewBody> {
  final ScrollController _scrollController =
      ScrollController();
  final List<ChatMessageModel> _messages = [];
  final ChatbotApiService _apiService =
      getIt<ChatbotApiService>();
  final ChatStorageService _storageService =
      getIt<ChatStorageService>();
  final ChatService _chatService =
      getIt<ChatService>();

  late final String _sessionId;
  bool _isWaitingForReply = false;

  @override
  void initState() {
    super.initState();
    _sessionId = _chatService.resolveSessionId();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  void _loadChatHistory() {
    final saved = _storageService.loadMessages(_sessionId);

    if (saved.isNotEmpty) {
      setState(() => _messages.addAll(saved));
      _scrollToBottom();
    } else {
      _showWelcomeMessage();
    }
  }

  void _showWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessageModel(
          id: 'welcome_loading',
          sender: ChatMessageSender.ai,
          text: '',
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      );
    });

    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        if (!mounted) return;
        setState(() {
          _messages
              .removeWhere((m) => m.id == 'welcome_loading');
          _messages.add(
            ChatMessageModel(
              id: 'welcome_msg',
              sender: ChatMessageSender.ai,
              text:
                  'Welcome back! How can I help you today?',
              timestamp: DateTime.now(),
            ),
          );
        });
        _storageService.saveMessages(_sessionId, _messages);
        _scrollToBottom();
      },
    );
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

  Future<void> _onSendMessage(String text) async {
    if (_isWaitingForReply) return;

    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: ChatMessageSender.user,
      text: text,
      timestamp: DateTime.now(),
    );

    final loadingId =
        '${DateTime.now().millisecondsSinceEpoch}_loading';

    setState(() {
      _isWaitingForReply = true;
      _messages.add(userMsg);
      _messages.add(
        ChatMessageModel(
          id: loadingId,
          sender: ChatMessageSender.ai,
          text: '',
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      );
    });
    _scrollToBottom();

    try {
      final reply = await _apiService.sendMessage(
        sessionId: _sessionId,
        message: text,
      );

      if (!mounted) return;

      setState(() {
        _messages.removeWhere((m) => m.id == loadingId);
        _messages.add(
          ChatMessageModel(
            id: DateTime.now()
                .millisecondsSinceEpoch
                .toString(),
            sender: ChatMessageSender.ai,
            text: reply,
            timestamp: DateTime.now(),
          ),
        );
        _isWaitingForReply = false;
      });
    } on Exception {
      if (!mounted) return;

      setState(() {
        _messages.removeWhere((m) => m.id == loadingId);
        _messages.add(
          ChatMessageModel(
            id: DateTime.now()
                .millisecondsSinceEpoch
                .toString(),
            sender: ChatMessageSender.ai,
            text:
                'Sorry, something went wrong. '
                'Please try again.',
            timestamp: DateTime.now(),
          ),
        );
        _isWaitingForReply = false;
      });
    }

    _storageService.saveMessages(_sessionId, _messages);
    _scrollToBottom();
  }

  void clearChat() {
    _storageService.clearMessages(_sessionId);
    setState(() {
      _messages.clear();
      _isWaitingForReply = false;
    });
    _showWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChatbotWelcomeHeader(),
                ..._messages.map((message) {
                  return ChatMessageBubble(
                    message: message,
                  );
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
