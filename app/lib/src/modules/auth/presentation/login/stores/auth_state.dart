import '../../../../core/domain/entitites/user_entity.dart';

sealed class AuthState {}

final class AuthIdle extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  AuthSuccess(this.user);

  final UserEntity user;
}

final class AuthError extends AuthState {
  AuthError(this.message);
  final String message;
}
