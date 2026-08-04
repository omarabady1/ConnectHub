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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'David K.',
                    style: AppTextStyles.semiBold12.copyWith(
                      color: const Color(0xFF1B1B23),
                    ),
                  ),
                  Text(
                    'Product Designer',
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF5C5F61),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sarah J.',
                    style: AppTextStyles.semiBold12.copyWith(
                      color: const Color(0xFF1B1B23),
                    ),
                  ),
                  Text(
                    'Developer',
                    style: AppTextStyles.regular14.copyWith(
                      color: const Color(0xFF5C5F61),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
