import 'package:blood_bank/feature/auth/domain/entites/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  final String patientName;
  final String bloodType;
  final String age;
  final String diseaseName;
  final String location;
  final String contactNumber;
  final String? photoUrl;
  final String userState;

  UserModel({
    required super.name,
    required super.UserStatusAllowedOrBlocked,
    required super.email,
    required super.uId,
    required this.patientName,
    required this.bloodType,
    required this.age,
    required this.diseaseName,
    required this.location,
    required this.contactNumber,
    required this.photoUrl,
    required this.userState,
  });

  /// مُعامل لتحويل بيانات FirebaseUser إلى UserModel
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      UserStatusAllowedOrBlocked: 'allowed',
      email: user.email ?? '',
      uId: user.uid,
      patientName: '', // قد تحتاج معالجة إضافية هنا
      bloodType: '',
      age: '',
      diseaseName: '',
      location: '',
      contactNumber: '',
      photoUrl: user.photoURL ?? '',
      userState: '',
    );
  }

  /// لتحويل بيانات JSON (مثلًا من قاعدة البيانات) إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      UserStatusAllowedOrBlocked: json['allaowed'] ?? '',
      email: json['email'] ?? '',
      uId: json['uId'] ?? '',
      patientName: json['patientName'] ?? '',
      bloodType: json['bloodType'] ?? '',
      age: json['age'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      location: json['location'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      userState: json['userState'] ?? '',
    );
  }

  /// لتحويل UserModel إلى Map لتخزينها كـ JSON
  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'patientName': patientName,
      'bloodType': bloodType,
      'age': age,
      'diseaseName': diseaseName,
      'location': location,
      'contactNumber': contactNumber,
      'photoUrl': photoUrl,
      'userState': userState,
    };
  }

  /// لتحويل Entity إلى UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      UserStatusAllowedOrBlocked: 'allowed',
      name: entity.name,
      email: entity.email,
      uId: entity.uId,
      patientName: '',
      bloodType: '',
      age: '',
      diseaseName: '',
      location: '',
      contactNumber: '',
      photoUrl: '',
      userState: '',
    );
  }
}
