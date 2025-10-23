import '../../../../core/domain/entitites/user_entity.dart';

sealed class SignUpState {}

final class SignUpIdle extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  SignUpSuccess(this.user);

  final UserEntity user;
}

final class SignUpError extends SignUpState {
  SignUpError(this.message);
  final String message;
}
