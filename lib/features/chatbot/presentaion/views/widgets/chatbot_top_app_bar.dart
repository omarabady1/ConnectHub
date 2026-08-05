import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class ChatbotTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClearChat;

  const ChatbotTopAppBar({super.key, this.onClearChat});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kHomeBackgroundColor.withValues(alpha: 0.95),
      elevation: 0.5,
      shadowColor: const Color(0x0D000000),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        'ChatBot',
        style: AppTextStyles.bold24.copyWith(
          color: kBrandIndigo,
          letterSpacing: -0.6,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _showDeleteConfirmation(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 224, 224),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Color.fromARGB(255, 228, 0, 0),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
          'Are you sure you want to delete all messages? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onClearChat?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
