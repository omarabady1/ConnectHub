import 'package:connect_hub/constants.dart';
import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/authentication/presentation/cubits/login_cubit/cubit/login_cubit.dart';
import 'package:connect_hub/features/authentication/presentation/views/widgets/login_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepo:getIt<AuthRepo>()),
      child: Scaffold(backgroundColor: kSecondaryColor, body: LoginViewBody()),
    );
  }
}
