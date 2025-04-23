abstract class AppAuthEvent {}

class AuthLoginRequested extends AppAuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthLogoutRequested extends AppAuthEvent {}

class AuthRegisterRequested extends AppAuthEvent {
  final String email;
  final String password;
  final String name;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthCheckRequested extends AppAuthEvent {}

class AuthResetPasswordRequested extends AppAuthEvent {
  final String email;

  AuthResetPasswordRequested({required this.email});
}
