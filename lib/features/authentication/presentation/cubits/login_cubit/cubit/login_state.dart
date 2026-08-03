part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginaLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  final UserEntity userEntity;
  LoginSuccess(this.userEntity);
}

final class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure(this.errMessage);
}
