import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class CreatePostTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onClosePressed;
  final VoidCallback? onPostPressed;

  const CreatePostTopAppBar({
    super.key,
    this.onClosePressed,
    this.onPostPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: kHomeBackgroundColor.withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onClosePressed ?? () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: kTextDarkColor,
              size: 24,
            ),
          ),
          Text(
            'Create Post',
            style: AppTextStyles.bold24.copyWith(
              color: kBrandIndigo,
              letterSpacing: -0.6,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kBrandIndigo,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: const Color(0x4DE1E0FF),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBrandIndigo.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPostPressed ?? () {},
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 9,
                  ),
                  child: Text(
                    'Post',
                    style: AppTextStyles.medium12.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
