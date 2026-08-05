import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class ChatbotTopAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onClearChat;

  const ChatbotTopAppBar({super.key, this.onClearChat});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height +
          MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: kHomeBackgroundColor.withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: Text(
                'ChatBot',
                style: AppTextStyles.bold24.copyWith(
                  color: kBrandIndigo,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ),
          if (onClearChat != null)
            GestureDetector(
              onTap: onClearChat,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: kBrandIndigo,
                    size: 20,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}
