import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/domain/entitites/user_entity.dart';
import '../../../../core/presenter/controllers/app_controller.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../stores/auth_state.dart';
import '../stores/auth_store.dart';

class AuthController {
  AuthController({
    required this.repository,
    required this.store,
    required this.appController,
  });

  final AuthRepository repository;
  final AuthStore store;
  final AppController appController;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      store.setState(AuthLoading());
      final user = await repository.signInWithEmail(email, password);
      appController.store.user = user;
      store.setState(AuthSuccess(user));
    } catch (e) {
      appController.store.user = null;
      store.setState(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      store.setState(AuthLoading());
      final user = await repository.signInWithGoogle();
      if (user?.id.isEmpty ?? true) {
        store.setState(AuthIdle());
        Modular.to.pushNamed('/auth/signup', arguments: user);
      } else {
        appController.store.user = user;
        store.setState(AuthSuccess(user!));
        Modular.to.navigate('/pet');
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
