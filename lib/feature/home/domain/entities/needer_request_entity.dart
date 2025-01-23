class NeederRequestEntity {
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
  NeederRequestEntity({
    required this.patientName,
    required this.uId,
    required this.age,
    required this.bloodType,
    required this.donationType,
    required this.idCard,
    required this.medicalConditions,
    required this.contact,
    required this.address,
    required this.gender,
    required this.hospitalName,
    required this.status,
    this.dateTime,
  });
}
