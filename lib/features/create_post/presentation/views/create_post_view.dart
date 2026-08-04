import 'package:flutter/material.dart';
import 'widgets/create_post_top_app_bar.dart';
import 'widgets/create_post_view_body.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  static const String routeName = '/create-post';

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onPost() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CreatePostTopAppBar(
        onClosePressed: () => Navigator.of(context).pop(),
        onPostPressed: _onPost,
      ),
      body: CreatePostViewBody(
        titleController: _titleController,
        descriptionController: _descriptionController,
      ),
    );
  }
}
