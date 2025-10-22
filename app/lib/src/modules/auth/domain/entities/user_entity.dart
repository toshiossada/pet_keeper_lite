class UserEntity {
  UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.familyCode,
    required this.fcmTokens,
  });

  final String id;
  final String email;
  final String displayName;
  final String familyCode;
  final List<String> fcmTokens;

    factory UserEntity.fromCredential({required String id, String? email}) {
    if (email == null || email.isEmpty || id.isEmpty) {
      throw ArgumentError('ID e email não podem ser vazios.');
    }
    return UserEntity(
      id: id,
      email: email,
      displayName: '',
      familyCode: '',
      fcmTokens: [],
    );
  }
}
