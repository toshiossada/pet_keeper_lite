import '../../../core/domain/entitites/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmail {
  SignInWithEmail(this.repository);

  final AuthRepository repository;

  Future<UserEntity> call(String email, String password) async {
    return repository.signInWithEmail(email, password);
  }
}
