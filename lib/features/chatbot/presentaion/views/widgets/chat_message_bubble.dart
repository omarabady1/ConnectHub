import 'package:connect_hub/features/chatbot/domain/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (message.isLoading) {
      content = buildLoadingBubble();
    } else if (message.sender == ChatMessageSender.user) {
      content = buildUserBubble();
    } else {
      content = buildAiBubble();
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey(message.id),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.85 + (value * 0.15),
            alignment: message.sender == ChatMessageSender.user
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            child: child,
          ),
        );
      },
      child: content,
    );
  }

  Widget buildAiBubble() {
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
              child: Text(
                message.text,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF1B1B23),
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget buildUserBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBrandIndigo,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBrandIndigo.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: AppTextStyles.regular14.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingBubble() {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F2FE),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(2),
              ),
              border: Border.all(color: const Color(0xFFE4E1ED), width: 1),
            ),
            child: const TypingDotsAnimation(),
          ),
        ],
      ),
    );
  }
}

class TypingDotsAnimation extends StatefulWidget {
  const TypingDotsAnimation({super.key});

  @override
  State<TypingDotsAnimation> createState() => _TypingDotsAnimationState();
}

class _TypingDotsAnimationState extends State<TypingDotsAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final start = index * 0.2;
        final end = (start + 0.5).clamp(0.0, 1.0);

        final translationAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0), weight: 50),
          TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        );

        final opacityAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.35, end: 1.0), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.35), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        );

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, translationAnimation.value),
              child: Opacity(
                opacity: opacityAnimation.value,
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kBrandIndigo,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
