import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/profile_top_app_bar.dart';
import 'widgets/profile_view_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: ProfileTopAppBar(),
      body: ProfileViewBody(),
      bottomNavigationBar: HomeBottomNavBar(selectedIndex: 3),
    );
  }
}
