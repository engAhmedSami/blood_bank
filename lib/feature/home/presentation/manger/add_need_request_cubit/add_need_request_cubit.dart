// import 'package:blood_bank/feature/notification/notification_service.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
// import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';

// part 'add_need_request_state.dart';

// class AddNeederRequestCubit extends Cubit<AddNeedRequestState> {
//   AddNeederRequestCubit(this.neederRepo) : super(AddNeedRequestInitial());

//   final NeederRepo neederRepo;

//   Future<void> addNeederRequest(
//       NeederRequestEntity addNeederInputEntity) async {
//     emit(AddNeedRequestLoading());
//     final result = await neederRepo.addNeederRequest(addNeederInputEntity);
//     result.fold(
//       (f) => emit(AddNeedRequestFailure(f.message)),
//       (r) async {
//         emit(AddNeedRequestSuccess());
//         await NotificationService.instance.sendNotificationToAllUsers(
//           title: 'New Blood Request',
//           body: '${addNeederInputEntity.patientName} needs blood!',
//           data: {
//             'type': 'new_request',
//             'request_id': addNeederInputEntity.uId,
//           },
//         );
//       },
//     );
//   }
// }
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_need_request_state.dart';

class AddNeederRequestCubit extends Cubit<AddNeedRequestState> {
  AddNeederRequestCubit(this.neederRepo) : super(AddNeedRequestInitial());

  final NeederRepo neederRepo;

  Future<void> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    emit(AddNeedRequestLoading());
    final result = await neederRepo.addNeederRequest(addNeederInputEntity);
    result.fold(
      (f) => emit(AddNeedRequestFailure(f.message)),
      (r) async {
        emit(AddNeedRequestSuccess());

        final user = FirebaseAuth.instance.currentUser;
        final userName = user?.displayName ?? 'Anonymous';
        final userEmail = user?.email ?? 'No Email';
        final photoUrl = user?.photoURL ?? '';

        await NotificationService.instance.sendNotificationToAllUsers(
          title: 'New Blood Request',
          body: '${addNeederInputEntity.patientName} needs blood!',
          data: {
            'type': 'new_request',
            'request_id': addNeederInputEntity.uId,
            'user_name': userName,
            'user_email': userEmail,
            'photoUrl': photoUrl,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      },
    );
  }
}
