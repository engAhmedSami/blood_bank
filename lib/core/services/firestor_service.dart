import 'package:blood_bank/core/services/data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addData(
      {required String path,
      required Map<String, dynamic> data,
      String? docuementId}) async {
    if (docuementId != null) {
      await firestore.collection(path).doc(docuementId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  Future<void> updateData({
    required String path,
    required String docuementId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(path).doc(docuementId).update(data);
  }

  @override
  Future<dynamic> getData({required String path, String? docuementId}) async {
    if (docuementId != null) {
      var data = await firestore.collection(path).doc(docuementId).get();
      return data.data();
    } else {
      var data = await firestore.collection(path).get();
      return data.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<bool> checkIfDatatExists(
      {required String path, required String docuementId}) async {
    var data = await firestore.collection(path).doc(docuementId).get();
    return data.exists;
  }
}
