import 'package:flutter/material.dart';
import '../../../../constants.dart';
import 'widgets/create_post_add_button.dart';
import 'widgets/home_bottom_nav_bar.dart';
import 'widgets/home_top_app_bar.dart';
import 'widgets/home_view_body.dart';

/// Primary Home View screen displaying ConnectHub feed.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: const HomeTopAppBar(),
      body: const HomeViewBody(),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: CreatePostAddButton(),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
