import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/login_cubit/cubit/login_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/signup_view.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/auth_text_field.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/social_button.dart';
import 'package:connect_hub/generated/assets.dart';
import 'package:connect_hub/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    context.read<LoginCubit>().signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful.')));
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginaLoading;

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
                        'ConnectHub',
                        style: AppTextStyles.loginTitle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Welcome back to the community.',
                        style: AppTextStyles.loginSubtitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text('EMAIL ADDRESS', style: AppTextStyles.inputLabel),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _emailController,
                      hintText: 'you@example.com',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),
                    Text('PASSWORD', style: AppTextStyles.inputLabel),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _passwordController,
                      hintText: '**************',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: isLoading ? null : () => _submitLogin(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: AppTextStyles.loginButton,
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
                                  'Log In',
                                  style: AppTextStyles.loginButton,
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
                          'OR CONTINUE WITH',
                          style: AppTextStyles.secondaryText,
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
                          context.read<LoginCubit>().signInWithGoogle(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.secondaryText,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(SignupView.routeName);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(44, 22),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('Sign Up', style: AppTextStyles.linkText),
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
