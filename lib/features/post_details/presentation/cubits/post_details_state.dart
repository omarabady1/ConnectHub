part of 'post_details_cubit.dart';

sealed class PostDetailsState {
  const PostDetailsState({
    required this.post,
    this.comments = const [],
    this.likedByUsers = const [],
    this.isSendingComment = false,
    this.errorMessage,
  });

  final PostModel post;
  final List<CommentModel> comments;
  final List<Map<String, String>> likedByUsers;
  final bool isSendingComment;
  final String? errorMessage;
}

final class PostDetailsInitial extends PostDetailsState {
  const PostDetailsInitial({required super.post});
}

final class PostDetailsLoading extends PostDetailsState {
  const PostDetailsLoading({
    required super.post,
    super.comments,
    super.likedByUsers,
    super.isSendingComment,
  });
}

final class PostDetailsSuccess extends PostDetailsState {
  const PostDetailsSuccess({
    required super.post,
    required super.comments,
    required super.likedByUsers,
    super.isSendingComment,
    super.errorMessage,
  });

  PostDetailsSuccess copyWith({
    PostModel? post,
    List<CommentModel>? comments,
    List<Map<String, String>>? likedByUsers,
    bool? isSendingComment,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PostDetailsSuccess(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      likedByUsers: likedByUsers ?? this.likedByUsers,
      isSendingComment: isSendingComment ?? this.isSendingComment,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final class PostDetailsFailure extends PostDetailsState {
  const PostDetailsFailure({
    required super.post,
    required super.errorMessage,
    super.comments,
    super.likedByUsers,
    super.isSendingComment,
  });
}
