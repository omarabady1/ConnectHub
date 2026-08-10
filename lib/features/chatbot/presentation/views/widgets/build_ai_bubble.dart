import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:connect_hub/features/create_post/presentation/views/create_post_view.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:connect_hub/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildAiBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final String? userPrompt;
  final bool showActions;

  const BuildAiBubble({
    super.key,
    required this.message,
    this.userPrompt,
    this.showActions = true,
  });

  void _onCopy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.text));
    showCustomSnackBar(context, 'Response copied to clipboard', isError: false);
  }

  ({String title, String content}) _parseAiResponse(
    String rawText,
    String? fallbackPrompt,
  ) {
    String? parsedTitle;
    String? parsedContent;

    final topicMatch = RegExp(
      r'(?:Hook/Topic|Topic|Hook):\s*(.*?)(?=\r?\n\r?\n|\r?\n(?:Post Text|Post|Text):|$)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(rawText);

    if (topicMatch != null) {
      final extracted = topicMatch.group(1)?.trim();
      if (extracted != null && extracted.isNotEmpty) {
        parsedTitle = extracted;
      }
    }

    final contentMatch = RegExp(
      r'(?:Post Text|Post|Text):\s*(.*)',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(rawText);

    if (contentMatch != null) {
      final extracted = contentMatch.group(1)?.trim();
      if (extracted != null && extracted.isNotEmpty) {
        parsedContent = extracted;
      }
    }

    return (
      title: parsedTitle ?? fallbackPrompt?.trim() ?? '',
      content: parsedContent ?? rawText.trim(),
    );
  }

  void _onCreatePost(BuildContext context) {
    final parsed = _parseAiResponse(message.text, userPrompt);
    Navigator.of(context).pushNamed(
      CreatePostView.routeName,
      arguments: CreatePostViewArgs(
        title: parsed.title,
        content: parsed.content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFE1E0FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.smart_toy_rounded,
                color: kBrandIndigo,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2FE),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(2),
                ),
                border: Border.all(color: const Color(0xFFE4E1ED), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: kBrandIndigo.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF1B1B23),
                      height: 1.4,
                    ),
                  ),
                  if (showActions) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE4E1ED), height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _ActionButton(
                          icon: Icons.copy_rounded,
                          label: 'Copy',
                          onTap: () => _onCopy(context),
                        ),
                        const SizedBox(width: 12),
                        _ActionButton(
                          icon: Icons.post_add_rounded,
                          label: 'Create Post',
                          onTap: () => _onCreatePost(context),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: kBrandIndigo),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.medium12.copyWith(color: kBrandIndigo),
            ),
          ],
        ),
      ),
    );
  }
}
