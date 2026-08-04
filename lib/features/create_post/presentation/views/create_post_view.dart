import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/services/cloud_storage_service.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/features/create_post/presentation/cubits/create_post_cubit/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void _onPost(BuildContext context) {
    context.read<CreatePostCubit>().createPost(
      title: _titleController.text,
      content: _descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostCubit(
        databaseService: getIt<DatabaseService>(),
        cloudStorageService: getIt<CloudStorageService>(),
      ),
      child: BlocConsumer<CreatePostCubit, CreatePostState>(
        listener: (context, state) {
          if (state is CreatePostSuccess && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post created successfully.')),
            );
            Navigator.of(context).pop(true);
          }

          if (state is CreatePostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        builder: (context, state) {
          final isPosting = state is CreatePostLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: CreatePostTopAppBar(
              isPosting: isPosting,
              onClosePressed: () => Navigator.of(context).pop(),
              onPostPressed: () => _onPost(context),
            ),
            body: CreatePostViewBody(
              titleController: _titleController,
              descriptionController: _descriptionController,
              selectedImage: state.selectedImage,
              onAddImagePressed: isPosting
                  ? null
                  : () => context.read<CreatePostCubit>().pickImage(),
              onRemoveImagePressed: isPosting
                  ? null
                  : () => context.read<CreatePostCubit>().removeSelectedImage(),
            ),
          );
        },
      ),
    );
  }
}
