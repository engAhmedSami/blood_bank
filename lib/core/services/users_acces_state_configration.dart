import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UsersAccesStatConfigration {
  static Future<String> getUserState(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users') // Your Firestore collection
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['UserStatusAccessRule'] ?? 'allowedUser';
      } else {
        return 'allowedUser'; // Default state if user document does not exist
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user state: $e');
      }
      return 'allowed'; // Handle error gracefully
    }
  }
}
