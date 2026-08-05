import 'dart:developer' as developer;
import 'package:connect_hub/core/services/database_service.dart';
import 'package:connect_hub/core/utils/backend_endpoints.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this._databaseService})
      : super(const HomeInitial());

  final DatabaseService _databaseService;

  Future<void> loadPosts() async {
    emit(const HomeLoading());
    try {
      final postsData = await _databaseService.getData(
        path: BackendEndpoints.posts,
        query: const {'orderBy': 'createdAt', 'descending': true},
      );

      if (postsData is! List) {
        emit(const HomeLoaded(posts: []));
        return;
      }

      final firebasePosts = postsData
          .whereType<Map<String, dynamic>>()
          .map(PostModel.fromMap)
          .toList();

      emit(HomeLoaded(posts: firebasePosts));
    } catch (e, s) {
      developer.log(
        'Failed to load posts',
        name: 'HomeCubit',
        error: e,
        stackTrace: s,
      );
      emit(HomeError(errMessage: e.toString()));
    }
  }

  void updatePost(PostModel updatedPost) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final currentPosts = currentState.posts;
      final postIndex = currentPosts.indexWhere((p) => p.id == updatedPost.id);
      
      if (postIndex != -1) {
        final newPosts = List<PostModel>.from(currentPosts);
        newPosts[postIndex] = updatedPost;
        emit(HomeLoaded(posts: newPosts));
      }
    }
  }
}
