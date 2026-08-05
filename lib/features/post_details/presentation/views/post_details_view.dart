import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../home/presentation/views/widgets/home_bottom_nav_bar.dart';
import 'widgets/comment_input_bottom_bar.dart';
import 'widgets/post_details_top_app_bar.dart';
import 'widgets/post_details_view_body.dart';
import '../../../home/domain/models/post_model.dart';

class PostDetailsView extends StatelessWidget {
  static const String routeName = '/post-details';

  final PostModel post;

  const PostDetailsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: const PostDetailsTopAppBar(),
      body: PostDetailsViewBody(post: post),
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
