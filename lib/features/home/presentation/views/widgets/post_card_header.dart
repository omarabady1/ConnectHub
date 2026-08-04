import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class PostCardHeader extends StatelessWidget {
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String? avatarUrl;
  final String? avatarInitial;
  final bool isCurrentUser;
  final VoidCallback? onMorePressed;

  const PostCardHeader({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    this.avatarUrl,
    this.avatarInitial,
    this.isCurrentUser = false,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    authorName,
                    style: isCurrentUser
                        ? AppTextStyles.semiBold12.copyWith(
                            color: const Color(0xFF1B1B23),
                          )
                        : AppTextStyles.medium12.copyWith(
                            color: const Color(0xFF1B1B23),
                          ),
                  ),
                  if (isCurrentUser) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'YOUR POST',
                        style: AppTextStyles.regular10.copyWith(
                          color: const Color(0xFF4648D4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '$authorRole • $timeAgo',
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF5C5F61),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onMorePressed ?? () {},
          icon: const Icon(
            Icons.more_horiz,
            color: kTextSecondaryColor,
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isCurrentUser
              ? Border.all(color: kBrandIndigo, width: 2)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Image.network(
            avatarUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: const Color(0xFFE9E6F3),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE9E6F3),
                child: Center(
                  child: Text(
                    authorName.isNotEmpty ? authorName[0] : '?',
                    style: AppTextStyles.semiBold16,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF6C748B),
        shape: BoxShape.circle,
        border: isCurrentUser
            ? Border.all(color: kBrandIndigo, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          avatarInitial ?? (authorName.isNotEmpty ? authorName[0] : 'M'),
          style: AppTextStyles.semiBold20.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
