part of 'add_doner_request_cubit.dart';

sealed class AddDonerRequestState {}

final class AddDonerRequestInitial extends AddDonerRequestState {}

final class AddDonerRequestLoading extends AddDonerRequestState {}

final class AddDonerRequestFailure extends AddDonerRequestState {
  final String errMessage;

  AddDonerRequestFailure(this.errMessage);
}

final class AddDonerRequestSuccess extends AddDonerRequestState {
  // final String message;

  // AddProductSuccess(this.message);
}
