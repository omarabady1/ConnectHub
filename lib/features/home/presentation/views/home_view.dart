import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../chatbot/presentaion/views/widgets/chatbot_top_app_bar.dart';
import '../../../chatbot/presentaion/views/widgets/chatbot_view_body.dart';
import '../../../create_post/presentation/views/create_post_view.dart';
import '../../../profile/presentation/views/widgets/profile_drawer.dart';
import '../../../profile/presentation/views/widgets/profile_top_app_bar.dart';
import '../../../profile/presentation/views/widgets/profile_view_body.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatBodyKey = GlobalKey<ChatbotViewBodyState>();
  int _selectedIndex = 0;
  int _feedRefreshKey = 0;

  void _onTabChanged(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _openCreatePost() async {
    final postCreated = await Navigator.of(
      context,
    ).pushNamed(CreatePostView.routeName);

    if (!mounted || postCreated != true) return;

    setState(() {
      _feedRefreshKey++;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_selectedIndex) {
      case 1:
        return ChatbotTopAppBar(
          onClearChat: () =>
              _chatBodyKey.currentState?.clearChat(),
        );
      case 2:
        return ProfileTopAppBar(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        );
      default:
        return HomeTopAppBar(
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kHomeBackgroundColor,
      appBar: _buildAppBar(),
      drawer: const ProfileDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeViewBody(key: ValueKey(_feedRefreshKey)),
          ChatbotViewBody(key: _chatBodyKey),
          const ProfileViewBody(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CreatePostAddButton(onPressed: _openCreatePost),
            )
          : null,
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabChanged,
      ),
    );
  }
}
