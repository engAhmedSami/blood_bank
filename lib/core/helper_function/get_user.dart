// import 'dart:convert';

// import 'package:blood_bank/constants.dart';
// import 'package:blood_bank/feature/auth/data/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<UserModel> getUser() async {
//   final prefs = await SharedPreferences.getInstance();
//   final userData = prefs.getString(kUserData);

//   if (userData != null) {
//     final decodedData = jsonDecode(userData);
//     return UserModel.fromJson(decodedData);
//   }

//   // إذا كانت البيانات غير موجودة في SharedPreferences، جلب البيانات من Firebase
//   final currentUser = FirebaseAuth.instance.currentUser;
//   if (currentUser == null) {
//     throw Exception('No user is logged in');
//   }

//   final doc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(currentUser.uid)
//       .get();

//   if (doc.exists) {
//     final data = doc.data()!;
//     prefs.setString(
//         kUserData, jsonEncode(data)); // تخزين البيانات في SharedPreferences
//     return UserModel.fromJson(data);
//   } else {
//     throw Exception('User data not found');
//   }
// }
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<UserModel> getUserStream() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception('No user is logged in');
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((doc) {
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    } else {
      throw Exception('User data not found');
    }
  });
}
