class UserEntity {
  final String name;
  final String email;
  final String uId;
  // ignore: non_constant_identifier_names
  final String UserStatusAccessRule;

  UserEntity({
    required this.name,
    // ignore: non_constant_identifier_names
    required this.UserStatusAccessRule,
    required this.email,
    required this.uId,
  });

  toMap() {
    return {
      'name': name,
      'UserStatusAccessRule': UserStatusAccessRule,
      'email': email,
      'uId': uId,
    };
  }
}
