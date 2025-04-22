abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthLogoutRequested extends AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthCheckRequested extends AuthEvent {}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  AuthResetPasswordRequested({required this.email});
}
