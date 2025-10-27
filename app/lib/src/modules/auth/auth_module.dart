import 'package:flutter_modular/flutter_modular.dart';

import '../core/core_module.dart';
import '../core/domain/entitites/user_entity.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/sign_in_with_email.dart';
import 'domain/usecases/sign_in_with_google.dart';
import 'infra/datasources/firebase_auth_datasource.dart';
import 'infra/repositories/auth_repository_impl.dart';
import 'infra/repositories/datasources/auth_datasource.dart';
import 'presentation/login/controllers/auth_controller.dart';
import 'presentation/login/login_page.dart';
import 'presentation/login/stores/auth_store.dart';
import 'presentation/signup/controllers/signup_controller.dart';
import 'presentation/signup/signup_page.dart';
import 'presentation/signup/stores/signup_store.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.add<AuthRepository>(AuthRepositoryImpl.new);
    i.add<AuthDataSource>(FirebaseAuthDataSource.new);
    i.add(SignInWithEmail.new);
    i.add(SignInWithGoogle.new);
    i.add(FirebaseAuthDataSource.new);
    i.addLazySingleton(AuthStore.new);
    i.add(AuthController.new);
    i.add(SignUpController.new);
    i.add(SignUpStore.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (_) => LoginPage(controller: Modular.get<AuthController>()),
    );
    r.child(
      '/signup/:email',
      child: (_) {
        return SignUpPage(
          controller: Modular.get<SignUpController>(),
          user: r.args.data as UserEntity?,
        );
      },
    );
  }
}
