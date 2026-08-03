import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/views/login_view.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/auth_text_field.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/social_button.dart';
import 'package:connect_hub/generated/assets.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            constraints: const BoxConstraints(maxWidth: 420),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: SvgPicture.asset(Assets.assetsIconsAppLogo),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Text('Join the Ecosystem', style: AppTextStyles.loginTitle),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Create your Nexus account.',
                    style: AppTextStyles.loginSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
                Text('FULL NAME', style: AppTextStyles.inputLabel),
                const SizedBox(height: 10),
                AuthTextField(
                  hintText: 'John Doe',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                Text('EMAIL ADDRESS', style: AppTextStyles.inputLabel,),
                const SizedBox(height: 10),
                AuthTextField(
                  hintText: 'you@example.com',
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Text('PASSWORD', style: AppTextStyles.inputLabel),
                const SizedBox(height: 10),
                AuthTextField(
                  hintText: '********',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'Must be at least 8 characters.',
                  style: AppTextStyles.secondaryText,
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: AppTextStyles.loginButton,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sign Up', style: AppTextStyles.loginButton),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_right_alt, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1, color: Color(0xFFE5E7EB))),
                    const SizedBox(width: 12),
                    Text('or continue with', style: AppTextStyles.secondaryText),
                    const SizedBox(width: 12),
                    const Expanded(child: Divider(thickness: 1, color: Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 24),
                SocialButton(
                  label: 'Google',
                  icon: SvgPicture.asset(Assets.assetsIconsGoogleIcon),
                  backgroundColor: const Color(0xFFF8FAFC),
                  textColor: kTertiaryColor,
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.secondaryText),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(LoginView.routeName);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 22),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Log In', style: AppTextStyles.linkText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
