import 'package:blood_bank/feature/auth/domain/entites/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());
  final AuthRepo authRepo;

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    // ignore: non_constant_identifier_names
    String name,
    // ignore: non_constant_identifier_names
  ) async {
    emit(SignupLoding());
    final result = await authRepo.createUserWithEmailAndPassword(
      email,
      password,
      name,
    );
    result.fold(
      (failuer) {
        emit(SignupFailure(message: failuer.message));
      },
      (userEntity) {
        emit(SignupSuccess(userEntity: userEntity));
      },
    );
  }
}
