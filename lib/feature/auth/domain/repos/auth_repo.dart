import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/auth/domain/entites/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
    // ignore: non_constant_identifier_names
    String email,
    String password,
    String name,
  );

  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failures, UserEntity>> signInWithGoogle();
  Future<Either<Failures, UserEntity>> signInWithFacebook();
  Future<Either<Failures, void>> sendPasswordResetLink(String email);
  Future addUserData({required UserEntity user});
  Future<UserEntity> getUserData({required String uid});
}
