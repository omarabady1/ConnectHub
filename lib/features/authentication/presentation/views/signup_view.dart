import 'package:connect_hub/constants.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: SignUpViewBody(),
    );
  }
}

