import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../../../../utils/app_text_styles.dart';

class HomeTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationsPressed;

  const HomeTopAppBar({
    super.key,
    this.onMenuPressed,
    this.onNotificationsPressed,
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
        children: [
          IconButton(
            onPressed: onMenuPressed ?? () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: kTextDarkColor,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'ConnectHub',
                style: AppTextStyles.bold24.copyWith(
                  color: kBrandIndigo,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
