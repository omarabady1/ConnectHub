import 'dart:async';
import 'package:connect_hub/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:connect_hub/features/chatbot/domain/repos/chatbot_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatbotRepo chatbotRepo;
  late final String sessionId;

  ChatbotCubit(this.chatbotRepo) : super(const ChatbotInitial()) {
    sessionId = chatbotRepo.resolveSessionId();
  }

  void loadChatHistory() {
    final saved = chatbotRepo.loadMessages(sessionId);

    if (saved.isNotEmpty) {
      emit(ChatbotLoaded(messages: List.from(saved)));
    } else {
      _showWelcomeMessage();
    }
  }

  void _showWelcomeMessage() {
    final welcomeLoading = ChatMessageEntity(
      id: 'welcome_loading',
      sender: ChatMessageSender.ai,
      text: '',
      timestamp: DateTime.now(),
      isLoading: true,
    );

    emit(ChatbotLoaded(messages: [welcomeLoading]));

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (isClosed) return;
      final welcomeMsg = ChatMessageEntity(
        id: 'welcome_msg',
        sender: ChatMessageSender.ai,
        text: 'Welcome back! How can I help you today?',
        timestamp: DateTime.now(),
      );

      final updatedMessages = [welcomeMsg];
      chatbotRepo.saveMessages(sessionId, updatedMessages);
      emit(ChatbotLoaded(messages: updatedMessages));
    });
  }

  Future<void> sendMessage(String text) async {
    if (state.isWaitingForReply || text.trim().isEmpty) return;

    final userMsg = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: ChatMessageSender.user,
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    final loadingId = '${DateTime.now().millisecondsSinceEpoch}_loading';
    final loadingMsg = ChatMessageEntity(
      id: loadingId,
      sender: ChatMessageSender.ai,
      text: '',
      timestamp: DateTime.now(),
      isLoading: true,
    );

    final currentMessages = List<ChatMessageEntity>.from(state.messages);
    currentMessages.add(userMsg);
    currentMessages.add(loadingMsg);

    emit(ChatbotLoaded(messages: currentMessages, isWaitingForReply: true));

    final result = await chatbotRepo.sendMessage(
      sessionId: sessionId,
      message: text.trim(),
    );

    if (isClosed) return;

    final updatedMessages = List<ChatMessageEntity>.from(state.messages);
    updatedMessages.removeWhere((m) => m.id == loadingId);

    result.fold(
      (failure) {
        final errorReply = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: ChatMessageSender.ai,
          text: failure.message,
          timestamp: DateTime.now(),
        );
        updatedMessages.add(errorReply);
        chatbotRepo.saveMessages(sessionId, updatedMessages);
        emit(
          ChatbotLoaded(messages: updatedMessages, isWaitingForReply: false),
        );
      },
      (reply) {
        final aiReply = ChatMessageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: ChatMessageSender.ai,
          text: reply,
          timestamp: DateTime.now(),
        );
        updatedMessages.add(aiReply);
        chatbotRepo.saveMessages(sessionId, updatedMessages);
        emit(
          ChatbotLoaded(messages: updatedMessages, isWaitingForReply: false),
        );
      },
    );
  }

  void clearChat() {
    chatbotRepo.clearMessages(sessionId);
    emit(const ChatbotLoaded(messages: [], isWaitingForReply: false));
    _showWelcomeMessage();
  }
}
