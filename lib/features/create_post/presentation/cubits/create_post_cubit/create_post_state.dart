part of 'create_post_cubit.dart';

sealed class CreatePostState {
  const CreatePostState({this.selectedImage});

  final File? selectedImage;
}

final class CreatePostInitial extends CreatePostState {
  const CreatePostInitial() : super();
}

final class CreatePostImageSelected extends CreatePostState {
  const CreatePostImageSelected(File selectedImage)
      : super(selectedImage: selectedImage);
}

final class CreatePostLoading extends CreatePostState {
  const CreatePostLoading({super.selectedImage});
}

final class CreatePostSuccess extends CreatePostState {
  const CreatePostSuccess() : super();
}

final class CreatePostError extends CreatePostState {
  const CreatePostError(this.errMessage, {super.selectedImage});

  final String errMessage;
}
