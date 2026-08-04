import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../create_post/presentation/views/create_post_view.dart';
import 'widgets/create_post_add_button.dart';
import 'widgets/home_bottom_nav_bar.dart';
import 'widgets/home_top_app_bar.dart';
import 'widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _feedRefreshKey = 0;

  Future<void> _openCreatePost() async {
    final postCreated = await Navigator.of(
      context,
    ).pushNamed(CreatePostView.routeName);

    if (!mounted || postCreated != true) return;

    setState(() {
      _feedRefreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: const HomeTopAppBar(),
      body: HomeViewBody(key: ValueKey(_feedRefreshKey)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CreatePostAddButton(onPressed: _openCreatePost),
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
    );
  }
}
