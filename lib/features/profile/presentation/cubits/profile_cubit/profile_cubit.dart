import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_hub/features/home/domain/models/post_model.dart';
import 'package:connect_hub/features/profile/domain/entities/user_profile_entity.dart';
import 'package:connect_hub/features/profile/domain/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  void loadProfile() {
    emit(ProfileLoading());

    final userProfile = _profileRepo.getCachedUserProfile();
    if (userProfile == null) {
      emit(ProfileError('User profile not found'));
      return;
    }

    _postsSubscription?.cancel();
    _postsSubscription =
        _profileRepo.getUserPostsStream(userProfile.userID).listen(
      (posts) {
        emit(
          ProfileLoaded(
            userProfile: userProfile,
            posts: posts,
          ),
        );
      },
      onError: (error) {
        emit(ProfileError(error.toString()));
      },
    );
  }

  Future<void> deletePost(String postId) async {
    try {
      await _profileRepo.deletePost(postId);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _profileRepo.signOut();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
