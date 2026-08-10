import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/chatbot/domain/repos/chatbot_repo.dart';
import 'package:connect_hub/features/chatbot/presentation/cubits/chatbot_cubit/chatbot_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/chatbot_top_app_bar.dart';
import 'widgets/chatbot_view_body.dart';

class ChatbotView extends StatelessWidget {
  const ChatbotView({super.key});

  static const String routeName = '/chatbot';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatbotCubit(getIt<ChatbotRepo>())..loadChatHistory(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: kHomeBackgroundColor,
            appBar: ChatbotTopAppBar(
              onClearChat: () => context.read<ChatbotCubit>().clearChat(),
            ),
            body: const ChatbotViewBody(),
          );
        },
      ),
    );
  }
}
