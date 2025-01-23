import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';

class NeederModel {
  final String patientName;
  final num age;
  final String bloodType;
  final String donationType;
  final num idCard;
  final String medicalConditions;
  final num contact;
  final String address;
  final String gender;
  final String uId;
  final String hospitalName;
  final DateTime? dateTime;
  final String status;

  NeederModel({
    required this.patientName,
    required this.age,
    required this.uId,
    required this.bloodType,
    required this.donationType,
    required this.idCard,
    required this.medicalConditions,
    required this.contact,
    required this.address,
    required this.gender,
    required this.hospitalName,
    this.dateTime,
    required this.status,
  });
  factory NeederModel.fromEntity(NeederRequestEntity addNeederInputEntity) {
    return NeederModel(
      patientName: addNeederInputEntity.patientName,
      age: addNeederInputEntity.age,
      bloodType: addNeederInputEntity.bloodType,
      donationType: addNeederInputEntity.donationType,
      idCard: addNeederInputEntity.idCard,
      medicalConditions: addNeederInputEntity.medicalConditions,
      contact: addNeederInputEntity.contact,
      address: addNeederInputEntity.address,
      gender: addNeederInputEntity.gender,
      uId: addNeederInputEntity.uId,
      hospitalName: addNeederInputEntity.hospitalName,
      dateTime: addNeederInputEntity.dateTime,
      status: addNeederInputEntity.status,
    );
  }
  toJson() {
    return {
      'patientName': patientName,
      'age': age,
      'bloodType': bloodType,
      'donationType': donationType,
      'idCard': idCard,
      'medicalConditions': medicalConditions,
      'contact': contact,
      'address': address,
      'gender': gender,
      'uId': uId,
      'hospitalName': hospitalName,
      'dateTime': dateTime,
      'status': status,
    };
  }
}
