import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class CommentInputBottomBar extends StatefulWidget {
  final ValueChanged<String>? onSendComment;
  final bool isSending;

  const CommentInputBottomBar({
    super.key,
    this.onSendComment,
    this.isSending = false,
  });

  @override
  State<CommentInputBottomBar> createState() =>
      _CommentInputBottomBarState();
}

class _CommentInputBottomBarState
    extends State<CommentInputBottomBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isSending) {
      widget.onSendComment?.call(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthRepo>().getCachedUser();
    final avatarUrl = user?.avatarUrl;
    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name[0].toUpperCase()
        : '?';

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2FCF8FF),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE4E1ED),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          UserAvatar(
            avatarUrl: avatarUrl,
            initial: initial,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECF8),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: const Color(0xFFC7C4D7),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !widget.isSending,
                      onSubmitted: (_) => _handleSend(),
                      textCapitalization:
                          TextCapitalization.sentences,
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF1B1B23),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle:
                            AppTextStyles.regular14.copyWith(
                          color: const Color(0xFF5C5F61),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(bottom: 4),
                      ),
                    ),
                  ),
                  if (widget.isSending)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else
                    IconButton(
                      onPressed: _handleSend,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: kBrandIndigo,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
