import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity?> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity> signUp(UserEntity user, String password);
}
