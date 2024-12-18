import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

Stream<Map<String, dynamic>> getCombinedData() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception('No user is logged in');
  }

  // Stream لبيانات المستخدم
  final userStream = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots();

  // Stream لطلبات التبرع
  final bloodNeededStream =
      FirebaseFirestore.instance.collection('blood_requests').snapshots();

  // دمج البيانات
  return Rx.combineLatest2(
    userStream,
    bloodNeededStream,
    (DocumentSnapshot userDoc, QuerySnapshot bloodRequestsSnapshot) {
      return {
        'user': userDoc.exists ? userDoc.data() ?? {} : {},
        'bloodRequests': bloodRequestsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList(),
      };
    },
  );
}
