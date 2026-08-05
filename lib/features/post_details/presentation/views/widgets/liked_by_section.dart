import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../core/utils/user_avatar.dart';

class LikedBySection extends StatelessWidget {
  final List<Map<String, String>> likedByUsers;

  const LikedBySection({super.key, this.likedByUsers = const []});

  @override
  Widget build(BuildContext context) {
    if (likedByUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Liked By',
            style: AppTextStyles.semiBold20.copyWith(
              color: const Color(0xFF1B1B23),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 8),
              for (final user in likedByUsers) ...[
                _LikedByUserTile(
                  name: user['name'] ?? 'User',
                  role: user['role'] ?? 'Member',
                  avatarUrl: user['avatarUrl'],
                  avatarInitial: user['avatarInitial'],
                ),
                const SizedBox(width: 24),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LikedByUserTile extends StatelessWidget {
  final String name;
  final String role;
  final String? avatarUrl;
  final String? avatarInitial;

  const _LikedByUserTile({
    required this.name,
    required this.role,
    this.avatarUrl,
    this.avatarInitial,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(
          avatarUrl: avatarUrl,
          initial: avatarInitial ??
              (name.isNotEmpty ? name[0] : '?'),
          size: 28,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.semiBold12.copyWith(
                color: const Color(0xFF1B1B23),
              ),
            ),
            Text(
              role,
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF5C5F61),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
