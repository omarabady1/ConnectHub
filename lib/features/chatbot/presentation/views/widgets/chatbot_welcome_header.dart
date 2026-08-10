import 'package:connect_hub/constants.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChatbotWelcomeHeader extends StatelessWidget {
  const ChatbotWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E0FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kBrandIndigo.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.smart_toy_rounded,
                color: kBrandIndigo,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Hi, I'm ConnectHub AI",
            style: AppTextStyles.semiBold20.copyWith(
              color: const Color(0xFF1B1B23),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Ready to generate some post ideas?',
            style: AppTextStyles.regular14.copyWith(
              color: const Color(0xFF464554),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
