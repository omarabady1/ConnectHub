import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_view_body.dart';

/// Primary Post Details View screen widget.
class PostDetailsView extends StatelessWidget {
  const PostDetailsView({super.key});

  static const String routeName = '/post-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: const PostDetailsTopAppBar(),
      body: const PostDetailsViewBody(),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommentInputBottomBar(),
          HomeBottomNavBar(selectedIndex: 0),
        ],
      ),
    );
  }
}
