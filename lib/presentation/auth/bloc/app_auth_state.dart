import '../../../domain/repositories/auth_repository.dart';

abstract class AppAuthState {}

class AuthInitial extends AppAuthState {}

class AuthLoading extends AppAuthState {}

class AuthAuthenticated extends AppAuthState {
  final UserEntity user;

  AuthAuthenticated({required this.user});
}

class AuthUnauthenticated extends AppAuthState {}

class AuthError extends AppAuthState {
  final String message;

  AuthError({required this.message});
}

class AuthPasswordResetSuccess extends AppAuthState {
  final String email;

  AuthPasswordResetSuccess({required this.email});
}

class AuthPasswordResetFailure extends AppAuthState {
  final String error;

  AuthPasswordResetFailure({required this.error});
}
