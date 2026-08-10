import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/utils/user_avatar.dart';
import 'package:connect_hub/features/create_post/domain/repos/create_post_repo.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class CreatePostUserInfo extends StatelessWidget {
  const CreatePostUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<CreatePostRepo>().getCachedUser();
    final name = user?.name ?? '';
    final initial = name.isNotEmpty ? name[0] : 'A';

    return Row(
      children: [
        UserAvatar(
          avatarUrl: user?.avatarUrl,
          initial: initial,
          size: 40,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: AppTextStyles.medium16.copyWith(
                color: const Color(0xFF1B1B23),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
