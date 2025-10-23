import '../../../../core/domain/entitites/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../stores/signup_state.dart';
import '../stores/signup_store.dart';

class SignUpController {
  SignUpController({required this.repository, required this.store});

  final AuthRepository repository;
  final SignUpStore store;

  Future<void> signUp(
    String email,
    String password,
    String displayName, {
    String? familyCode,
  }) async {
    try {
      store.state = SignUpLoading();


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
      store.state = SignUpSuccess(userEntity);
    } catch (e) {
      store.state = SignUpError(e.toString());
    }
  }
}
