part of 'signup_cubit.dart';

sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  final UserEntity userEntity;
  SignUpSuccess(this.userEntity);
}

final class SignUpFailure extends SignUpState {
  final String errMessage;
  SignUpFailure(this.errMessage);
}
