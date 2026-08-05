import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class ChatbotInputBar extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const ChatbotInputBar({super.key, required this.onSubmitted});

  @override
  State<ChatbotInputBar> createState() => _ChatbotInputBarState();
}

class _ChatbotInputBarState extends State<ChatbotInputBar> {
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
      widget.onSubmitted(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kHomeBackgroundColor.withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFC7C4D7), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _handleSend(),
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF1B1B23),
                ),
                decoration: InputDecoration(
                  hintText: 'Ask ConnectHub AI...',
                  hintStyle: AppTextStyles.regular14.copyWith(
                    color: const Color(0x99464554),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                    right: 56,
                    top: 14,
                    bottom: 14,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 6,
              child: GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kBrandIndigo,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kBrandIndigo.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
