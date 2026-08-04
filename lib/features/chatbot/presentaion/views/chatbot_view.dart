import 'package:flutter/material.dart';
import '../../../../constants.dart';
import 'widgets/chatbot_top_app_bar.dart';
import 'widgets/chatbot_view_body.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  static const String routeName = '/chatbot';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: ChatbotTopAppBar(),
      body: ChatbotViewBody(),
    );
  }
}
