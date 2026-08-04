import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class CreatePostUserInfo extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const CreatePostUserInfo({
    super.key,
    this.userName = 'Alex Rivers',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=250',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE9E6F3),
            border: Border.all(color: const Color(0x4DC7C4D7), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          userName.isNotEmpty ? userName[0] : 'A',
                          style: AppTextStyles.createPostUserName,
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0] : 'A',
                      style: AppTextStyles.createPostUserName,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(userName, style: AppTextStyles.createPostUserName)],
        ),
      ],
    );
  }
}
