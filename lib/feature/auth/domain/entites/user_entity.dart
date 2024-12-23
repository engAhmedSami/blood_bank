class UserEntity {
  final String name;
  final String email;
  final String UserStatusAllowedOrBlocked;
  final String uId;

  UserEntity(
      {required this.name,
      required this.email,
      required this.uId,
      required this.UserStatusAllowedOrBlocked});

  toMap() {
    return {
      'name': name,
      'email': email,
      'uId': uId,
      'UserStatusAllowedOrBlocked': UserStatusAllowedOrBlocked
    };
  }
}
