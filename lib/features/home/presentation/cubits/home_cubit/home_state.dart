import 'package:connect_hub/features/home/data/models/post_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<PostModel> posts;

  HomeSuccess(this.posts);
}

final class HomeFailure extends HomeState {
  final String errMessage;

  HomeFailure(this.errMessage);
}
