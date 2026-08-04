import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class CommentInputBottomBar extends StatefulWidget {
  final ValueChanged<String>? onSendComment;
  final String userAvatarUrl;

  const CommentInputBottomBar({
    super.key,
    this.onSendComment,
    this.userAvatarUrl =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=250',
  });

  @override
  State<CommentInputBottomBar> createState() => _CommentInputBottomBarState();
}

class _CommentInputBottomBarState extends State<CommentInputBottomBar> {
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
    if (text.isNotEmpty) {
      if (widget.onSendComment != null) {
        widget.onSendComment!(text);
      }
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF2FCF8FF),
        border: Border(top: BorderSide(color: Color(0xFFE4E1ED), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.network(widget.userAvatarUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECF8),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFC7C4D7), width: 1),
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _handleSend(),
                      style: AppTextStyles.regular14.copyWith(
                        color: const Color(0xFF1B1B23),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: AppTextStyles.regular14.copyWith(
                          color: const Color(0xFF5C5F61),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(bottom: 4),
                      ),
                    ),
                  ),
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
