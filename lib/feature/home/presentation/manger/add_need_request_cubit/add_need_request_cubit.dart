import 'dart:developer';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_need_request_state.dart';

class AddNeederRequestCubit extends Cubit<AddNeedRequestState> {
  AddNeederRequestCubit(this.neederRepo) : super(AddNeedRequestInitial());

  final NeederRepo neederRepo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    emit(AddNeedRequestLoading());
    final result = await neederRepo.addNeederRequest(addNeederInputEntity);
    result.fold(
      (f) => emit(AddNeedRequestFailure(f.message)),
      (r) async {
        emit(AddNeedRequestSuccess());

        // جلب بيانات المستخدم من Firestore
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid;

        String userName = user?.displayName ?? 'Anonymous';
        String userEmail = user?.email ?? 'No Email';
        String photoUrl = ''; // سيتم جلب الرابط من Firestore

        if (userId != null) {
          try {
            final userDoc =
                await _firestore.collection('users').doc(userId).get();
            if (userDoc.exists) {
              // جلب رابط الصورة من Firestore
              photoUrl = userDoc.data()?['photoUrl'] ?? '';
            }
          } catch (e) {
            log('Error fetching user image from Firestore: $e');
          }
        }

        // إرسال الإشعار
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
