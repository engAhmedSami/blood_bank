part of 'add_need_request_cubit.dart';

sealed class AddNeedRequestState {}

final class AddNeedRequestInitial extends AddNeedRequestState {}

final class AddNeedRequestLoading extends AddNeedRequestState {}

final class AddNeedRequestFailure extends AddNeedRequestState {
  final String errMessage;

  AddNeedRequestFailure(this.errMessage);
}

final class AddNeedRequestSuccess extends AddNeedRequestState {}
