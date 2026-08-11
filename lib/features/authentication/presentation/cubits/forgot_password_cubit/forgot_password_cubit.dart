import 'package:connect_hub/features/authentication/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required this.authRepo})
    : super(ForgotPasswordInitial());

  final AuthRepo authRepo;

  Future<void> sendPasswordResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    final result = await authRepo.sendPasswordResetEmail(email);
    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(ForgotPasswordSuccess()),
    );
  }
}
