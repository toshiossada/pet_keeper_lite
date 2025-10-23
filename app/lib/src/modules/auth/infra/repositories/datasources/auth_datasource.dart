import '../../models/auth_user_model.dart';

abstract class AuthDataSource {
  Future<AuthUserModel> signInWithEmail(String email, String password);
  Future<AuthUserModel?> signInWithGoogle();
  Future<Map<String, dynamic>?> emailExists(String email);
  Future<AuthUserModel> signUp(
    AuthUserModel user,
    String password,
  );
  Future<void> signOut();
}
