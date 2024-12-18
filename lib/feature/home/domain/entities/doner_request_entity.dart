class DonerRequestEntity {
  final String name;
  final num age;
  final String bloodType;
  final String donationType;
  final String idCard;
  final DateTime? lastDonationDate;
  final DateTime? nextDonationDate;
  final String medicalConditions;
  final num contact;
  final String address;
  final String notes;
  final String units;
  final String gender;

  DonerRequestEntity({
    required this.name,
    required this.age,
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
  });
}
