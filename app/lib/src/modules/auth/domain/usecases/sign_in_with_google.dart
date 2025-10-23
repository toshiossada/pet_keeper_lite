import '../../../core/domain/entitites/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  SignInWithGoogle(this.repository);

  final AuthRepository repository;

  Future<UserEntity?> call() => repository.signInWithGoogle();
}
