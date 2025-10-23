import '../../../core/domain/entitites/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  SignUp(this.repository);

  final AuthRepository repository;

  Future<UserEntity> call(
    UserEntity user,
    String password,
  ) async {
    return repository.signUp(user, password);
  }
}
