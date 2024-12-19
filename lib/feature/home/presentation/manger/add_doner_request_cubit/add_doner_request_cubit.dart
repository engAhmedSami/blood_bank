import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_donner_request_state.dart';

class AddDonerRequestCubit extends Cubit<AddDonerRequestState> {
  AddDonerRequestCubit(
    this.donerRepo,
  ) : super(AddDonerRequestInitial());

  final DonerRepo donerRepo;

  Future<void> addRequest(DonerRequestEntity addRequestInputEntity) async {
    emit(AddDonerRequestLoading());
    final result = await donerRepo.addRequest(addRequestInputEntity);
    result.fold(
      (f) => emit(
        AddDonerRequestFailure(f.message),
      ),
      (r) => emit(
        AddDonerRequestSuccess(),
      ),
    );
  }
}
