import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../stores/auth_state.dart';
import '../stores/auth_store.dart';

class AuthController {
  AuthController({required this.repository, required this.store});

  final AuthRepository repository;
  final AuthStore store;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      store.setState(AuthLoading());
      final user = await repository.signInWithEmail(email, password);
      store.setState(AuthSuccess(user));
    } catch (e) {
      store.setState(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      store.setState(AuthLoading());
      final user = await repository.signInWithGoogle();
      if (user == null) {
        store.setState(AuthIdle());
      } else {
        store.setState(AuthSuccess(user));
      }
    } catch (e) {
      store.setState(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    store.setState(AuthIdle());
  }

  Future<void> signUp(
    String email,
    String password,
    String displayName, {
    String? familyCode,
  }) async {
    try {
      store.setState(AuthLoading());
      final userEntity = await repository.signUp(
        UserEntity(
          id: '',
          email: email,
          displayName: displayName,
          familyCode: familyCode ?? '',
          fcmTokens: [],
        ),
        password,
      );
      store.setState(AuthSuccess(userEntity));
    } catch (e) {
      store.setState(AuthError(e.toString()));
    }
  }
}
