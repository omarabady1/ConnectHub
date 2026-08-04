import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

/// Posts tab selector bar matching Figma node 1:516.
class ProfileFeedTabs extends StatelessWidget {
  const ProfileFeedTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE4E1ED), width: 1),
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: kBrandIndigo, width: 2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.grid_view_rounded,
                color: kBrandIndigo,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'POSTS',
                style: AppTextStyles.semiBold12.copyWith(
                  color: kBrandIndigo,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
