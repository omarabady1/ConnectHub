import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/forgot_password_view_body.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  static const String routeName = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kSecondaryColor,
      body: ForgotPasswordViewBody(),
    );
  }
}
