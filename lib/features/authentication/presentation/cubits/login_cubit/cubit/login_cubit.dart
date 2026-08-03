import 'package:connect_hub/features/authentication/domain/entities/user_entity.dart';
import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepo}) : super(LoginInitial());

  final AuthRepo authRepo;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(LoginaLoading());
    final result = await authRepo.signInWithEmailAndPassword(email, password);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (userEntity) => emit(LoginSuccess(userEntity)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(LoginaLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (userEntity) => emit(LoginSuccess(userEntity)),
    );
  }
}
