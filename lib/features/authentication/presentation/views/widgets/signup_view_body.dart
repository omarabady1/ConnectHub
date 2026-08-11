import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/signup_cubit/cubit/signup_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/login_view.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/auth_text_field.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/social_button.dart';
import 'package:connect_hub/generated/assets.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:connect_hub/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitSignUp(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showCustomSnackBar(context, 'Please fill in all fields.');
      return;
    }

    if (password.length < 8) {
      showCustomSnackBar(context, 'Password must be at least 8 characters.');
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackBar(context, 'Passwords do not match.');
      return;
    }

    context.read<SignUpCubit>().createUserWithEmailAndPassword(
      email,
      password,
      name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
          showCustomSnackBar(context, state.errMessage);
        }

        if (state is SignUpSuccess) {
          showCustomSnackBar(
            context,
            'Account created successfully.',
            isError: false,
          );
          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        }
      },
      builder: (context, state) {
        final isLoading = state is SignUpLoading;
        final passwordText = _passwordController.text;
        final confirmPasswordText = _confirmPasswordController.text;
        final isConfirmNotEmpty = confirmPasswordText.isNotEmpty;
        final isPasswordMatch =
            isConfirmNotEmpty && confirmPasswordText == passwordText;

        Widget? confirmSuffixIcon;
        if (isConfirmNotEmpty) {
          confirmSuffixIcon = Icon(
            isPasswordMatch ? Icons.check_circle : Icons.cancel,
            color: isPasswordMatch
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
          );
        }

        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
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
                      child: Text(
                        'Join the Community',
                        style: AppTextStyles.bold28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Create your ConnectHub account.',
                        style: AppTextStyles.medium15.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'FULL NAME',
                      style: AppTextStyles.semiBold12.copyWith(
                        letterSpacing: 0.8,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _nameController,
                      hintText: 'John Doe',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'EMAIL ADDRESS',
                      style: AppTextStyles.semiBold12.copyWith(
                        letterSpacing: 0.8,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _emailController,
                      hintText: 'you@example.com',
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PASSWORD',
                      style: AppTextStyles.semiBold12.copyWith(
                        letterSpacing: 0.8,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _passwordController,
                      hintText: '********',
                      icon: Icons.lock_outline,
                      isPasswordField: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Must be at least 8 characters.',
                      style: AppTextStyles.regular13.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CONFIRM PASSWORD',
                      style: AppTextStyles.semiBold12.copyWith(
                        letterSpacing: 0.8,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      hintText: '********',
                      icon: Icons.lock_outline,
                      isPasswordField: true,
                      suffixIcon: confirmSuffixIcon,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (isConfirmNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            isPasswordMatch
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            size: 14,
                            color: isPasswordMatch
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPasswordMatch
                                ? 'Passwords match'
                                : 'Passwords do not match',
                            style: AppTextStyles.regular13.copyWith(
                              color: isPasswordMatch
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => _submitSignUp(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: AppTextStyles.bold16.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: AppTextStyles.bold16.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_right_alt, size: 20),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'or continue with',
                          style: AppTextStyles.regular13.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SocialButton(
                      label: 'Continue with Google',
                      icon: SvgPicture.asset(Assets.assetsIconsGoogleIcon),
                      backgroundColor: const Color(0xFFF8FAFC),
                      textColor: kTertiaryColor,
                      onPressed: () =>
                          context.read<SignUpCubit>().signUpWithGoogle(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.regular13.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(LoginView.routeName);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(44, 22),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Log In',
                            style: AppTextStyles.semiBold13.copyWith(
                              color: const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
