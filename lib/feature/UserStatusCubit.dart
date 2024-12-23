import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class UserStatusCubit extends Cubit<String?> {
//   UserStatusCubit() : super(null);

//   Future<void> checkUserStatus(String deviceId) async {
//     try {
//       var doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(deviceId)
//           .get();

//       if (doc.exists && doc.data() != null) {
//         emit(doc.data()!['users'] as String?);
//       } else {
//         emit('allow'); // السماح بالدخول إذا لم تكن الحالة محددة.
//       }
//     } catch (e) {
//       emit('allow'); // في حالة وجود خطأ، يتم السماح بالدخول.
//     }
//   }
// }

class UserStatusCubit extends Cubit<String?> {
  UserStatusCubit() : super(null);

  Future<void> checkUserStatus(String deviceId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(deviceId)
          .get();

      if (doc.exists && doc.data() != null) {
        // التأكد من وجود حالة للمستخدم
        emit(doc.data()!['userStat'] as String? ?? 'allow');
      } else {
        emit(null); // لا يوجد مستخدم مسجل
      }
    } catch (e) {
      emit(null); // في حالة الخطأ، لا يوجد مستخدم
    }
  }
}
