import 'package:flutter/material.dart';
import '../../../../../utils/app_text_styles.dart';

class LikedBySection extends StatelessWidget {
  const LikedBySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('Liked By', style: AppTextStyles.likedByTitle),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('David K.', style: AppTextStyles.commentAuthorName),
                  Text('Product Designer', style: AppTextStyles.postSubtitle),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sarah J.', style: AppTextStyles.commentAuthorName),
                  Text('Developer', style: AppTextStyles.postSubtitle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
