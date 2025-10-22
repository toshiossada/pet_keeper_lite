import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';
import 'datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final model = await datasource.signInWithEmail(email, password);
    return model.toEntity();
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final model = await datasource.signInWithGoogle();
    if (model == null) return null;
    return model.toEntity();
  }

  @override
  Future<UserEntity> signUp(
    UserEntity user,
    String password,
  ) async {
    // map entity -> model
    final modelArg = AuthUserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      familyCode: user.familyCode,
      fcmTokens: user.fcmTokens,
    );
    final model = await datasource.signUp(modelArg, password);
    return model.toEntity();
  }

  @override
  Future<void> signOut() async => datasource.signOut();
}
