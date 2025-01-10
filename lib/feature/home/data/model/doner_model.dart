import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';

class DonerModel {
  final String name;
  final num age;
  final String bloodType;
  final String donationType;
  final num idCard;
  final DateTime? lastDonationDate;
  final DateTime? nextDonationDate;
  final DateTime? lastRequestDate;
  final String medicalConditions;
  final num contact;
  final String address;
  final String notes;
  final num units;
  final String gender;
  final String uId;
  final String hospitalName;
  final num distance;
  // final String photoUrl;

  DonerModel({
    required this.name,
    required this.age,
    required this.uId,
    required this.bloodType,
    required this.donationType,
    required this.idCard,
    this.lastDonationDate,
    this.nextDonationDate,
    required this.medicalConditions,
    required this.contact,
    required this.address,
    required this.notes,
    required this.units,
    required this.gender,
    required this.hospitalName,
    required this.distance,
    // required this.photoUrl,
    this.lastRequestDate,
  });
  factory DonerModel.fromEntity(DonerRequestEntity addRequestInputEntity) {
    return DonerModel(
      name: addRequestInputEntity.name,
      age: addRequestInputEntity.age,
      bloodType: addRequestInputEntity.bloodType,
      donationType: addRequestInputEntity.donationType,
      idCard: addRequestInputEntity.idCard,
      lastDonationDate: addRequestInputEntity.lastDonationDate,
      nextDonationDate: addRequestInputEntity.nextDonationDate,
      medicalConditions: addRequestInputEntity.medicalConditions,
      contact: addRequestInputEntity.contact,
      address: addRequestInputEntity.address,
      notes: addRequestInputEntity.notes,
      units: addRequestInputEntity.units,
      gender: addRequestInputEntity.gender,
      uId: addRequestInputEntity.uId,
      hospitalName: addRequestInputEntity.hospitalName,
      distance: addRequestInputEntity.distance,
      // photoUrl: addRequestInputEntity.photoUrl ?? '',
      lastRequestDate: addRequestInputEntity.lastRequestDate,
    );
  }
  toJson() {
    return {
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'donationType': donationType,
      'idCard': idCard,
      'lastDonationDate': lastDonationDate,
      'nextDonationDate': nextDonationDate,
      'medicalConditions': medicalConditions,
      'contact': contact,
      'address': address,
      'notes': notes,
      'units': units,
      'gender': gender,
      'uId': uId,
      'hospitalName': hospitalName,
      'distance': distance,
      // 'photoUrl': photoUrl,
      'lastRequestDate': lastRequestDate
    };
  }
}
