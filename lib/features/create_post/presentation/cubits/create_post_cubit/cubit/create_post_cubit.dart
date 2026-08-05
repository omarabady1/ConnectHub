import 'dart:developer';
import 'dart:io';
import 'package:connect_hub/core/services/cloud_storage_service.dart';
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit({
    required this.databaseService,
    required this.cloudStorageService,
    required this.authRepo,
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       super(const CreatePostInitial());

  final DatabaseService databaseService;
  final CloudStorageService cloudStorageService;
  final AuthRepo authRepo;
  final ImagePicker _imagePicker;

  Future<void> pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedImage == null) return;

      emit(CreatePostImageSelected(File(pickedImage.path)));
    } catch (error, stackTrace) {
      log(
        'Exception in CreatePostCubit.pickImage: $error',
        stackTrace: stackTrace,
      );
      emit(
        CreatePostError(
          'Unable to pick image, please try again.',
          selectedImage: state.selectedImage,
        ),
      );
    }
  }

  void removeSelectedImage() {
    emit(const CreatePostInitial());
  }

  Future<void> createPost({
    required String title,
    required String content,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedContent = content.trim();
    final selectedImage = state.selectedImage;

    if (trimmedTitle.isEmpty || trimmedContent.isEmpty) {
      emit(
        CreatePostError(
          'Please add a title and description.',
          selectedImage: selectedImage,
        ),
      );
      return;
    }

    emit(CreatePostLoading(selectedImage: selectedImage));

    try {
      final postId = DateTime.now().microsecondsSinceEpoch.toString();
      final imageUrl = selectedImage == null
          ? null
          : await cloudStorageService.uploadFile(selectedImage, postId);
      final user = _currentUser();
      final authorName = _currentUserName(user);
      final post = PostModel(
        id: postId,
        userId: user?.userID ?? '',
        authorName: authorName,
        authorRole: 'Member',
        timeAgo: DateTime.now().difference(DateTime.now()).inSeconds.toString(),
        avatarUrl: user?.avatarUrl,
        avatarInitial: _currentUserInitial(authorName),
        postTitle: trimmedTitle,
        postContent: trimmedContent,
        mainImageUrl: imageUrl,
        likesCount: 0,
        commentsCount: 0,
      );

      await databaseService.addData(
        path: BackendEndpoints.posts,
        data: post.toMap(),
        docId: postId,
      );

      emit(const CreatePostSuccess());
    } catch (error, stackTrace) {
      log(
        'Exception in CreatePostCubit.createPost: $error',
        stackTrace: stackTrace,
      );
      emit(
        CreatePostError(
          'Unable to create post, please try again.',
          selectedImage: selectedImage,
        ),
      );
    }
  }

  UserEntity? _currentUser() => authRepo.getCachedUser();

  String _currentUserName(UserEntity? user) {
    if (user == null || user.name.trim().isEmpty) return 'Anonymous';

    return user.name;
  }

  String _currentUserInitial(String userName) {
    return userName.isEmpty ? 'A' : userName[0].toUpperCase();
  }
}
