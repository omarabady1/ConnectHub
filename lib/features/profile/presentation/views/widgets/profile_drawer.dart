import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/authentication/presentation/views/login_view.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/user_avatar.dart';
import '../../../../../utils/app_text_styles.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await getIt<ProfileRepo>().signOut();

    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = getIt<ProfileRepo>().getCachedUserProfile();
    final name = userProfile?.name ?? 'User';
    final email = userProfile?.email ?? '';

    return SafeArea(
      child: Drawer(
        backgroundColor: kHomeBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 24),
            UserAvatar(
              avatarUrl: userProfile?.avatarUrl,
              initial: name.isNotEmpty ? name[0] : '?',
              size: 80,
              border: Border.all(color: kBrandIndigo, width: 2),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: AppTextStyles.bold24.copyWith(
                color: const Color(0xFF1B1B23),
              ),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF464554),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE4E1ED)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
