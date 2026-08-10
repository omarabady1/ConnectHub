import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';
import 'package:connect_hub/features/profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/profile_top_app_bar.dart';
import 'widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(getIt<ProfileRepo>())..loadProfile(),
      child: const Scaffold(
        backgroundColor: kHomeBackgroundColor,
        appBar: ProfileTopAppBar(),
        body: ProfileViewBody(),
        bottomNavigationBar: HomeBottomNavBar(selectedIndex: 3),
      ),
    );
  }
}

