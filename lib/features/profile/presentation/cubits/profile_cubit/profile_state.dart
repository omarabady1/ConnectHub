part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserProfileEntity userProfile;
  final List<PostModel> posts;

  ProfileLoaded({
    required this.userProfile,
    required this.posts,
  });
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

final class ProfileLogoutSuccess extends ProfileState {}
