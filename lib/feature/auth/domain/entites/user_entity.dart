class UserEntity {
  final String name;
  final String email;
  final String uId;
  final String userStat; // Added userStat field

  UserEntity({
    required this.name,
    required this.email,
    required this.uId,
    this.userStat = 'allowed', // Default value is 'allowed'
  });

  toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'userStat': userStat, // Include userStat in the map
    };
  }
}
