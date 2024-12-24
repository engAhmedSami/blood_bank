import 'package:blood_bank/feature/auth/domain/entites/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;

  Future<void> signIn(String email, String password) async {
    emit(SigninLoading());

    final result = await authRepo.signInWithEmailAndPassword(
      email,
      password,
    );

    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (success) async {
        final userStat = await checkUserStatus(success.uId);
        if (userStat == 'blocked') {
          emit(SigninBlocked());
        } else {
          emit(SigninSuccess(userEntity: success));
        }
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithGoogle();

    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (success) async {
        final userStat = await checkUserStatus(success.uId);
        if (userStat == 'blocked') {
          emit(SigninBlocked());
        } else {
          emit(SigninSuccess(userEntity: success));
        }
      },
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SigninLoading());
    final result = await authRepo.signInWithFacebook();

    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (success) async {
        final userStat = await checkUserStatus(success.uId);
        if (userStat == 'blocked') {
          emit(SigninBlocked());
        } else {
          emit(SigninSuccess(userEntity: success));
        }
      },
    );
  }

  Future<void> sendPasswordResetLink(String email) async {
    emit(SigninLoading());

    final result = await authRepo.sendPasswordResetLink(email);

    result.fold(
      (failure) => emit(SigninFailure(message: failure.message)),
      (_) => emit(SigninSuccess(
          userEntity: UserEntity(
        name: '',
        email: email,
        uId: '',
      ))),
    );
  }

  Future<String> checkUserStatus(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['userStat'] ?? 'allowed';
      }
    } catch (e) {
      // Log or handle the error as needed.
    }
    return 'allowed';
  }
}
