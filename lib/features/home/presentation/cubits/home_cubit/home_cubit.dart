import 'dart:async';
import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:connect_hub/features/home/domain/repos/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  HomeCubit(this._homeRepo) : super(HomeInitial());

  void fetchPosts() {
    emit(HomeLoading());
    _postsSubscription?.cancel();
    _postsSubscription = _homeRepo.getPostsStream().listen(
      (posts) {
        emit(HomeSuccess(posts));
      },
      onError: (error) {
        emit(HomeFailure(error.toString()));
      },
    );
  }

  Future<void> toggleLike({
    required String postId,
    required String userId,
    required bool currentlyLiked,
  }) async {
    try {
      await _homeRepo.toggleLike(
        postId: postId,
        userId: userId,
        currentlyLiked: currentlyLiked,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _homeRepo.deletePost(postId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
