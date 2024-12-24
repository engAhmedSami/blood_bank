part of 'signin_cubit.dart';

sealed class SigninState {}

final class SigninInitial extends SigninState {}

final class SigninLoading extends SigninState {}

class SigninCodeSent extends SigninState {
  final String verificationId;

  SigninCodeSent(this.verificationId);
}

final class SigninSuccess extends SigninState {
  final UserEntity userEntity;
  SigninSuccess({required this.userEntity});
}

final class SigninFailure extends SigninState {
  final String message;
  SigninFailure({required this.message});
}

// Add the missing SigninBlocked class
final class SigninBlocked extends SigninState {}
