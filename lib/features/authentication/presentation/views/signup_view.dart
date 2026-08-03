import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/signup_cubit/cubit/signup_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/signup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  static const String routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(getIt<AuthRepo>()),
      child: Scaffold(backgroundColor: kSecondaryColor, body: SignUpViewBody()),
    );
  }
}
