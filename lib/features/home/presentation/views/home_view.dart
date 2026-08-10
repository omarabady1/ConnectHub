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

final GlobalKey<HomeViewState> homeViewKey = GlobalKey<HomeViewState>();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static const String routeName = '/home';

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatBodyKey = GlobalKey<ChatbotViewBodyState>();
  int _selectedIndex = 0;

  void onTabChanged(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _openCreatePost() async {
    await Navigator.of(context).pushNamed(CreatePostView.routeName);
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
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          setState(() => _selectedIndex = 0);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kHomeBackgroundColor,
        appBar: _buildAppBar(),
        drawer: const ProfileDrawer(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const HomeViewBody(),
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
          onItemTapped: onTabChanged,
        ),
      ),
    );
  }
}
