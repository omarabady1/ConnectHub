import 'package:connect_hub/core/helper_functions.dart/get_current_user.dart';
import 'package:connect_hub/core/utils/user_avatar.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class CreatePostUserInfo extends StatelessWidget {
  const CreatePostUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();
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
