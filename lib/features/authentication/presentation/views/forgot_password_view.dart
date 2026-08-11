import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/forgot_password_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  static const String routeName = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(authRepo: getIt<AuthRepo>()),
      child: const Scaffold(
        backgroundColor: kSecondaryColor,
        body: ForgotPasswordViewBody(),
      ),
    );
  }
}
