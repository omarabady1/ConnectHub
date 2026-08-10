import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/post_details/domain/entities/comment_entity.dart';

abstract class PostDetailsState {
  const PostDetailsState();
}

class PostDetailsInitial extends PostDetailsState {
  const PostDetailsInitial();
}

class PostDetailsLoaded extends PostDetailsState {
  final PostModel post;
  final List<CommentEntity> comments;
  final List<Map<String, String>> likedByUsers;
  final bool isLoadingComments;

  const PostDetailsLoaded({
    required this.post,
    required this.comments,
    this.likedByUsers = const [],
    this.isLoadingComments = false,
  });

  PostDetailsLoaded copyWith({
    PostModel? post,
    List<CommentEntity>? comments,
    List<Map<String, String>>? likedByUsers,
    bool? isLoadingComments,
  }) {
    return PostDetailsLoaded(
      post: post ?? this.post,
      comments: comments ?? this.comments,
      likedByUsers: likedByUsers ?? this.likedByUsers,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
    );
  }
}

class PostDetailsError extends PostDetailsState {
  final String message;

  const PostDetailsError(this.message);
}

class PostDeletedState extends PostDetailsState {
  final String postId;

  const PostDeletedState(this.postId);
}
