import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_need_request_state.dart';

class AddNeederRequestCubit extends Cubit<AddNeedRequestState> {
  AddNeederRequestCubit(
    this.neederRepo,
  ) : super(AddNeedRequestInitial());

  final NeederRepo neederRepo;

  Future<void> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    emit(AddNeedRequestLoading());
    final result = await neederRepo.addNeederRequest(addNeederInputEntity);
    result.fold(
      (f) => emit(
        AddNeedRequestFailure(f.message),
      ),
      (r) => emit(
        AddNeedRequestSuccess(),
      ),
    );
  }
}
