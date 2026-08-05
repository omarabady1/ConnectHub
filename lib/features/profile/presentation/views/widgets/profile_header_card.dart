import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 28, left: 16, right: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE4E1ED), width: 1)),
      ),
      child: Column(
        children: [
          Container(
            width: 128,
            height: 128,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4648D4), Color(0xFFDAE2FD)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBrandIndigo.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: UserAvatar(
              initial: name.isNotEmpty ? name[0] : '?',
              size: 120,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: AppTextStyles.bold24.copyWith(
              color: const Color(0xFF1B1B23),
              letterSpacing: -0.24,
            ),
            textAlign: TextAlign.center,
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              email,
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF464554),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
