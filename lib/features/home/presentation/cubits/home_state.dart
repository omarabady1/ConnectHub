part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.posts});
  final List<PostModel> posts;
}

final class HomeError extends HomeState {
  const HomeError({required this.errMessage});
  final String errMessage;
}
