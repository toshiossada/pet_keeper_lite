import '../../../core/domain/entitites/user_entity.dart';

class AuthUserModel {
  AuthUserModel({
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

  factory AuthUserModel.fromCredential({required String id, String? email}) {
    if (email == null || email.isEmpty || id.isEmpty) {
      throw ArgumentError('ID e email não podem ser vazios.');
    }
    return AuthUserModel(
      id: id,
      email: email,
      displayName: '',
      familyCode: '',
      fcmTokens: [],
    );
  }

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    displayName: displayName,
    familyCode: familyCode,
    fcmTokens: fcmTokens,
  );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'familyCode': familyCode,
      'fcmTokens': fcmTokens,
    };
  }

  factory AuthUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AuthUserModel(
        id: '',
        email: '',
        displayName: '',
        familyCode: '',
        fcmTokens: [],
      );
    }
    return AuthUserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      familyCode: json['familyCode'] ?? '',
      fcmTokens: List<String>.from(json['fcmTokens'] ?? []),
    );
  }
}
