import 'dart:convert';
import 'dart:developer';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/errors/exceptions.dart';
import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/core/services/firebase_auth_service.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/core/utils/backend_endpoint.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/auth/domain/entites/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseService;

  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failures, UserEntity>> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      var user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userEntity = UserModel.fromFirebaseUser(user);

      await addUserData(user: userEntity);
      return right(userEntity);
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.createUserWithEmailAndPassword :${e.toString()}',
      );
      return left(
        ServerFailure(
          'An error occurred. Please try again later.',
        ),
      );
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      var userEntity = await getUserData(uid: user.uid);
      await saveUserData(user: userEntity);
      return right(
        UserModel.fromFirebaseUser(user),
      );
    } on CustomExceptions catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signInWithEmailAndPassword :${e.toString()}',
      );
      return left(
        ServerFailure(
          'An error occurred. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return left(ServerFailure('failed to sign in with google'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // تخزين البيانات في Firebase
        final userEntity = UserModel.fromFirebaseUser(user);
        await addUserData(user: userEntity);
        return right(userEntity);
      } else {
        return left(ServerFailure(
          'Failed to sign in with Google',
        ));
      }
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      return left(ServerFailure(
        'An error occurred. Please try again later.',
      ));
    }
  }

  @override
  Future<Either<Failures, UserEntity>> signInWithFacebook() async {
    try {
      var user = await firebaseAuthService.signInWithFacebook();
      return right(
        UserModel.fromFirebaseUser(user),
      );
    } catch (e) {
      log(
        'Exception in AuthRepoImpl.signInWithFacebook :${e.toString()}',
      );
      return left(
        ServerFailure(
          'An error occurred. Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failures, void>> sendPasswordResetLink(String email) async {
    try {
      await firebaseAuthService.sendPasswordResetLink(email: email);
      return right(null);
    } on CustomExceptions catch (e) {
      log('FirebaseAuthException in AuthRepoImpl.sendPasswordResetLink :${e.toString()}');

      return left(ServerFailure(e.message));
    } catch (e) {
      log('Exception in AuthRepoImpl.sendPasswordResetLink :${e.toString()}');
      return left(ServerFailure('An error occurred. Please try again later.'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) {
    return databaseService.addData(
        path: BackendEndpoint.addUserData,
        data: user.toMap(),
        docuementId: user.uId);
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    var userData = await databaseService.getData(
        path: BackendEndpoint.getUserData, docuementId: uid);

    return UserModel.fromJson(userData);
  }

  Future<void> saveUserData({required UserEntity user}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }
}
