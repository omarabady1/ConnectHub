import 'dart:developer';
import 'dart:io';
import 'package:connect_hub/features/create_post/domain/repos/create_post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit({
    required this.createPostRepo,
    ImagePicker? imagePicker,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        super(const CreatePostInitial());

  final CreatePostRepo createPostRepo;
  final ImagePicker _imagePicker;

  Future<void> pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 35,
        maxWidth: 1280,
        maxHeight: 1280,
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
      await createPostRepo.createPost(
        title: trimmedTitle,
        content: trimmedContent,
        image: selectedImage,
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
}
