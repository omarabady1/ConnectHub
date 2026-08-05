import 'package:flutter/material.dart';
import '../../../../constants.dart';
import 'widgets/chatbot_top_app_bar.dart';
import 'widgets/chatbot_view_body.dart';

class ChatbotView extends StatefulWidget {
  const ChatbotView({super.key});

  static const String routeName = '/chatbot';

  @override
  State<ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<ChatbotView> {
  final GlobalKey<ChatbotViewBodyState> _bodyKey =
      GlobalKey<ChatbotViewBodyState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: ChatbotTopAppBar(
        onClearChat: () => _bodyKey.currentState?.clearChat(),
      ),
      body: ChatbotViewBody(key: _bodyKey),
    );
  }
}
