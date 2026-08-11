import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/auth_text_field.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/show_confirm_dialog.dart';
import 'package:connect_hub/generated/assets.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:connect_hub/utils/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForgotPassword(BuildContext context) {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar(context, 'Please enter your email address.');
      return;
    }

    context.read<ForgotPasswordCubit>().sendPasswordResetEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordFailure) {
          showCustomSnackBar(context, state.errMessage);
        }
        if (state is ForgotPasswordSuccess) {
          showConfirmDialog(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;

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
                      child: Text('ConnectHub', style: AppTextStyles.bold28),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Enter your email address to receive a password reset link.',
                        style: AppTextStyles.medium15.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
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
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: isLoading
                          ? null
                          : () => _submitForgotPassword(context),
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
                                  'Send Reset Link',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remembered your password? ',
                          style: AppTextStyles.regular13.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
