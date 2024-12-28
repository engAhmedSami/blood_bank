import 'dart:developer';

import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_donner_request_state.dart';

class AddDonerRequestCubit extends Cubit<AddDonerRequestState> {
  AddDonerRequestCubit(
    this.donerRepo,
  ) : super(AddDonerRequestInitial());

  final DonerRepo donerRepo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRequest(DonerRequestEntity addRequestInputEntity) async {
    emit(AddDonerRequestLoading());
    final result = await donerRepo.addRequest(addRequestInputEntity);
    result.fold(
        (f) => emit(
              AddDonerRequestFailure(f.message),
            ),
        (r) => emit(AddDonerRequestSuccess()));
    // جلب بيانات المستخدم من Firestore
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    String userName = user?.displayName ?? 'Anonymous';
    String userEmail = user?.email ?? 'No Email';
    String photoUrl = ''; // سيتم جلب الرابط من Firestore

    if (userId != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(userId).get();
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
      body: '${addRequestInputEntity.name} Wants to donate blood!',
      data: {
        'type': 'new_request',
        'request_id': addRequestInputEntity.uId,
        'user_name': userName,
        'user_email': userEmail,
        'photoUrl': photoUrl,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
